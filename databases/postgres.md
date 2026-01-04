# Postgres

* TOC
{:toc}

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

### MVCC Behavior Across Isolation Levels

MVCC implements different isolation levels by controlling when and how transaction snapshots are taken. Understanding these differences is critical for choosing the right isolation level.

#### Snapshot Timing

**Read Committed**: Takes a NEW snapshot at the start of EACH statement
**Repeatable Read**: Takes ONE snapshot at the start of the FIRST statement in the transaction
**Serializable**: Takes ONE snapshot like Repeatable Read, but adds dependency tracking

```sql
-- Demonstrate snapshot timing differences

-- Setup
CREATE TABLE balances (id INT PRIMARY KEY, amount INT);
INSERT INTO balances VALUES (1, 100);

-- Session 1: Read Committed (default)
BEGIN;  -- Transaction starts but NO snapshot taken yet
SELECT pg_sleep(2);  -- Wait 2 seconds

-- Session 2: Make a change during Session 1's sleep
BEGIN;
UPDATE balances SET amount = 200 WHERE id = 1;
COMMIT;

-- Session 1: First statement - snapshot taken NOW
SELECT amount FROM balances WHERE id = 1;
-- Returns: 200 (sees Session 2's committed change)

-- Session 2: Make another change
UPDATE balances SET amount = 300 WHERE id = 1;

-- Session 1: Second statement - NEW snapshot taken
SELECT amount FROM balances WHERE id = 1;
-- Returns: 300 (sees latest committed data)

COMMIT;
```

```sql
-- Same scenario with Repeatable Read

-- Session 1: Repeatable Read
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT pg_sleep(2);  -- Wait 2 seconds (still no snapshot)

-- Session 2: Make a change
BEGIN;
UPDATE balances SET amount = 200 WHERE id = 1;
COMMIT;

-- Session 1: First statement - snapshot taken NOW (after commit)
SELECT amount FROM balances WHERE id = 1;
-- Returns: 200 (snapshot includes Session 2's change)

-- Session 2: Make another change
UPDATE balances SET amount = 300 WHERE id = 1;

-- Session 1: Second statement - SAME snapshot used
SELECT amount FROM balances WHERE id = 1;
-- Returns: 200 (snapshot was frozen at first query)

COMMIT;
```

**Key Insight**: The snapshot is taken at the first query, not at BEGIN. Transactions that start with non-query statements (like SET, LOCK TABLE) delay snapshot creation.

#### Read Committed: Per-Statement Snapshots

In Read Committed, each statement operates on a fresh snapshot of committed data.

**Snapshot Creation**:
```
Statement 1: snapshot = {xmin: 1000, xmax: 1005, xip: [1001, 1003]}
Statement 2: snapshot = {xmin: 1001, xmax: 1006, xip: [1001]}  -- NEW snapshot
Statement 3: snapshot = {xmin: 1001, xmax: 1007, xip: []}      -- NEW snapshot
```

**Practical Example - Lost Update Problem**:

```sql
-- Two sessions try to increment a counter

-- Session 1 (Read Committed)
BEGIN;
SELECT value FROM counters WHERE id = 1;  -- Reads: 10
-- Increment in application: value = 10 + 1 = 11

-- Session 2 (concurrent)
BEGIN;
SELECT value FROM counters WHERE id = 1;  -- Reads: 10
-- Increment in application: value = 10 + 1 = 11
UPDATE counters SET value = 11 WHERE id = 1;
COMMIT;

-- Session 1 continues
UPDATE counters SET value = 11 WHERE id = 1;  -- Overwrites Session 2's update!
COMMIT;

-- Final value: 11 (should be 12) - LOST UPDATE!
```

**Why This Happens**:
1. Both sessions read value=10 in their respective statement snapshots
2. Both calculate new value as 11
3. Last write wins, one increment is lost

**Read Committed Write Behavior**:
When updating/deleting rows, Read Committed:
1. Takes statement snapshot to find candidate rows
2. For each candidate, re-checks visibility using LATEST committed data
3. If row was updated by concurrent transaction:
   - Waits for that transaction to commit/rollback
   - Re-evaluates WHERE clause on new row version
   - If still matches, applies update; otherwise skips

```sql
-- Demonstrate re-evaluation of WHERE clause

-- Setup
CREATE TABLE accounts (id INT PRIMARY KEY, balance INT, status TEXT);
INSERT INTO accounts VALUES (1, 100, 'active');

-- Session 1
BEGIN;
UPDATE accounts SET balance = 50 WHERE id = 1;
-- Doesn't commit yet

-- Session 2 (Read Committed)
BEGIN;
UPDATE accounts SET status = 'frozen'
WHERE id = 1 AND balance < 75;
-- BLOCKS waiting for Session 1

-- Session 1 commits
COMMIT;

-- Session 2 unblocks and re-evaluates WHERE clause
-- Checks: balance (now 50) < 75? YES
-- Applies update
-- Result: status = 'frozen', balance = 50
```

#### Repeatable Read: Transaction-Level Snapshots

Repeatable Read maintains a single snapshot for the entire transaction after the first query.

**Snapshot Structure**:
```
Transaction begins: no snapshot yet
First query executes: snapshot = {xmin: 1000, xmax: 1005, xip: [1001, 1003]}
All subsequent queries: USE SAME SNAPSHOT (frozen in time)
```

**Visibility with Single Snapshot**:

```sql
-- Session 1: Repeatable Read
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM users WHERE id = 1;
-- Snapshot created: sees user with name = 'Alice'

-- Session 2: Updates the user
BEGIN;
UPDATE users SET name = 'Bob' WHERE id = 1;
COMMIT;

-- Session 1: Same query, same snapshot
SELECT * FROM users WHERE id = 1;
-- Still sees: name = 'Alice'

-- Session 1: Query different columns, still same snapshot
SELECT id, name, email FROM users WHERE id = 1;
-- Still sees: name = 'Alice'

-- Session 1: Even aggregate queries use same snapshot
SELECT COUNT(*) FROM users;
-- Uses same snapshot taken at first query
```

**Write Operations in Repeatable Read**:

When a Repeatable Read transaction attempts UPDATE/DELETE/SELECT FOR UPDATE:
1. Uses transaction snapshot to find candidate rows
2. Attempts to acquire lock on each candidate
3. If row was modified after snapshot:
   - **Immediately fails** with serialization error
   - No waiting, no re-evaluation
   - Transaction must be retried

```sql
-- First-updater-wins rule

-- Session 1: Repeatable Read
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE id = 1;
-- Snapshot: balance = 100

-- Session 2: Updates same row
BEGIN;
UPDATE accounts SET balance = 150 WHERE id = 1;
COMMIT;

-- Session 1: Try to update
UPDATE accounts SET balance = balance + 50 WHERE id = 1;
-- ERROR: could not serialize access due to concurrent update

-- Session 1 must rollback and retry entire transaction
ROLLBACK;
```

**Why This Error Occurs**:
- Session 1's snapshot has xmin=100 for the accounts row
- Session 2 created a new version with xmin=101
- When Session 1 tries to update, it detects xmin changed
- PostgreSQL cannot allow this because Session 1 might have made decisions based on stale data

**Phantom Prevention in PostgreSQL**:

PostgreSQL's Repeatable Read is stronger than SQL standard - it prevents phantoms through predicate locking.

```sql
-- Session 1: Repeatable Read
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM orders WHERE user_id = 123;
-- Returns: 5 (snapshot frozen)

-- Session 2: Insert new order
BEGIN;
INSERT INTO orders (user_id, amount) VALUES (123, 100);
COMMIT;

-- Session 1: Same query
SELECT COUNT(*) FROM orders WHERE user_id = 123;
-- Returns: 5 (no phantom - uses same snapshot)

-- Session 1: Try to update all orders for user
UPDATE orders SET processed = true WHERE user_id = 123;
-- Updates only 5 rows (the ones in snapshot)
-- New row inserted by Session 2 is INVISIBLE to this transaction

COMMIT;
```

#### Serializable: Snapshot + Dependency Tracking

Serializable uses the same snapshot mechanism as Repeatable Read but adds read-write dependency tracking to prevent serialization anomalies.

**What Serializable Tracks**:
1. **rw-dependencies**: Transaction T1 reads data that T2 later modifies
2. **ww-dependencies**: Both transactions write to same data
3. **Dangerous structures**: Cycles in dependency graph that indicate anomalies

**Read-Write Conflict Detection**:

```sql
-- Write skew example: impossible in serial execution

-- Initial state: Two VIP seats available
CREATE TABLE seats (id INT PRIMARY KEY, vip BOOLEAN, reserved BOOLEAN);
INSERT INTO seats VALUES (1, true, false), (2, true, false);
-- Business rule: At least 1 VIP seat must remain available

-- Session 1: Serializable
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM seats WHERE vip = true AND reserved = false;
-- Returns: 2 (passes business rule check)
-- Creates read predicate: "COUNT of vip=true AND reserved=false"

-- Session 2: Serializable (concurrent)
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM seats WHERE vip = true AND reserved = false;
-- Returns: 2 (same snapshot, passes business rule check)

-- Session 1: Reserve a seat
UPDATE seats SET reserved = true WHERE id = 1;
-- Creates write on seats table
COMMIT;  -- Success

-- Session 2: Reserve other seat
UPDATE seats SET reserved = true WHERE id = 2;
-- PostgreSQL detects dangerous structure:
--   T2 read data (count=2)
--   T1 wrote to that data (reserved seat 1)
--   T2 now writing to same dataset (reserved seat 2)
-- This creates rw-antidependency: T2 read -> T1 write -> T2 write
COMMIT;
-- ERROR: could not serialize access due to read/write dependencies among transactions
```

**How PostgreSQL Detects This**:

```
1. Session 1 commits:
   - Records: "committed transaction T1 wrote to seats table"
   - Marks read predicates that might conflict

2. Session 2 tries to commit:
   - Checks: Did any committed transaction write to data I read?
   - Finds: T1 wrote to seats (id=1) after T2 read COUNT(*)
   - Checks: Am I also writing to seats?
   - Finds: Yes, writing to seats (id=2)
   - Detects: Dangerous structure (pivot)
   - Aborts: T2 with serialization error
```

**Serializable Read-Only Optimization**:

Read-only Serializable transactions can be optimized and may never fail.

```sql
-- Read-only transaction
BEGIN ISOLATION LEVEL SERIALIZABLE READ ONLY DEFERRABLE;

-- This transaction:
-- 1. Can wait for safe snapshot (DEFERRABLE)
-- 2. Never needs to track writes (READ ONLY)
-- 3. Will never abort due to serialization conflicts
-- 4. Can run in parallel with any other transactions

SELECT SUM(amount) FROM orders WHERE date = CURRENT_DATE;

COMMIT;  -- Always succeeds
```

#### Comparative Example: Same Scenario, Different Levels

```sql
-- Setup: Two accounts, transfer money between them
CREATE TABLE accounts (id INT PRIMARY KEY, balance INT);
INSERT INTO accounts VALUES (1, 1000), (2, 500);

-- Scenario: Two concurrent transfers

-- ============================================
-- READ COMMITTED
-- ============================================

-- Session 1: Transfer $100 from account 1 to 2
BEGIN;  -- Read Committed (default)
SELECT balance FROM accounts WHERE id = 1;  -- Reads: 1000
-- Check: balance >= 100? YES
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

-- Session 2: Transfer $50 from account 1 to 2
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- NEW snapshot, reads: 1000
-- Check: balance >= 50? YES
UPDATE accounts SET balance = balance - 50 WHERE id = 1;
-- BLOCKS: waiting for Session 1

-- Session 1 commits
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Session 2 unblocks
-- Re-reads row with balance = 900 (after Session 1's update)
-- Applies: 900 - 50 = 850
UPDATE accounts SET balance = balance + 50 WHERE id = 2;
COMMIT;

-- Final state: account 1 = 850, account 2 = 650
-- Correct! Read Committed's re-evaluation saved us

-- ============================================
-- REPEATABLE READ
-- ============================================

-- Reset
UPDATE accounts SET balance = 1000 WHERE id = 1;
UPDATE accounts SET balance = 500 WHERE id = 2;

-- Session 1: Transfer $100 from account 1 to 2
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE id = 1;  -- Snapshot: 1000
-- Check: balance >= 100? YES
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

-- Session 2: Transfer $50 from account 1 to 2
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE id = 1;  -- Same snapshot: 1000
-- Check: balance >= 50? YES
UPDATE accounts SET balance = balance - 50 WHERE id = 1;
-- BLOCKS: waiting for Session 1

-- Session 1 commits
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Session 2 unblocks
-- Detects: row was modified after snapshot
-- ERROR: could not serialize access due to concurrent update
ROLLBACK;

-- Need to retry Session 2 with new snapshot
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT balance FROM accounts WHERE id = 1;  -- New snapshot: 900
-- Check: balance >= 50? YES
UPDATE accounts SET balance = balance - 50 WHERE id = 1;
UPDATE accounts SET balance = balance + 50 WHERE id = 2;
COMMIT;

-- Final state: account 1 = 850, account 2 = 650
-- Correct, but required retry

-- ============================================
-- SERIALIZABLE
-- ============================================

-- Reset
UPDATE accounts SET balance = 1000 WHERE id = 1;
UPDATE accounts SET balance = 500 WHERE id = 2;

-- Session 1: Transfer $100 from 1 to 2
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT balance FROM accounts WHERE id = 1;  -- Snapshot: 1000
-- Creates read dependency
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;  -- Success, tracks writes

-- Session 2: Transfer $50 from 1 to 2
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT balance FROM accounts WHERE id = 1;  -- Same snapshot: 1000
UPDATE accounts SET balance = balance - 50 WHERE id = 1;
-- Detects: T1 wrote to data T2 read from same snapshot
-- ERROR: could not serialize access due to concurrent update
ROLLBACK;

-- Behaves like Repeatable Read for this scenario
```

#### Visibility Rules by Isolation Level

**Read Committed**:
```python
def tuple_visible_read_committed(tuple, statement_snapshot):
    # Check if tuple was created by committed transaction
    if tuple.xmin >= statement_snapshot.xmax:
        return False  # Created after snapshot
    if tuple.xmin in statement_snapshot.xip:
        return False  # Created by active transaction
    if not is_committed(tuple.xmin):
        return False  # Creating transaction aborted

    # Check if tuple was deleted
    if tuple.xmax == 0:
        return True  # Not deleted
    if tuple.xmax >= statement_snapshot.xmax:
        return True  # Deleted after snapshot
    if tuple.xmax in statement_snapshot.xip:
        return True  # Deleted by active transaction
    if not is_committed(tuple.xmax):
        return True  # Deleting transaction aborted

    return False  # Deleted by committed transaction
```

**Repeatable Read / Serializable**:
```python
def tuple_visible_repeatable_read(tuple, transaction_snapshot):
    # Same logic as Read Committed, but:
    # 1. snapshot never changes during transaction
    # 2. snapshot was taken at first query, not at BEGIN

    # Additionally, for UPDATES:
    if attempting_update:
        if tuple.xmax != 0 and is_committed(tuple.xmax):
            if tuple.xmax >= transaction_snapshot.xmax:
                # Row was updated after our snapshot
                raise SerializationError("concurrent update detected")

    # Same visibility check as Read Committed
    return tuple_visible_read_committed(tuple, transaction_snapshot)
```

#### Performance Implications

**Read Committed**:
- **Pros**: No serialization errors, no retries needed
- **Cons**: Multiple snapshot acquisitions per transaction
- **Overhead**: Low - snapshot creation is fast
- **Use when**: Retrying logic is difficult to implement

**Repeatable Read**:
- **Pros**: Single snapshot per transaction, consistent view
- **Cons**: Serialization errors on concurrent updates, requires retry logic
- **Overhead**: Medium - snapshot held longer, prevents VACUUM
- **Use when**: You need consistent reads but can handle retries

**Serializable**:
- **Pros**: Prevents all anomalies, guarantees serializability
- **Cons**: Higher abort rate, more complex dependency tracking
- **Overhead**: High - tracks read/write dependencies, more CPU
- **Use when**: Correctness is critical, retry logic is robust

```sql
-- Monitor overhead by isolation level
SELECT
    datname,
    xact_commit,
    xact_rollback,
    ROUND(100.0 * xact_rollback / NULLIF(xact_commit + xact_rollback, 0), 2) AS rollback_pct,
    conflicts,
    deadlocks
FROM pg_stat_database
WHERE datname = current_database();
```

#### Choosing Isolation Level Based on MVCC Behavior

**Choose Read Committed when**:
- You can tolerate non-repeatable reads
- Retry logic is complex or impossible
- You're doing simple, single-row operations
- Example: Web application CRUD operations

**Choose Repeatable Read when**:
- You need consistent snapshots for reporting
- You have retry logic for serialization errors
- You're reading multiple related rows
- Example: Monthly financial reports, batch processing

**Choose Serializable when**:
- Business rules span multiple queries
- Write skew would violate constraints
- Absolute correctness is required
- Example: Financial transfers, inventory with complex rules, booking systems

```sql
-- Example: Choosing based on requirements

-- Simple update: Read Committed is fine
BEGIN;
UPDATE users SET last_login = now() WHERE id = 123;
COMMIT;

-- Report generation: Use Repeatable Read
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT SUM(amount) FROM orders WHERE status = 'completed';
SELECT AVG(amount) FROM orders WHERE status = 'completed';
SELECT COUNT(*) FROM orders WHERE status = 'completed';
-- All queries see same consistent snapshot
COMMIT;

-- Complex business logic: Use Serializable
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM seats WHERE vip = true AND NOT reserved;
-- Business rule: must keep at least 1 VIP seat available
IF count > 1 THEN
    UPDATE seats SET reserved = true
    WHERE id = $requested_seat AND vip = true;
END IF;
COMMIT;
```

## Transaction Isolation Levels

PostgreSQL implements four transaction isolation levels defined by SQL standard, though READ UNCOMMITTED behaves like READ COMMITTED.

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

SELECT FOR UPDATE locks rows returned by a SELECT query, preventing other transactions from modifying or locking them until the transaction completes.

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
