### Q & A

1. How does Kafka master node copy its partitions into the slave node?
   In kafka, it's called leader broker instead of master node,
   leader broker is Read-Writable, other follower brokers replicate the data from the leader
   when a message is written to a partition, the leader broker writes the message to its local log and sends
   the message to all the follower brokers, The follower brokers then write the message to their local logs.
   Replication process ensures all replicas of a partition are kept in sync with the leader

2. How does zookeeper manage its topics created by Kafka
   zookeeper manages: broker membership, topic configuration, leader selection, meta-data to topics,brokers,consumers

3. What's the benefits of using .Parquet .Avro .ORC data file
   .Parquet: columnar storage format, optimized for querying & compression,support nested, suited for write-once,
   read-many analytics
   .Avro: row-based storage, binary format, compact & space-efficient
   .ORC: columnar storage format, suited for read-heavy operations.

#