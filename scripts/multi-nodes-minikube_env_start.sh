#!/bin/bash
set -eux
set -o pipefail

# check minikube
MINIKUBE_INSTALLED="y"
which minikube >/dev/null 2>&1 || { MINIKUBE_INSTALLED="n"; }

if [[ ${MINIKUBE_INSTALLED} == "n" ]]; then
  echo "pls install minikube first"
fi

minikube version


# check helm
HELM_INSTALLED="y"
which helm >/dev/null 2>&1 || { HELM_INSTALLED="n"; }

if [[ ${HELM_INSTALLED} == "n" ]]; then
  echo "pls install helm first"
fi


# using transparent proxy instead http/https proxy
# start minikube
PROFILE_NAME="playground"

minikube \
  --profile ${PROFILE_NAME} \
  --driver=kvm2 \
  --addons metrics-server,registry \
  --kubernetes-version v1.24.3 \
  --auto-update-drivers=false \
  --nodes 4 \
  --cpus 6 \
  --memory 12g \
  --disk-size 40g \
  --kvm-network='bridged-network' \
  --image-mirror-country='cn' \
  --image-repository='auto' \
  start

minikube kubectl --profile ${PROFILE_NAME} -- get pods -A

minikube dashboard --profile ${PROFILE_NAME} --url
