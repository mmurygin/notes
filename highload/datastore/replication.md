# Replication

## Goal
1. Scale read requests horizontally
1. Increase availability
    * failover
    * no downtime updates and maintanance
1. Keep data geographically close to users

## Types of replication
1. Single-Leader
1. Multi-Leader
1. Leaderless

## Leader and Followers
### General Idea

![Replication](./img/master-slave-replication.jpg)

### Implementation
1. Writes go to the leader, then they are replecated (using binlog or wal) to followers
1. A slave maintains `relay log` the applied binary log from the master.
1. A slave knowns the master IP and queiries it for the changes in binlog file since the last sync.
1. The types of replication
    * **async** (default) - master doesn't know anything about slaves. Slave connect to master and stream binlog.
        **+** good performance (we do not wait until slave apply this log)
        **+** good availability (if slave is down master continue to work)
        **-** bad durability (if master is down and we perform failover from slave - then we will lose data that wasn't streamed to this slave)
        **-** eventual consistency and stale reads
    * **sync** - master waits until all slaves apply changes
        **+** strong consistency
        **+** durability
        **-** decrease in performance
        **-** decrease in availability
    * **semi-sync** - the is one or more sync slaves and rest of them are async
1. Challenges in implementation:
    * in mysql slave applies queries in single thread (to avoid dealing with concurrency).
        * PostgreSQL it's not an issue, because most of the work slave perform is IO bound (physical replicaion)
        * it's an issue for MySQL, because most of the slave work is CPU bound (due to logical binlog format). So we need to pay attention and monitor at the replication lag. MySQL 5.7+ can update different tables in multiple threads. This way we decrease the influence of single-threaded apply.


### Binlog (WAL)
1. All the writes at first are written to the binlog file
1. Binlog (WAL) file could be:
    * Physical - contain exact changes within pages (used in PostgreSQL). As a result we have bite-to-bite equality between master and slave
    * Statement based (like INSERT INTO....)
        * the downside of this type of replication that not all the statements produce identical results on master and slave. So developers and DBAs need to pay attention on this
    * Row-Based - the actual changes are replicated.
        * **+** all the operations are supported
        * **-** the size of binary log is much bigger (especially for write intensive applications, when writes happens in batches)
1. Binlog (WAL) advantages:
    * Without binary logs we would need to flush database page(s) on disk (to prevent data lost in case of failure) for every write. That means having a lot of random IO. Random IO is not very fast for HDD disks (most of the deployments uses HDD because of higher throughput, capacity and reliability)
    * With binary log enabled: we flush changes to binlog (sequential IO) and update page data in memory (making this page durty). OS then could decide when to flush this page on disk. As a result we have a lot of sequential IO, and significantly less amount of random IO.
    * Binarylog allows to perform replication and point in time recovery.


