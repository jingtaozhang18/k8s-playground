# Deploy Kafka Sink Connect MongDB

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

```bash
operator-sdk olm install
kubectl create -f https://operatorhub.io/install/strimzi-kafka-operator.yaml
```

## Deploy Resource

```bash
kubectl apply -f mongodb-sink-connector-configuration-role.yaml # Role 
kubectl apply -f mongodb-sink-connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -n infra -f mongodb-sink-connect-cluster.yaml # KafkaConnect
kubectl apply -n infra -f mongodb-sink-connector-multi-topics.yaml # KafkaConnector running on KafkaConnect
```

## Destroy Resource

```bash
kubectl delete -n infra KafkaConnector mongodb-sink-connector-multi-topics
kubectl delete -n infra KafkaConnect mongodb-sink-connect-cluster
kubectl delete RoleBinding mongodb-sink-connector-configuration-role-binding
kubectl delete Role mongodb-sink-connector-configuration-role
```

# Refer

* [MongoDB Connector (Source and Sink)](https://www.confluent.io/hub/mongodb/kafka-connect-mongodb)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)
