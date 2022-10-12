# Concurrent Operation on MySQL Database

Refer to [simulate-mysql-op](https://github.com/jingtaozhang18/simulate-mysql-op).

You can use the code in the [Demo](https://github.com/jingtaozhang18/simulate-mysql-op#demo) directly.

## Initial MySQL

```bash
# Initial MySQL Database

MYSQL_USR_NAME=root
MYSQL_USR_PASSWD=$(kubectl get secret --namespace infra bitnami-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
MYSQL_SERVER_URL=bitnami-mysql-primary.infra.svc.cluster.local
MYSQL_SERVER_PORT=3306

INIT_IMAGE_NAME=registry.jingtao.fun/simulate-mysql-op/database_initial
INIT_IMAGE_ARG=test_v2

minikube kubectl --profile playground -- \
  delete pod simulate-mysql-initial -n infra --ignore-not-found=false

minikube kubectl --profile playground -- \
  run simulate-mysql-initial \
  --image ${INIT_IMAGE_NAME}:${INIT_IMAGE_ARG} \
  --restart=Never \
  --namespace=infra \
  --env MYSQL_USR_NAME=${MYSQL_USR_NAME} \
  --env MYSQL_USR_PASSWD=${MYSQL_USR_PASSWD} \
  --env MYSQL_SERVER_URL=${MYSQL_SERVER_URL} \
  --env MYSQL_SERVER_PORT=${MYSQL_SERVER_PORT} 

```

## Simulate Operation on MySQL

```bash
# Simulate Operation on MySQL Database

MYSQL_USR_NAME=root
MYSQL_USR_PASSWD=$(kubectl get secret --namespace infra bitnami-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
MYSQL_SERVER_URL=bitnami-mysql-primary.infra.svc.cluster.local
MYSQL_SERVER_PORT=3306

OP_IMAGE_NAME=registry.jingtao.fun/simulate-mysql-op/concurrency_op
OP_IMAGE_ARG=test_v2

minikube kubectl --profile playground -- \
  delete pod simulate-mysql-op -n infra --ignore-not-found=false

minikube kubectl --profile playground -- \
  run simulate-mysql-op \
  --image ${OP_IMAGE_NAME}:${OP_IMAGE_ARG} \
  --restart=Never \
  --namespace=infra \
  --env MYSQL_USR_NAME=${MYSQL_USR_NAME} \
  --env MYSQL_USR_PASSWD=${MYSQL_USR_PASSWD} \
  --env MYSQL_SERVER_URL=${MYSQL_SERVER_URL} \
  --env MYSQL_SERVER_PORT=${MYSQL_SERVER_PORT} \
  6 600

```
