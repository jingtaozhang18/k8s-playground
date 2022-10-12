# Change Data Capture Playground

## Data Flow

**simulate-mysql-op** -(op)-> **MySQL Primary Server** -(sync)-> **MySQL Secondary Server** -(debezium)-> **Kafka Source Connector** -> **Kafka** -(mongodb connector)-> **Kafka Sink Connector** -> **MongoDB**

> Can't ensure accessing one specifical MySQL Secondary Server, so Debezium now connect to MySQL Primary Server

Refer [simulate-mysql-op](./simulate-mysql-op) for simulating concurrent operation on MySQL.

Refer [source-connector-debezium](./source-connector-debezium) for capturing change data from MySQL to Kafka.

Refer [sink-connector-mongodb](./sink-connector-mongodb) for sinking data from Kafka to MongoDB.

Refer [sink-connector-s3](./sink-connector-s3) for sinking all existing data of all topics into MINIO.

Refer [sink-kafka2hdfs](./sink-kafka2hdfs) for sinking all existing data of all topics into hdfs.

## Start Step

* Initial MySQL Database: Run simulate-mysql-op/database_initial
* Deploy Debezium Source Connector
* Deploy MongoDB Sink Connector
* Deploy S3 Sink Connector
* Concurrent Operation on MySQL: Run simulate-mysql-op/concurrency_op
