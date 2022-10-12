# Deploy Kafka Sink Connect S3

## Deploy Strimzi Operator

Refer to [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)

```bash
operator-sdk olm install --timeout 10m0s
kubectl create -f https://operatorhub.io/install/strimzi-kafka-operator.yaml
```

## Deploy Resource

```bash
kubectl apply -f s3-sink-connector-configuration-role.yaml # Role 
kubectl apply -f s3-sink-connector-configuration-role-binding.yaml # RoleBinding
kubectl apply -n infra -f s3-sink-connect-cluster.yaml # KafkaConnect
kubectl apply -n infra -f s3-sink-connector-multi-topics.yaml # KafkaConnector running on KafkaConnect
```

## Destroy Resource

```bash
kubectl delete -n infra KafkaConnector s3-sink-connector-multi-topics
kubectl delete -n infra KafkaConnect s3-sink-connect-cluster
kubectl delete RoleBinding s3-sink-connector-configuration-role-binding
kubectl delete Role s3-sink-connector-configuration-role
```

# Refer

* [S3 Connector](https://www.confluent.io/hub/confluentinc/kafka-connect-s3)
* [Operator Install](https://sdk.operatorframework.io/docs/installation/)
* [Operator QuickStart](https://olm.operatorframework.io/docs/getting-started/)
