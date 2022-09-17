#!/bin/bash
set -eux
set -o pipefail

# install minikube, refer to https://minikube.sigs.k8s.io/docs/start/
MINIKUBE_INSTALLED="y"
which minikube >/dev/null 2>&1 || { MINIKUBE_INSTALLED="n"; }

if [[ ${MINIKUBE_INSTALLED} == "n" ]]; then
  curl -LO https://storage.googleapis.com/minikube/releases/v1.26.1/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  rm minikube-linux-amd64
  echo "your minikube command has been installed at $(which minikube)"
  echo "## run below command to get kubectl"
  echo "echo \"alias k='minikube kubectl'\" >> ~/.bashrc"
else
  echo "your minikube command already exists at $(which minikube)"
fi

minikube version


# install helm

HELM_INSTALLED="y"
which helm >/dev/null 2>&1 || { HELM_INSTALLED="n"; }

if [[ ${HELM_INSTALLED} == "n" ]]; then
  curl -fsSL -o ./get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 ./get_helm.sh
  ./get_helm.sh
  rm ./get_helm.sh
  echo "your helm command has been installed at $(which helm)"
else
  echo "your helm command already exists at $(which helm)"
fi


# using transparent proxy instead http/https proxy
# start minikube
PROFILE_NAME="playground"

minikube \
  --driver=kvm2 \
  --addons metrics-server,registry \
  --kubernetes-version v1.24.3 \
  --profile ${PROFILE_NAME} \
  --cpus 5 \
  --memory 12g \
  --disk-size 40g \
  --kvm-network='bridged-network' \
  --mount-string='./vm_mount:/minikube-host' \
  --nodes 4 \
  start

#   --image-mirror-country='cn' \

minikube kubectl --profile ${PROFILE_NAME} -- get pods -A

minikube dashboard --profile ${PROFILE_NAME} --url
