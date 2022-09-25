#!/bin/bash
set -eux
set -o pipefail

WORKING_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
WORKING_DIR="${WORKING_DIR}/.."

# check helm
HELM_INSTALLED="y"
which helm >/dev/null 2>&1 || { HELM_INSTALLED="n"; }

if [[ ${HELM_INSTALLED} == "n" ]]; then
  echo "pls install helm first"
  exit 1
fi

PROFILE_NAME="playground"
CONTEXT_NAME=${PROFILE_NAME}
NFS_STORAGE_NAMESPACE="storage-nfs"
INFRA_NAMESPACE="infra"

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# get host ip
BR0_IP=$(ip addr show br0 | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
BR0_IP=$(echo ${BR0_IP//\// } | awk '{print $1}')
echo "your host ip: ${BR0_IP}"
minikube kubectl --profile ${PROFILE_NAME} -- create namespace ${NFS_STORAGE_NAMESPACE} --dry-run=client -o yaml | minikube kubectl --profile ${PROFILE_NAME} -- apply -f -
helm upgrade --install nfs-subdir-external-provisioner \
  --kube-context ${CONTEXT_NAME} \
  --namespace ${NFS_STORAGE_NAMESPACE} \
  --values configs/charts_values/nfs-values.yaml \
  --set nfs.server=${BR0_IP} \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner


minikube kubectl --profile ${PROFILE_NAME} -- create namespace ${INFRA_NAMESPACE} --dry-run=client -o yaml | minikube kubectl --profile ${PROFILE_NAME} -- apply -f -

helm upgrade --install bitnami-kube-prometheus \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/kube-prometheus-values.yaml \
  bitnami/kube-prometheus

# helm upgrade --install bitnami-node-exporter \
#   --namespace ${INFRA_NAMESPACE} \
#   bitnami/node-exporter

helm upgrade --install bitnami-mysql \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/mysql-values.yaml \
  bitnami/mysql

helm upgrade --install bitnami-grafana-operator \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/grafana-operator-values.yaml \
  bitnami/grafana-operator

helm upgrade --install bitnami-postgresql \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/postgresql-values.yaml \
  bitnami/postgresql

helm upgrade --install bitnami-jupyterhub \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/jupyterhub-values.yaml \
  bitnami/jupyterhub

helm upgrade --install bitnami-kafka \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/kafka-values.yaml \
  bitnami/kafka

helm upgrade --install bitnami-spark \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/spark-values.yaml \
  bitnami/spark

helm upgrade --install bitnami-cosmos-shared \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/mongo-db-shared-values.yaml \
  bitnami/mongodb-sharded
