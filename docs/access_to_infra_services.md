
# The Method to Access Services in Infra

## Grafana

Check user name and passwd, and forword port.

```bash
echo "User Name: $(kubectl get secret --namespace infra grafana-admin-credentials -o jsonpath="{.data.GF_SECURITY_ADMIN_USER}" | base64 -d)"
echo "User Passwd: $(kubectl get secret --namespace infra grafana-admin-credentials -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d)"
kubectl port-forward services/grafana-service 3000:3000 -n infra &
```

Prometheus URL: `http://bitnami-kube-prometheus-prometheus.infra.svc.cluster.local:9090`

Dash board list:

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
