# Change Data Capture Playground

## Data Flow

**simulate-mysql-op** -(op)-> **MySQL Primary Server** -(sync)-> **MySQL Secondary Server** -(debezium)-> **Kafka Source Connector** -> **Kafka** -(mongodb connector)-> **Kafka Sink Connector** -> **MongoDB**