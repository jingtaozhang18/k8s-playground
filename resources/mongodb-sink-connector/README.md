# Deploy Kafka Sink Connect MongDB

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

## Deploy Resource

```bash
kubectl apply -f mongodb-sink-connector-configuration-role.yaml # Role 
kubectl apply -f mongodb-sink-connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -f mongodb-sink-connect-cluster.yaml # KafkaConnect
kubectl apply -f mongodb-sink-connector.yaml # KafkaConnector running on KafkaConnect
```

## Destroy Resource

```bash
kubectl delete KafkaConnector mongodb-sink-connector
kubectl delete KafkaConnect mongodb-sink-connect-cluster
kubectl delete RoleBinding mongodb-sink-connector-configuration-role-binding
kubectl delete Role mongodb-sink-connector-configuration-role
```

# Refer

* [MongoDB Connector (Source and Sink)](https://www.confluent.io/hub/mongodb/kafka-connect-mongodb)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

