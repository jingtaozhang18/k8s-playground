
# The Method to Access Services in Infra

Proxy Tools:

* ktctl
  
  ```bash
  sudo ktctl --kubeconfig /home/${USER}/.kube/config connect
  ```

* socks5-proxy
  
  ```bash
  # refer https://krew.sigs.k8s.io/docs/user-guide/setup/install/ to install krew
  kubectl krew install socks5-proxy
  ```

## Promethus

Watch the Prometheus Operator Deployment status using the command:

```bash
    kubectl get deploy -w --namespace infra -l app.kubernetes.io/name=kube-prometheus,app.kubernetes.io/instance=bitnami-kube-prometheus
```

Watch the Prometheus StatefulSet status using the command:

```bash
    kubectl get sts -w --namespace infra -l app.kubernetes.io/name=kube-prometheus,app.kubernetes.io/instance=bitnami-kube-prometheus
```

Prometheus can be accessed via port "9090" on the following DNS name from within your cluster:

```bash
    bitnami-kube-prometheus-prometheus.infra.svc.cluster.local
```

To access Prometheus from outside the cluster execute the following commands:

```bash
    echo "Prometheus URL: http://127.0.0.1:9090/"
    kubectl port-forward --namespace infra svc/bitnami-kube-prometheus-prometheus 9090:9090
```

Thanos Sidecar can be accessed via port "10901" on the following DNS name from within your cluster:

```bash
    bitnami-kube-prometheus-prometheus-thanos.infra.svc.cluster.local
```

Watch the Alertmanager StatefulSet status using the command:

```bash
    kubectl get sts -w --namespace infra -l app.kubernetes.io/name=kube-prometheus-alertmanager,app.kubernetes.io/instance=bitnami-kube-prometheus
```

Alertmanager can be accessed via port "9093" on the following DNS name from within your cluster:

```bash
    bitnami-kube-prometheus-alertmanager.infra.svc.cluster.local
```

To access Alertmanager from outside the cluster execute the following commands:

```bash
    echo "Alertmanager URL: http://127.0.0.1:9093/"
    kubectl port-forward --namespace infra svc/bitnami-kube-prometheus-alertmanager 9093:9093
```

## Grafana

Check user name and passwd, and forword port.

```bash
   echo "User Name: $(kubectl get secret --namespace infra grafana-admin-credentials -o jsonpath="{.data.GF_SECURITY_ADMIN_USER}" | base64 -d)"
   echo "User Passwd: $(kubectl get secret --namespace infra grafana-admin-credentials -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d)"
   kubectl port-forward services/grafana-service 3000:3000 -n infra &
```

Grafana URL: `http://grafana-service.infra.svc.cluster.local:3000`

Prometheus URL: `http://bitnami-kube-prometheus-prometheus.infra.svc.cluster.local:9090`

Dashboard list:

* 1860  [Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
* 7362  [MySQL Overview](https://grafana.com/grafana/dashboards/7362-mysql-overview/)
* 13502 [MinIO Dashboard](https://grafana.com/grafana/dashboards/13502-minio-dashboard/)
  * select `bitnami-minio` for **scrape_jobs**
* 14656 [Kafka Dashboard](https://grafana.com/grafana/dashboards/14656-kafka-dashboard/)
* 14192 [ClickHouse](https://grafana.com/grafana/dashboards/14192-clickhouse/)
* 13332 [Kube State Metrics V2](https://grafana.com/grafana/dashboards/13332-kube-state-metrics-v2/)

## MySQL

```bash
   # Get passwd of root
   MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace infra bitnami-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
   # Run a pod that you can use as a client:
   kubectl run bitnami-mysql-client --rm --tty -i --restart='Never' --image  docker.io.registry.jingtao.fun/bitnami/mysql:8.0.30-debian-11-r15 --namespace infra --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash
   # To connect to primary service (read/write):
   mysql -h bitnami-mysql-primary.infra.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
   # To connect to secondary service (read-only):
   mysql -h bitnami-mysql-secondary.infra.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"
```

## HDFS

1. You can check the status of HDFS by running this command:

```bash
   kubectl exec -n infra -it gradiant-hdfs-namenode-0 -- hdfs dfsadmin -report
```

2. Create a port-forward to the hdfs manager UI:

```bash
   kubectl port-forward -n infra gradiant-hdfs-namenode-0 50070:50070
```

   Then open the ui in your browser, open http://localhost:50070

Web URL: `http://gradiant-hdfs-namenode.infra.svc.cluster.local:50070`

## Spark

1. Get the Spark master WebUI URL by running these commands:

```bash
  kubectl port-forward --namespace infra svc/bitnami-spark-master-svc 80:80
  echo "Visit http://127.0.0.1:80 to use your application"
```

Web UI: `http://bitnami-spark-master-svc.infra.svc.cluster.local:80/`

2. Submit an application to the cluster:

  To submit an application to the cluster the spark-submit script must be used. That script can be
  obtained at https://github.com/apache/spark/tree/master/bin. Also you can use kubectl run.

```bash
   export EXAMPLE_JAR=$(kubectl exec -ti --namespace infra bitnami-spark-worker-0 -- find examples/jars/ -name 'spark-example*\.jar' | tr -d '\r')

   kubectl exec -ti --namespace infra bitnami-spark-worker-0 -- spark-submit --master spark://bitnami-spark-master-svc:7077 \
      --class org.apache.spark.examples.SparkPi \
      $EXAMPLE_JAR 5
```

** IMPORTANT: When submit an application from outside the cluster service type should be set to the NodePort or LoadBalancer. **

** IMPORTANT: When submit an application the --master parameter should be set to the service IP, if not, the application will not resolve the master. **


## MongoDB

```bash
   export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace infra bitnami-cosmos-shared-mongodb-sharded -o jsonpath="{.data.mongodb-root-password}" | base64 -d)
```

Connection String

```bash
   echo "mongodb://root:${MONGODB_ROOT_PASSWORD}@bitnami-cosmos-shared-mongodb-sharded.infra.svc.cluster.local:27017/?authSource=admin&readPreference=primary&ssl=false"
```

## Kafka

Kafka can be accessed by consumers via port 9092 on the following DNS name from within your cluster:

```bash
    bitnami-kafka.infra.svc.cluster.local
```

Each Kafka broker can be accessed by producers via port 9092 on the following DNS name(s) from within your cluster:

```bash
    bitnami-kafka-0.bitnami-kafka-headless.infra.svc.cluster.local:9092
    bitnami-kafka-1.bitnami-kafka-headless.infra.svc.cluster.local:9092
    bitnami-kafka-2.bitnami-kafka-headless.infra.svc.cluster.local:9092
```

To create a pod that you can use as a Kafka client run the following commands:

```bash
   kubectl run bitnami-kafka-client --restart='Never' --image docker.io.registry.jingtao.fun/bitnami/kafka:3.2.3-debian-11-r1 --namespace infra --command -- sleep infinity
   kubectl exec --tty -i bitnami-kafka-client --namespace infra -- bash
```

```bash
   # PRODUCER:
   kafka-console-producer.sh \
      --broker-list bitnami-kafka-0.bitnami-kafka-headless.infra.svc.cluster.local:9092,bitnami-kafka-1.bitnami-kafka-headless.infra.svc.cluster.local:9092,bitnami-kafka-2.bitnami-kafka-headless.infra.svc.cluster.local:9092 \
      --topic test
```

```bash
   # CONSUMER:
   kafka-console-consumer.sh \
      --bootstrap-server bitnami-kafka.infra.svc.cluster.local:9092 \
      --topic test \
      --from-beginning
```

## MinIO

MinIO&reg; can be accessed via port  on the following DNS name from within your cluster:

   bitnami-minio.infra.svc.cluster.local

To get your credentials run:

```bash
   export ROOT_USER=$(kubectl get secret --namespace infra bitnami-minio -o jsonpath="{.data.root-user}" | base64 -d)
   export ROOT_PASSWORD=$(kubectl get secret --namespace infra bitnami-minio -o jsonpath="{.data.root-password}" | base64 -d)
   echo ${ROOT_USER}
   echo ${ROOT_PASSWORD}
```

To connect to your MinIO&reg; server using a client:

- Run a MinIO&reg; Client pod and append the desired command (e.g. 'admin info'):

```bash
   kubectl run --namespace infra bitnami-minio-client \
     --rm --tty -i --restart='Never' \
     --env MINIO_SERVER_ROOT_USER=$ROOT_USER \
     --env MINIO_SERVER_ROOT_PASSWORD=$ROOT_PASSWORD \
     --env MINIO_SERVER_HOST=bitnami-minio \
     --image docker.io.registry.jingtao.fun/bitnami/minio-client:2022.10.6-debian-11-r1 -- admin info minio
```

To access the MinIO&reg; web UI:

- Get the MinIO&reg; URL:

```bash
   echo "MinIO&reg; web URL: http://127.0.0.1:9001/minio"
   kubectl port-forward --namespace infra svc/bitnami-minio 9001:9001
```

Web Url: `http://bitnami-minio.infra.svc.cluster.local:9001/login`

## ClickHouse

ClickHouse is available in the following address:

```bash
    kubectl port-forward --namespace infra svc/bitnami-clickhouse 9000:9000 &
```

Credentials:

```bash
    echo "Username      : default"
    echo "Password      : $(kubectl get secret --namespace infra bitnami-clickhouse -o jsonpath="{.data.admin-password}" | base64 -d)"
```

WEB UI: `http://bitnami-clickhouse.infra.svc.cluster.local:8123/play`
For more please refer to [ClickHouse HTTP Interface](https://clickhouse.com/docs/en/interfaces/http/)
