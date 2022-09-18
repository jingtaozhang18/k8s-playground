#!/bin/bash

PROFILE_NAME=$1
NODE_NUM=$2
SOFT_ROUTE_IP=$3

node_names="${PROFILE_NAME}"

for ((i = 2; i <= ${NODE_NUM}; i++)); do
  if (($i <= 9)); then
    node_names="${node_names} ${PROFILE_NAME}-m0${i}"
  else
    node_names="${node_names} ${PROFILE_NAME}-m${i}"
  fi
done

echo "node names: ${node_names}"

sleep 10 # waitting for k8s start creating.

for node_name in ${node_names[@]}; do
  echo "current node name is ${node_name}"

  not_running=1
  while [ ${not_running} != "0" ]; do
    minikube --profile ${PROFILE_NAME} ssh -n ${node_name} ls >/dev/null 2>&1
    not_running=$?
    echo "waitting for ${PROFILE_NAME} 's ${node_name} running."
    sleep 5
    minikube --profile ${PROFILE_NAME} node list >/dev/null 2>&1
    if [ $? != 0 ]; then
      echo "${PROFILE_NAME} not exists."
      exit 1
    fi
  done

  origin_ip=$(minikube --profile ${PROFILE_NAME} \
    ssh -n ${node_name} 'ip addr show eth1' |
    grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:")
  origin_ip=$(echo ${origin_ip//\// } | awk '{print $1}')

  minikube --profile ${PROFILE_NAME} ssh -n ${node_name} "sudo ip route del default"
  minikube --profile ${PROFILE_NAME} ssh -n ${node_name} "sudo ip route del default"

  minikube --profile ${PROFILE_NAME} ssh -n ${node_name} \
    "sudo ip route add default via ${SOFT_ROUTE_IP} dev eth1 proto dhcp src ${origin_ip} metric 1024"

  echo "set ${PROFILE_NAME} 's ${node_name} route done."
done
