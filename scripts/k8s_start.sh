#!/bin/bash
set -eux
set -o pipefail

WORKING_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
WORKING_DIR="${WORKING_DIR}/.."

# check minikube
MINIKUBE_INSTALLED="y"
which minikube >/dev/null 2>&1 || { MINIKUBE_INSTALLED="n"; }

if [[ ${MINIKUBE_INSTALLED} == "n" ]]; then
  echo "pls install minikube first"
  exit 1
fi

minikube version

# using transparent proxy instead http/https proxy
# start minikube
PROFILE_NAME="playground"
SOFT_ROUTE_IP="192.168.1.41"
NODE_NUM=4
bash ${WORKING_DIR}/scripts/k8s_set_route.sh ${PROFILE_NAME} ${NODE_NUM} ${SOFT_ROUTE_IP} &
minikube \
  --profile ${PROFILE_NAME} \
  --driver=kvm2 \
  --addons registry \
  --kubernetes-version v1.24.3 \
  --auto-update-drivers=false \
  --nodes ${NODE_NUM} \
  --cpus 6 \
  --memory 12g \
  --disk-size 40g \
  --kvm-network='bridged-network' \
  start

minikube kubectl --profile ${PROFILE_NAME} -- get pods -A

minikube dashboard --profile ${PROFILE_NAME} --url
