# Postgres

* TOC
{:toc}

## Quick Reference

**MVCC (Multiversion Concurrency Control)**:
- PostgreSQL uses row versioning (xmin/xmax) instead of locks for read concurrency
- Readers never block writers, writers never block readers
- Old row versions become dead tuples, cleaned by VACUUM

**Transaction Isolation Levels**:
- **Read Committed** (default): New snapshot per statement, no serialization errors, allows non-repeatable reads
- **Repeatable Read**: Single snapshot per transaction, fails on concurrent updates, prevents most anomalies
- **Serializable**: Prevents all anomalies via dependency tracking, highest overhead (20-50%), requires retry logic

**Row-Level Locking**:
- **FOR UPDATE**: Exclusive lock, prevents all modifications
- **FOR NO KEY UPDATE**: Allows foreign key checks
- **FOR SHARE**: Shared lock, multiple readers allowed
- **FOR KEY SHARE**: Weakest, allows non-key updates
- **SKIP LOCKED**: Essential for job queues (skip locked rows)
- **NOWAIT**: Fail fast for user-facing operations

**Common Use Cases**:
- Simple CRUD → Read Committed (default)
- Financial reports → Repeatable Read
- Complex business rules → Serializable
- Job queues → SELECT FOR UPDATE SKIP LOCKED
- User reservations → SELECT FOR UPDATE NOWAIT

## Commands
1. List databases
    ```
    \list
    \l
    ```
1. Connect to database
    ```
    \connect database_name
    ```
1. List all tables
    ```
    \dt
    ```
1. Describe table
    ```
    \d table
    ```
1. Show indexes
    ```
    \di
    ```

## Multiversion Concurrency Control (MVCC)

MVCC is PostgreSQL's approach to handling concurrent transactions without traditional locking. Instead of locking rows, PostgreSQL creates multiple versions of each row, allowing readers and writers to work simultaneously without blocking each other.

### How MVCC Works

**Core Concept**: When a row is updated or deleted, PostgreSQL doesn't immediately remove the old version. Instead, it creates a new version while keeping the old one, allowing concurrent transactions to see the appropriate version based on their transaction snapshot.

**Key Components**:

1. **Transaction IDs (XID)**: Each transaction gets a unique, monotonically increasing transaction ID
2. **Tuple Headers**: Each row version (tuple) stores metadata:
   - `xmin`: Transaction ID that created this version
   - `xmax`: Transaction ID that deleted/updated this version (0 if still current)
   - `cmin`/`cmax`: Command IDs within the transaction
   - `ctid`: Physical location (page, offset)

3. **Transaction Snapshot**: When a transaction starts, it captures a snapshot containing:
   - `xmin`: Oldest active transaction
   - `xmax`: First not-yet-assigned transaction ID
   - `xip_list`: List of active transactions at snapshot time

### Visibility Rules

PostgreSQL determines tuple visibility using these rules:

```sql
-- A tuple is visible if:
-- 1. xmin is committed AND xmin < snapshot.xmax AND xmin NOT IN snapshot.xip_list
-- 2. xmax is 0 OR xmax is not committed OR xmax >= snapshot.xmax OR xmax IN snapshot.xip_list
```

**Example**:

```sql
-- Session 1: Transaction ID = 100
BEGIN;
INSERT INTO users (id, name) VALUES (1, 'Alice');
-- Creates tuple: xmin=100, xmax=0

-- Session 2: Transaction ID = 101 (starts before Session 1 commits)
BEGIN;
SELECT * FROM users WHERE id = 1;
-- Returns nothing because xmin=100 is not committed yet

-- Session 1 commits
COMMIT;

-- Session 2 (still in transaction)
SELECT * FROM users WHERE id = 1;
-- Still returns nothing because transaction snapshot was taken before xid=100 committed

-- Session 2 commits and starts new transaction
COMMIT;
BEGIN;
SELECT * FROM users WHERE id = 1;
-- Now returns Alice because xid=100 is in the past and committed
```

**Note**: Different [transaction isolation levels](#transaction-isolation-levels) use these visibility rules differently - Read Committed takes a new snapshot per statement, while Repeatable Read uses a single snapshot for the entire transaction.

### VACUUM and Dead Tuples

When rows are updated or deleted, old versions become "dead tuples" that are invisible to all transactions.

**VACUUM Process**:
1. Identifies dead tuples (xmax is committed and older than all active transactions)
2. Marks space as reusable
3. Updates free space map (FSM)
4. Prevents transaction ID wraparound

```sql
-- Manual vacuum
VACUUM users;

-- Vacuum with detailed info
VACUUM VERBOSE users;

-- Aggressive vacuum (also updates visibility map)
VACUUM FULL users;

-- Analyze table statistics while vacuuming
VACUUM ANALYZE users;
```

### Transaction ID Wraparound

PostgreSQL uses 32-bit transaction IDs, which wrap around after ~4 billion transactions. If not managed, this can lead to data loss as old transactions appear "in the future."

**Why Wraparound is Dangerous**:
```
Transaction IDs are circular:
... → 2 billion → 3 billion → 4 billion → 0 → 1 → 2 → ...

If XID wraps without freezing:
- Old committed data (XID=100) suddenly looks "uncommitted" (XID in future)
- Rows become invisible, causing apparent data loss
```

**Monitoring Wraparound Risk**:
```sql
-- Check age of oldest unfrozen transaction per database
SELECT datname, age(datfrozenxid) as xid_age,
       pg_size_pretty(pg_database_size(datname)) as size
FROM pg_database
ORDER BY age(datfrozenxid) DESC;

-- Warning thresholds:
-- < 200M: Safe (green)
-- 200M-1B: Autovacuum will be aggressive (yellow)
-- 1B-2B: Critical, manual intervention needed (red)
-- > 2B: Emergency, database will shut down (black)

-- Check per-table age
SELECT schemaname, tablename,
       age(relfrozenxid) as xid_age,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
FROM pg_stat_user_tables
ORDER BY age(relfrozenxid) DESC
LIMIT 20;
```

**Prevention Strategies**:
```sql
-- 1. Ensure autovacuum is running
SHOW autovacuum;  -- Should be 'on'

-- 2. Check autovacuum freeze settings
SHOW autovacuum_freeze_max_age;  -- Default: 200 million

-- 3. For critical tables, reduce freeze age
ALTER TABLE important_table SET (
    autovacuum_freeze_max_age = 100000000,  -- 100M instead of 200M
    autovacuum_freeze_min_age = 5000000     -- 5M
);

-- 4. Manual freeze for large tables during low-traffic periods
VACUUM FREEZE users;

-- 5. Aggressive vacuum if approaching limits
VACUUM FREEZE VERBOSE large_table;
```

**Emergency Response** (if age > 1 billion):
```sql
-- 1. Check which tables are problematic
SELECT schemaname, tablename, age(relfrozenxid)
FROM pg_stat_user_tables
WHERE age(relfrozenxid) > 1000000000
ORDER BY age(relfrozenxid) DESC;

-- 2. Freeze them immediately (may take hours for large tables)
VACUUM FREEZE VERBOSE problematic_table;

-- 3. Monitor progress
SELECT schemaname, tablename,
       age(relfrozenxid) as xid_age,
       n_dead_tup,
       last_vacuum,
       last_autovacuum
FROM pg_stat_user_tables
WHERE tablename = 'problematic_table';
```

### Best Practices

1. **Monitor Table Bloat**:
```sql
SELECT schemaname, tablename,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
       n_dead_tup, n_live_tup,
       ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_ratio
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;
```

2. **Configure Autovacuum Appropriately**:
```sql
-- For high-write tables
ALTER TABLE users SET (
    autovacuum_vacuum_scale_factor = 0.05,  -- Vacuum at 5% dead tuples
    autovacuum_analyze_scale_factor = 0.02  -- Analyze at 2% changes
);
```

3. **Keep Transactions Short**: Long-running transactions prevent VACUUM from cleaning up dead tuples and advancing freeze horizon

4. **Monitor Transaction Age**:
```sql
SELECT pid, usename, datname, state,
       age(backend_xid) as xid_age,
       age(backend_xmin) as xmin_age,
       now() - xact_start as duration
FROM pg_stat_activity
WHERE backend_xid IS NOT NULL OR backend_xmin IS NOT NULL
ORDER BY GREATEST(age(backend_xid), age(backend_xmin)) DESC;
```

5. **Set Up Monitoring Alerts**:
   - Alert when any database age(datfrozenxid) > 200M
   - Alert when any table age(relfrozenxid) > 500M
   - Alert when autovacuum workers are consistently maxed out

## Transaction Isolation Levels

PostgreSQL implements four transaction isolation levels defined by SQL standard, though READ UNCOMMITTED behaves like READ COMMITTED. [Understanding MVCC](#multiversion-concurrency-control-mvcc) is essential for understanding how these isolation levels work.

### How MVCC Implements Isolation Levels

**Snapshot Timing** - The key difference between isolation levels:
- **Read Committed**: Takes a NEW snapshot at the start of EACH statement
- **Repeatable Read**: Takes ONE snapshot at the start of the FIRST query in the transaction
- **Serializable**: Takes ONE snapshot like Repeatable Read, PLUS tracks read-write dependencies

**Key Insight**: Snapshots are taken at the first query, not at BEGIN. Transactions starting with non-query statements (SET, LOCK TABLE) delay snapshot creation until the first actual query.

### 1. Read Uncommitted

```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- In PostgreSQL, this behaves exactly like READ COMMITTED
-- No dirty reads are possible
```

**Behavior**: Identical to READ COMMITTED in PostgreSQL. PostgreSQL doesn't support dirty reads.

### 2. Read Committed (Default)

Each statement within a transaction sees a snapshot of committed data at the time the statement began.

```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Session 1
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

-- Session 2 (Read Committed)
BEGIN;
SELECT balance FROM accounts WHERE id = 1;
-- Returns OLD value (before Session 1 update)

-- Session 1 commits
COMMIT;

-- Session 2 (same transaction, new statement)
SELECT balance FROM accounts WHERE id = 1;
-- Returns NEW value (after Session 1 update)
-- Each statement gets fresh snapshot!

COMMIT;
```

**Issues**:
- **Non-repeatable reads**: Same query returns different results within transaction
- **Phantom reads**: New rows can appear between queries

**Use Cases**:
- Default for most applications
- Good for short, simple transactions
- Acceptable when slight inconsistencies don't matter

### 3. Repeatable Read

Transaction sees a snapshot of the database as of the first query in the transaction.

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Session 1
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE id = 1;
-- Returns: 1000

-- Session 2
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
COMMIT;

-- Session 1 (same transaction)
SELECT balance FROM accounts WHERE id = 1;
-- Still returns: 1000 (snapshot isolation!)

-- Try to update
UPDATE accounts SET balance = balance + 50 WHERE id = 1;
-- ERROR: could not serialize access due to concurrent update

COMMIT;
```

**Behavior**:
- Single snapshot for entire transaction
- Prevents non-repeatable reads
- Prevents most phantom reads (PostgreSQL-specific)
- UPDATE/DELETE/SELECT FOR UPDATE fail with serialization error if row was modified

**Write Skew Example**:
```sql
-- Two doctors on call, at least one must be on-call
-- Session 1
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM doctors WHERE on_call = true;  -- Returns 2
UPDATE doctors SET on_call = false WHERE id = 1;

-- Session 2 (concurrent)
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM doctors WHERE on_call = true;  -- Returns 2
UPDATE doctors SET on_call = false WHERE id = 2;

-- Both commit successfully
-- Result: 0 doctors on call! (write skew anomaly)
```

**Use Cases**:
- Reports requiring consistent snapshot
- Read-heavy workloads
- Batch processing where consistency matters

### 4. Serializable

Strongest isolation level. Transactions execute as if they ran serially, one after another.

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Same write skew scenario
-- Session 1
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM doctors WHERE on_call = true;  -- Returns 2
UPDATE doctors SET on_call = false WHERE id = 1;
COMMIT;  -- Success

-- Session 2
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM doctors WHERE on_call = true;  -- Returns 2
UPDATE doctors SET on_call = false WHERE id = 2;
COMMIT;  -- ERROR: could not serialize access due to read/write dependencies
```

**Implementation**: Uses Serializable Snapshot Isolation (SSI)
- Detects dangerous structures (rw-conflicts)
- Aborts transactions that would create anomalies
- More efficient than traditional 2PL (two-phase locking)

**Performance Cost**:
- Additional tracking of read/write dependencies
- Higher abort rate
- More retries needed

**Use Cases**:
- Financial transactions requiring absolute consistency
- Complex business rules spanning multiple queries
- When correctness is more important than performance

### Comparison Table

| Isolation Level | Dirty Read | Non-Repeatable Read | Phantom Read | Write Skew | Serialization Anomaly |
|----------------|------------|---------------------|--------------|------------|----------------------|
| Read Uncommitted | No* | Yes | Yes | Yes | Yes |
| Read Committed | No | Yes | Yes | Yes | Yes |
| Repeatable Read | No | No | No** | Yes | Yes |
| Serializable | No | No | No | No | No |

*PostgreSQL doesn't support dirty reads
**PostgreSQL prevents phantom reads in Repeatable Read (stronger than SQL standard)

### Common Pitfalls

1. **Lost Updates in Read Committed**:
```sql
-- WRONG: Read-then-write pattern
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- Reads 100
-- Calculate new balance in application
UPDATE accounts SET balance = 110 WHERE id = 1;  -- Lost update possible!
COMMIT;

-- CORRECT: Use atomic operations
BEGIN;
UPDATE accounts SET balance = balance + 10 WHERE id = 1;
COMMIT;

-- OR: Use SELECT FOR UPDATE (see SELECT FOR UPDATE section)
BEGIN;
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;  -- Locks row
-- Calculate new balance
UPDATE accounts SET balance = 110 WHERE id = 1;
COMMIT;
```
**See also**: [SELECT FOR UPDATE](#select-for-update) for row-level locking strategies

2. **Forgetting Retry Logic for Repeatable Read/Serializable**:
```python
# WRONG: No retry logic
def transfer(from_id, to_id, amount):
    conn.execute("BEGIN ISOLATION LEVEL SERIALIZABLE")
    # ... transfer logic ...
    conn.execute("COMMIT")  # May raise SerializationError!

# CORRECT: With exponential backoff
def transfer_with_retry(from_id, to_id, amount, max_attempts=3):
    for attempt in range(max_attempts):
        try:
            conn.execute("BEGIN ISOLATION LEVEL SERIALIZABLE")
            # ... transfer logic ...
            conn.execute("COMMIT")
            return  # Success
        except SerializationError:
            if attempt == max_attempts - 1:
                raise
            time.sleep(0.1 * (2 ** attempt))
```

3. **Long-Running Transactions**:
```sql
-- BAD: Holds snapshot for minutes/hours
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM large_table;  -- Takes 30 minutes
-- Meanwhile: blocks VACUUM, prevents autovacuum from cleaning dead tuples
UPDATE small_table SET status = 'done';
COMMIT;

-- GOOD: Keep transactions short
SELECT * FROM large_table;  -- Outside transaction
BEGIN;
UPDATE small_table SET status = 'done';
COMMIT;
```

4. **Deadlocks from Inconsistent Lock Ordering**:
```sql
-- Transaction 1
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Transaction 2 (concurrent) - DEADLOCK RISK!
BEGIN;
UPDATE accounts SET balance = balance - 50 WHERE id = 2;  -- Different order!
UPDATE accounts SET balance = balance + 50 WHERE id = 1;
COMMIT;

-- SOLUTION: Always lock in same order
BEGIN;
SELECT balance FROM accounts WHERE id IN (1, 2) ORDER BY id FOR UPDATE;
-- Now safe to update in any order
COMMIT;
```

5. **Assuming Serializable is Always Safe**:
```sql
-- Even Serializable can't prevent application logic errors
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT balance FROM accounts WHERE id = 1;  -- Returns 100
-- Application bug: forgot to check if balance >= withdrawal
UPDATE accounts SET balance = balance - 200 WHERE id = 1;  -- Now -100!
COMMIT;  -- Succeeds! Database can't know business rules

-- SOLUTION: Enforce constraints in database
ALTER TABLE accounts ADD CONSTRAINT positive_balance CHECK (balance >= 0);
```

6. **Mixing Isolation Levels Without Understanding**:
```sql
-- Transaction 1: Read Committed
BEGIN;
UPDATE inventory SET quantity = quantity - 5 WHERE product_id = 1;

-- Transaction 2: Serializable
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT SUM(quantity) FROM inventory;  -- May see inconsistent state
COMMIT;
-- No error, but data might be inconsistent

-- SOLUTION: Use same isolation level for related operations
```

### Best Practices

1. **Use Default (Read Committed) Unless You Need More**:
```sql
-- Most applications work fine with default
BEGIN;  -- Implicitly READ COMMITTED
```

2. **Implement Retry Logic for Serialization Failures**:
```python
def execute_with_retry(func, max_attempts=3):
    for attempt in range(max_attempts):
        try:
            return func()
        except SerializationError:
            if attempt == max_attempts - 1:
                raise
            time.sleep(0.1 * (2 ** attempt))  # Exponential backoff
```

3. **Choose Isolation Level Based on Requirements**:
```sql
-- Simple CRUD: Read Committed (default)
BEGIN;

-- Consistent reports: Repeatable Read
BEGIN ISOLATION LEVEL REPEATABLE READ;

-- Financial transfers with complex logic: Serializable
BEGIN ISOLATION LEVEL SERIALIZABLE;
```

4. **Minimize Transaction Duration**:
```sql
-- Bad: Long transaction holds snapshot
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM large_table;  -- Takes 10 minutes
UPDATE small_table SET status = 'done';
COMMIT;

-- Good: Separate concerns
BEGIN;
UPDATE small_table SET status = 'done';
COMMIT;
-- Run long query outside transaction
SELECT * FROM large_table;
```

5. **Monitor Serialization Failures**:
```sql
SELECT datname,
       xact_commit,
       xact_rollback,
       deadlocks,
       blk_read_time + blk_write_time as io_time
FROM pg_stat_database
WHERE datname = current_database();
```

## SELECT FOR UPDATE

SELECT FOR UPDATE locks rows returned by a SELECT query, preventing other transactions from modifying or locking them until the transaction completes. This provides an alternative to higher [isolation levels](#transaction-isolation-levels) for preventing lost updates and race conditions.

**When to use**: Row-level locking is often more efficient than Serializable isolation when you only need to protect specific rows, not enforce complex business rules across multiple queries.

### Basic Syntax

```sql
SELECT * FROM table_name
WHERE condition
FOR UPDATE;
```

### Lock Modes

PostgreSQL provides four row-level locking modes:

#### 1. FOR UPDATE

**Strongest lock**: Prevents other transactions from UPDATE, DELETE, SELECT FOR UPDATE, or SELECT FOR SHARE.

```sql
-- Session 1
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
-- Acquires exclusive lock on row

-- Session 2
BEGIN;
UPDATE accounts SET balance = balance + 100 WHERE id = 1;
-- BLOCKS until Session 1 commits or rolls back

SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
-- BLOCKS

SELECT * FROM accounts WHERE id = 1 FOR SHARE;
-- BLOCKS

SELECT * FROM accounts WHERE id = 1;  -- Without FOR...
-- SUCCEEDS (reads are not blocked by MVCC)
```

**Use Case**: When you need to read and then update rows

```sql
-- Withdraw money safely
BEGIN;
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;
-- Check if balance >= withdrawal amount
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
COMMIT;
```

#### 2. FOR NO KEY UPDATE

**Weaker lock**: Like FOR UPDATE but allows SELECT FOR KEY SHARE locks (for foreign key checks).

```sql
-- Session 1
BEGIN;
SELECT * FROM users WHERE id = 1 FOR NO KEY UPDATE;

-- Session 2
BEGIN;
-- This succeeds (foreign key check)
INSERT INTO orders (user_id, amount) VALUES (1, 100);

-- This blocks (actual update)
UPDATE users SET name = 'Bob' WHERE id = 1;
```

**Use Case**: When you want to lock a row for update but still allow foreign key references

```sql
BEGIN;
SELECT * FROM users WHERE id = 1 FOR NO KEY UPDATE;
UPDATE users SET last_login = now() WHERE id = 1;
COMMIT;
```

#### 3. FOR SHARE

**Shared lock**: Multiple transactions can hold FOR SHARE locks simultaneously. Prevents UPDATE/DELETE but allows other FOR SHARE locks.

```sql
-- Session 1
BEGIN;
SELECT * FROM products WHERE id = 1 FOR SHARE;

-- Session 2
BEGIN;
SELECT * FROM products WHERE id = 1 FOR SHARE;
-- SUCCEEDS (multiple shared locks allowed)

UPDATE products SET stock = stock - 1 WHERE id = 1;
-- BLOCKS (can't update while shared lock exists)
```

**Use Case**: When multiple transactions need to ensure a row doesn't change but don't plan to modify it

```sql
-- Order processing: ensure product isn't deleted while processing
BEGIN;
SELECT * FROM products WHERE id = 1 FOR SHARE;
-- Process order...
INSERT INTO order_items (order_id, product_id, quantity) VALUES (123, 1, 5);
COMMIT;
```

#### 4. FOR KEY SHARE

**Weakest lock**: Allows FOR NO KEY UPDATE but blocks FOR UPDATE and DELETE.

```sql
-- Session 1
BEGIN;
SELECT * FROM users WHERE id = 1 FOR KEY SHARE;

-- Session 2
BEGIN;
-- Succeeds (no key update)
UPDATE users SET last_login = now() WHERE id = 1;

-- Blocks (key update)
UPDATE users SET id = 2 WHERE id = 1;

-- Blocks (delete)
DELETE FROM users WHERE id = 1;
```

**Use Case**: Automatically used by PostgreSQL for foreign key checks

### Optional Clauses

#### NOWAIT

Return error immediately if lock cannot be acquired.

```sql
-- Session 1
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;

-- Session 2
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE NOWAIT;
-- ERROR: could not obtain lock on row in relation "accounts"
-- Returns immediately instead of waiting
```

**Use Case**: Avoid blocking in user-facing applications

```python
try:
    cursor.execute("""
        SELECT * FROM queue
        WHERE status = 'pending'
        LIMIT 1
        FOR UPDATE NOWAIT
    """)
    row = cursor.fetchone()
    if row:
        process(row)
except LockNotAvailable:
    # Try another queue item or return
    pass
```

#### SKIP LOCKED

Skip rows that are already locked by other transactions.

```sql
-- Session 1
BEGIN;
SELECT * FROM queue WHERE id IN (1, 2, 3) FOR UPDATE;
-- Locks rows 1, 2, 3

-- Session 2
BEGIN;
SELECT * FROM queue WHERE id IN (1, 2, 3, 4, 5)
FOR UPDATE SKIP LOCKED;
-- Returns only rows 4, 5 (skips locked rows 1, 2, 3)
```

**Use Case**: Implementing job queues with multiple workers

```sql
-- Worker process
BEGIN;
SELECT * FROM jobs
WHERE status = 'pending'
ORDER BY created_at
LIMIT 10
FOR UPDATE SKIP LOCKED;

-- Process jobs...
UPDATE jobs SET status = 'completed' WHERE id = ANY($1);
COMMIT;
```

#### OF table_name

Lock only rows from specified tables in a join.

```sql
SELECT u.*, o.*
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.id = 1
FOR UPDATE OF u;
-- Locks only the users row, not the orders row
```

### Lock Compatibility Matrix

| Current Lock | FOR KEY SHARE | FOR SHARE | FOR NO KEY UPDATE | FOR UPDATE |
|--------------|---------------|-----------|-------------------|------------|
| FOR KEY SHARE | ✓ | ✓ | ✓ | ✗ |
| FOR SHARE | ✓ | ✓ | ✗ | ✗ |
| FOR NO KEY UPDATE | ✓ | ✗ | ✗ | ✗ |
| FOR UPDATE | ✗ | ✗ | ✗ | ✗ |

### Practical Examples

#### 1. Bank Transfer (Prevent Lost Updates)

```sql
BEGIN;

-- Lock both accounts in consistent order to prevent deadlocks
SELECT balance FROM accounts
WHERE id IN (1, 2)
ORDER BY id
FOR UPDATE;

-- Perform transfer
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT;
```

#### 2. Inventory Management

```sql
BEGIN;

-- Check and reserve inventory
SELECT stock FROM products
WHERE id = 123
FOR UPDATE;

-- If stock is sufficient
UPDATE products
SET stock = stock - 5
WHERE id = 123 AND stock >= 5;

-- Check if update succeeded
IF NOT FOUND THEN
    RAISE EXCEPTION 'Insufficient stock';
END IF;

COMMIT;
```

#### 3. Job Queue with Multiple Workers

```sql
-- Worker loop
LOOP
    BEGIN;

    -- Get next available job
    SELECT * FROM jobs
    WHERE status = 'pending'
    ORDER BY priority DESC, created_at
    LIMIT 1
    FOR UPDATE SKIP LOCKED;

    -- If no job found, wait and retry
    IF NOT FOUND THEN
        COMMIT;
        PERFORM pg_sleep(1);
        CONTINUE;
    END IF;

    -- Mark as processing
    UPDATE jobs SET status = 'processing', started_at = now()
    WHERE id = job.id;

    COMMIT;

    -- Process job (outside transaction)
    PERFORM process_job(job);

    -- Mark as complete
    UPDATE jobs SET status = 'completed', completed_at = now()
    WHERE id = job.id;

END LOOP;
```

#### 4. Optimistic Locking Alternative

```sql
-- Instead of SELECT FOR UPDATE, use version field
BEGIN;

SELECT id, balance, version FROM accounts WHERE id = 1;

-- Update with version check
UPDATE accounts
SET balance = balance - 100,
    version = version + 1
WHERE id = 1 AND version = $old_version;

-- Check if update succeeded
IF NOT FOUND THEN
    RAISE EXCEPTION 'Concurrent modification detected';
END IF;

COMMIT;
```

### Best Practices

1. **Lock Rows in Consistent Order (Prevent Deadlocks)**:
```sql
-- Bad: Different order in different transactions
BEGIN;
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
SELECT * FROM accounts WHERE id = 2 FOR UPDATE;
COMMIT;

-- Good: Always same order
BEGIN;
SELECT * FROM accounts WHERE id IN (1, 2) ORDER BY id FOR UPDATE;
-- Operations...
COMMIT;
```

2. **Keep Locked Transactions Short**:
```sql
-- Bad: Lock held during external API call
BEGIN;
SELECT * FROM orders WHERE id = 1 FOR UPDATE;
-- Call external payment API (takes 3 seconds)
UPDATE orders SET status = 'paid' WHERE id = 1;
COMMIT;

-- Good: Lock only for database operations
BEGIN;
SELECT * FROM orders WHERE id = 1 FOR UPDATE;
UPDATE orders SET status = 'processing' WHERE id = 1;
COMMIT;
-- Call external API
UPDATE orders SET status = 'paid' WHERE id = 1;
```

3. **Use NOWAIT for User-Facing Operations**:
```sql
-- Avoid making users wait for locks
BEGIN;
SELECT * FROM seats
WHERE seat_number = 'A1'
FOR UPDATE NOWAIT;

UPDATE seats SET reserved_by = $user_id;
COMMIT;

-- Handle lock error gracefully
EXCEPTION WHEN lock_not_available THEN
    RETURN 'Seat is being reserved by another user';
```

4. **Use SKIP LOCKED for Job Queues**:
```sql
-- Multiple workers can process queue concurrently
SELECT * FROM tasks
WHERE status = 'pending'
ORDER BY priority DESC
LIMIT 10
FOR UPDATE SKIP LOCKED;
```

5. **Choose Appropriate Lock Strength**:
```sql
-- Overkill: FOR UPDATE when you just need to ensure row exists
SELECT * FROM users WHERE id = 1 FOR UPDATE;

-- Better: FOR SHARE if you're not updating
SELECT * FROM users WHERE id = 1 FOR SHARE;

-- Best: No lock if you're just reading
SELECT * FROM users WHERE id = 1;
```

6. **Monitor Lock Waits**:
```sql
-- See blocked queries
SELECT blocked_locks.pid AS blocked_pid,
       blocked_activity.usename AS blocked_user,
       blocking_locks.pid AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       blocked_activity.query AS blocked_statement,
       blocking_activity.query AS blocking_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.database IS NOT DISTINCT FROM blocked_locks.database
    AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
    AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;
```

7. **Consider Alternatives**:
   - **Advisory Locks**: For application-level locking
   - **Optimistic Locking**: For low-contention scenarios
   - **SERIALIZABLE Isolation**: For complex business rules
   - **Queue Tables**: For high-throughput job processing
