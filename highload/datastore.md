# DataStore

## Replication

### Binary logs and two-phase commits
1. All the writes which go to database at first are written to the binlog file
1. Binlog file could be:
    * Statement based (like INSERT INTO....)
        * the downside of this type of replication that not all the statements produce identical results on master and slave. So developers and DBAs need to pay attention on this
    * Row-Based - the actual changes are replicated.
        * **+** all the operations are supported
        * **-** the size of binary log is much bigger (especially for write intensive applications, when writes happens in batches)
1. The advantages of this approach:
    * Without binary logs we would need to flush database page(s) on disk (to prevent data lost in case of failure) for every write. That means having a lot of random IO. Random IO is not very fast for HDD disks (most of the deployments uses HDD because of higher throughput, capacity and reliability)
    * With binary log enabled: we flush changes to binlog (sequential IO) and update page data in memory (making this page durty). As a result we have a lot of sequential IO, and significantly less amount of random IO.
    * Binarylog allows to perform replication and point in time recovery.

### Why
1. To scale reads
1. To perform no-downtime maitanance
    * perform updates on slaves
    * promote slave to master (???)
    * perform update on old slave

### How
1. A slave maintains `relay log` - the applied binary log from the master.
1. A slave knowns the master IP and queiries it for the changes in binlog file since the last sync.
1. When there are changes slave downloads them and applies.

### Trics
1. Applying replication changes is performed in single thread on slaves. That's why making big changes (like Alter Table) could introduce a big temporary replication lag.
1. Developers should pay attention on replication lag

### High Availability
1. To restore failed slave we need to first restore backup.
    * we can not start slave with empty database
    * if the difference between backup and actual state of the master is big - slave will be very busy trying to reach master
1. Replication is not a backup!
    * if we made incorrect changes to master - they will be replicated to slaves
    * when master failes we will lose all the data in range [last_sync_point:last_update]
1. To improve availability and decrease Recovery Time Objective we could setup master-master replication.
    * It's easier to perform maintanance in this case
    * Although it's possible to perform writes on both masters - it's not recomended. Because of the complexity of this setup and complexity of handling the conflicts
    * In case when we have only one master for writes we could easily switch to another master in case of failure.
