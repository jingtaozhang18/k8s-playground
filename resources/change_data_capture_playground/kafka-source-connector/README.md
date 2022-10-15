# Kafka Source Connector

Refer to [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

```bash
operator-sdk olm install --timeout 10m0s
kubectl create -f https://operatorhub.io/install/strimzi-kafka-operator.yaml
```

## Deploy Resource

```bash
kubectl apply -f source-connector-configuration-role.yaml # Role 
kubectl apply -f source-connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -n infra -f source-connect-cluster.yaml # KafkaConnect
kubectl apply -n infra -f source-connector-mysql.yaml # Debezium Source KafkaConnector running on KafkaConnect
```

## Destroy Resource

```bash
kubectl delete -n infra KafkaConnector source-connector-mysql
kubectl delete -n infra KafkaConnect source-connect-cluster
kubectl delete RoleBinding source-connector-configuration-role-binding
kubectl delete Role source-connector-configuration-role
```

# Refer

* [Debezium Documentation / Operations / Running on Kubernetes](https://debezium.io/documentation/reference/stable/operations/kubernetes.html#_creating_kafka_connect_cluster)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)
