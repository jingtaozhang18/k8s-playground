
# The Method to Access Services in Infra

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

* 13332 [Kube State Metrics V2](https://grafana.com/grafana/dashboards/13332-kube-state-metrics-v2/)
* 7362  [MySQL Overview](https://grafana.com/grafana/dashboards/7362-mysql-overview/)
* 12483 [Kubernetes Kafka](https://grafana.com/grafana/dashboards/12483-kubernetes-kafka/)

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
   kubectl exec -n infra -it gradiant-hdfs-namenode-0 -- hdfs dfsadmin -report

2. Create a port-forward to the hdfs manager UI:
   kubectl port-forward -n infra gradiant-hdfs-namenode-0 50070:50070

   Then open the ui in your browser:
   
   open http://localhost:50070

Web URL: `http://gradiant-hdfs-namenode-exporter.infra.svc.cluster.local:50070`

## Spark

1. Get the Spark master WebUI URL by running these commands:

  kubectl port-forward --namespace infra svc/bitnami-spark-master-svc 80:80
  echo "Visit http://127.0.0.1:80 to use your application"

2. Submit an application to the cluster:

  To submit an application to the cluster the spark-submit script must be used. That script can be
  obtained at https://github.com/apache/spark/tree/master/bin. Also you can use kubectl run.

  export EXAMPLE_JAR=$(kubectl exec -ti --namespace infra bitnami-spark-worker-0 -- find examples/jars/ -name 'spark-example*\.jar' | tr -d '\r')

  kubectl exec -ti --namespace infra bitnami-spark-worker-0 -- spark-submit --master spark://bitnami-spark-master-svc:7077 \
    --class org.apache.spark.examples.SparkPi \
    $EXAMPLE_JAR 5

** IMPORTANT: When submit an application from outside the cluster service type should be set to the NodePort or LoadBalancer. **

** IMPORTANT: When submit an application the --master parameter should be set to the service IP, if not, the application will not resolve the master. **


## MongoDB

Connection String
```
mongodb://root:{passwd}@bitnami-cosmos-shared-mongodb-sharded.infra.svc.cluster.local:27017/?authSource=admin&readPreference=primary&ssl=false
```
