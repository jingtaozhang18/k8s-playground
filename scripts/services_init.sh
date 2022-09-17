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

export WORKING_DIR=${WORKING_DIR}
export NFS_DOMAIN="192.168.1.0/24"
cd ${WORKING_DIR}/services_k8s/infra_standalone_services/nfs_service
docker compose up -d
cd -

helm upgrade --install nfs-subdir-external-provisioner            \
  --kube-context ${CONTEXT_NAME}                                  \
  --namespace ${NFS_STORAGE_NAMESPACE}                            \
  --values ${WORKING_DIR}/services_k8s/charts/nfs-values.yaml     \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner

helm upgrade --install bitnami-mysql                              \
  --namespace ${INFRA_NAMESPACE}                                  \
  --values ${WORKING_DIR}/services_k8s/charts/mysql-values.yaml   \
  bitnami/mysql

helm upgrade --install bitnami-kube-prometheus                              \
  --namespace ${INFRA_NAMESPACE}                                            \
  --values ${WORKING_DIR}/services_k8s/charts/kube-prometheus-values.yaml   \
  bitnami/kube-prometheus

helm upgrade --install bitnami-grafana-operator                             \
  --namespace ${INFRA_NAMESPACE}                                            \
  --values ${WORKING_DIR}/services_k8s/charts/grafana-operator-values.yaml  \
  bitnami/grafana-operator