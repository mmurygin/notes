## Table of Content

- [ACID](#acid)
- [Scaling Database](#scaling-database)
  * [Replication](#replication)
  * [Sharding](#sharding)

## ACID

1. **Atomicity** - all parts of a transaction succeed or fail together
2. **Consistency** - the database will always be consistent
3. **Isolation** (locking) - transacton can’t affect on other transacton
4. **Durability** - once the transaction is committed, it won’t be lost


## Scaling Database

### Replication

* **Use Case**:
    * Increase the speed of GET requests when we have a huge amount of gets
* **Details**:
    * There is master database
    * We create some amount of clones of master database.
    * When we have Update request to out DB, at first we update master DB, then we update each of our clone DB
    * When we have GET request we can use any of our clone (it increases the speed of get request)
* **Downsides**:
    * Decreases write speed, because we need to write to all replicas
    * Replication lag - if after write request, we have immidiate get request. In this case there is a possibility that our replica has out-of-date data, because it wasn't suppose to handle write request beand by this time out clone databases don’t have time to update data, so we have out_of_date result

### Sharding
* **Use Case**:
    * Split data between multiple servers, when we have a lot of data and we are not able to put it on a one server.
* **Downsides**:
    * The range queries become more comples
    * Joins become difficult (even imposible), because we don't have disk space to join such tables
