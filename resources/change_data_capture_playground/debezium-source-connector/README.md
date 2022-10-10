# Deploy Debezium Connector

Refer to [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

```bash
operator-sdk olm install
```

## Deploy Resource

```bash
kubectl apply -f debezium-source-connector-configuration-role.yaml # Role 
kubectl apply -f debezium-source-connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -f debezium-source-connect-cluster.yaml # KafkaConnect
kubectl apply -f debezium-source-connector-mysql.yaml # KafkaConnector running on KafkaConnect
```

## Destroy Resource

```bash
kubectl delete KafkaConnector debezium-source-connector-mysql
kubectl delete KafkaConnect debezium-source-connect-cluster
kubectl delete RoleBinding debezium-source-connector-configuration-role-binding
kubectl delete Role debezium-source-connector-configuration-role
```

# Refer

* [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)