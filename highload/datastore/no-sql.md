# NoSQL

## Cassandra
1. All nodes in a Cassandra cluster are functionally equal. Clients can connect to any of Cassandra's nodes, and when they connect that node becomes the client's session coordinator. Clients do not need to know which nodes have what data, nor do they have to be aware of outages, repairing data, or replication.
1. Read
    ![Cassandra Read](../img/cassandra-read.jpg)

1. Write
    ![Cassanra Write](../img/cassandra-write.jpg)
