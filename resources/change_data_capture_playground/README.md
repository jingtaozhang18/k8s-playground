# Change Data Capture Playground

## Data Flow

**simulate-mysql-op** -(op)-> **MySQL Primary Server** -(sync)-> **MySQL Secondary Server** -(debezium)-> **Kafka Source Connector** -> **Kafka** -(mongodb connector)-> **Kafka Sink Connector** -> **MongoDB**

Refer [simulate-mysql-op](./simulate-mysql-op) for simulating concurrent operation on MySQL.

Refer [debezium-source-connector](./debezium-source-connector) for capturing change data from MySQL to Kafka.

Refer [mongodb-sink-connector](./mongodb-sink-connector) for sinking data from Kafka to MongoDB.

Refer [sink-kafka2hdfs](./sink-kafka2hdfs) for sinking all existing data of all topics into hdfs.
