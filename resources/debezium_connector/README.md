# Deploy Debezium Connector

Refer to [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

## Deploy Resource

```bash
kubectl apply -f connector-configuration-role.yaml # Role 
kubectl apply -f connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -f debezium-connect-cluster.yaml # KafkaConnect
kubectl apply -f debezium-connector-mysql.yaml # KafkaConnector running on KafkaConnect
```

# Refer

* [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)