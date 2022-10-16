# Change Data Capture Playground

## Data Flow

**simulate-mysql-op** -(op)-> **MySQL Primary Server** -(sync)-> **MySQL Secondary Server** -(debezium)-> **Kafka Source Connector** -> **Kafka** -(mongodb connector)-> **Kafka Sink Connector** -> **MongoDB**

> Can't ensure accessing one specifical MySQL Secondary Server, so Debezium now connect to MySQL Primary Server or the replica when the number of repica is only 1.

Refer [simulate-mysql-op](./simulate-mysql-op) for simulating concurrent operation on MySQL.

Refer [kafka-source-connectors](./kafka-source-connectors) for capturing change data from MySQL to Kafka.

Refer [kafka-sink-connectors](./kafka-sink-connectors) for sinking data from Kafka to MongoDB and hdfs2.

Refer [sink-kafka2hdfs](./sink-kafka2hdfs) for sinking all existing data of all topics into hdfs.

## Start Step

* Initial MySQL Database: Run simulate-mysql-op/database_initial
* Deploy Debezium Source Connector
* Deploy MongoDB Sink Connector
* Deploy HDFS2 Sink Connector
* Concurrent Operation on MySQL: Run simulate-mysql-op/concurrency_op
