
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
