# Kafka Sink Connector

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

```bash
operator-sdk olm install --timeout 10m0s
kubectl create -f https://operatorhub.io/install/strimzi-kafka-operator.yaml
```

## Deploy Resource

```bash
kubectl apply -f sink-connector-configuration-role.yaml # Role 
kubectl apply -f sink-connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -n infra -f sink-connect-cluster.yaml # KafkaConnect
kubectl apply -n infra -f sink-connector-metrics.yaml
kubectl apply -n infra -f sink-connector-mongodb.yaml # MongoDB Sink KafkaConnector running on KafkaConnect
kubectl apply -n infra -f sink-connector-s3.yaml # S3 Sink KafkaConnector running on KafkaConnect
```

## Destroy Resource

```bash
kubectl delete -n infra KafkaConnector sink-connector-mongodb
kubectl delete -n infra KafkaConnector sink-connector-s3
kubectl delete -n infra KafkaConnect mongodb-sink-connect-cluster
kubectl delete RoleBinding mongodb-sink-connector-configuration-role-binding
kubectl delete Role mongodb-sink-connector-configuration-role
```

# Refer

* [MongoDB Connector (Source and Sink)](https://www.confluent.io/hub/mongodb/kafka-connect-mongodb)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)
