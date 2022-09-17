#!/bin/bash
set -eux
set -o pipefail

WORKING_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
WORKING_DIR="${WORKING_DIR}/.."
CONTEXT_NAME="playground"
NFS_STORAGE_NAMESPACE="storage-nfs"
INFRA_NAMESPACE="infra"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner

helm repo update

helm upgrade --install nfs-subdir-external-provisioner              \
  --kube-context ${CONTEXT_NAME}                                    \
  --namespace ${NFS_STORAGE_NAMESPACE}                              \
  --values ${WORKING_DIR}/configs/charts_values/nfs-values.yaml     \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

helm upgrade --install bitnami-mysql                                \
  --namespace ${INFRA_NAMESPACE}                                    \
  --values ${WORKING_DIR}/configs/charts_values/mysql-values.yaml   \
  bitnami/mysql

helm upgrade --install bitnami-kube-prometheus                                \
  --namespace ${INFRA_NAMESPACE}                                              \
  --values ${WORKING_DIR}/configs/charts_values/kube-prometheus-values.yaml   \
  bitnami/kube-prometheus

helm upgrade --install bitnami-grafana-operator                               \
  --namespace ${INFRA_NAMESPACE}                                              \
  --values ${WORKING_DIR}/configs/charts_values/grafana-operator-values.yaml  \
  bitnami/grafana-operator