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

CONTEXT_NAME="playground"
NFS_STORAGE_NAMESPACE="storage-nfs"
INFRA_NAMESPACE="infra"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner

helm repo update

# get host ip
BR0_IP=$(ip addr show br0 | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
BR0_IP=$(echo ${BR0_IP//\// } | awk '{print $1}')
echo "your host ip: ${BR0_IP}"
helm upgrade --install nfs-subdir-external-provisioner \
  --kube-context ${CONTEXT_NAME} \
  --namespace ${NFS_STORAGE_NAMESPACE} \
  --values configs/charts_values/nfs-values.yaml \
  --set nfs.server=${BR0_IP} \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

helm upgrade --install bitnami-kube-prometheus \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/kube-prometheus-values.yaml \
  bitnami/kube-prometheus

helm upgrade --install bitnami-mysql \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/mysql-values.yaml \
  bitnami/mysql

helm upgrade --install bitnami-grafana-operator \
  --namespace ${INFRA_NAMESPACE} \
  --values ${WORKING_DIR}/configs/charts_values/grafana-operator-values.yaml \
  bitnami/grafana-operator
