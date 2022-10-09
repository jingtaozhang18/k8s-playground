# Deploy Debezium Connector

Refer to [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

## Deploy Resource

```bash
kubectl apply connector-configuration-role.yaml # Role 
kubectl apply connector-configuration-role-binding.yaml # RoleBinding
kubectl apply debezium-connect-cluster.yaml # KafkaConnect
kubectl apply debezium-connector-mysql.yaml # KafkaConnector running on KafkaConnect
```

# Refer

* [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)