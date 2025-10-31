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

# Concepts:

To enhance the learning process, all the concept part should be written by recalling from brain memory, should not be
typing by looking at other resources, so error may occur

My UnderStanding about how kafka works as an overview:
Kafka is a message(event) middleware that supports decoupling the components in a big software architecture
Kafka Clusters consist of many brokers(nodes where save the topic partitions, nodes can be real servers or docker
containers)
Kafka brokers read from data source layers (e.g. a relational database),using Kafka Connect API (which is used to
import / export data), and save these data (events in context of kafka) as partitions in brokers as immutable data.
which by default have life span of one week, before automatically removed by the kafka mechanism.

# configs to handle when consumers unable to consume in enough speed;

buffer. memory = 33554432 (32MB) e.g.
If the producer produces faster thant the broker can take, the records will be buffered in memory
That buffer will fill up over time and empty back down when the throughput to the broker increases.
If that buffer is full (all 32MB), then the .send() method will start to block(won't return right away)

max.block.ms = 60000
the time the .send() will block until throwing an exception.
Exceptions are thrown when all following 3 criterion occur simultaneously:
1.The producer has filled up its buffer
2.The broker is not accepting any new data
3.60 seconds has elapsed

If you hit an exception hit that usually means your brokers are down over overloaded as they can't respond to requests
