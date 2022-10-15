# Sink Kafka to HDFS

## Chown Directory

```bash
kubectl exec gradiant-hdfs-namenode-0 -n infra -- hadoop fs -chmod 777 /
```

## Submit Spark Job

```bash
# upload code file
kubectl cp codes/ bitnami-spark-master-0:/opt/bitnami/spark -n infra
# submit job
kubectl exec -ti --namespace infra bitnami-spark-master-0 -- \
  spark-shell \
  --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.2.1,io.delta:delta-core_2.12:1.2.1 \
  --master spark://bitnami-spark-master-svc:7077 \
  --name sink-kafka2hdfs \
  -i /opt/bitnami/spark/codes/sink-kafka2hdfs.scala
```