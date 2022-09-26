#!/bin/bash
set -eux
set -o pipefail

WORKING_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
WORKING_DIR="${WORKING_DIR}/.."

HELM_LIST=$(helm list -A | grep -v NAME | awk '{print $1,$2}')

helm uninstall bitnami-cosmos-shared -n infra
helm uninstall bitnami-grafana-operator -n infra
helm uninstall bitnami-jupyterhub -n infra
helm uninstall bitnami-kafka -n infra
helm uninstall bitnami-kube-prometheus -n infra
helm uninstall bitnami-mysql -n infra
helm uninstall bitnami-postgresql -n infra
helm uninstall bitnami-spark -n infra
helm uninstall my-release -n default
helm uninstall nfs-subdir-external-provisioner -n storage-nfs