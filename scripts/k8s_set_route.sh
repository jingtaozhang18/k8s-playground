#!/bin/bash

PROFILE_NAME=$1
SOFT_ROUTE_IP=$2
node_names="
  ${PROFILE_NAME}
  ${PROFILE_NAME}-m02
  ${PROFILE_NAME}-m03
  ${PROFILE_NAME}-m04
"
for node_name in ${node_names[@]}; do
  echo "current node name is ${node_name}"

  not_running=1
  while [ ${not_running} != "0" ]; do
    minikube --profile ${PROFILE_NAME} ssh -n ${node_name} ls >/dev/null 2>&1
    not_running=$?
    echo "waitting for ${PROFILE_NAME} 's ${node_name} running."
    sleep 5
  done
  
  origin_ip=$(minikube --profile ${PROFILE_NAME} \
  ssh -n ${node_name} 'ip addr show eth1' \
  |grep inet |grep -v 127.0.0.1 |grep -v inet6 |awk '{print $2}' |tr -d "addr:")
  origin_ip=$(echo ${origin_ip//\// } |awk '{print $1}')

  minikube --profile ${PROFILE_NAME} ssh -n ${node_name} "sudo ip route del default"
  minikube --profile ${PROFILE_NAME} ssh -n ${node_name} "sudo ip route del default"

  minikube --profile ${PROFILE_NAME} ssh -n ${node_name} \
    "sudo ip route add default via ${SOFT_ROUTE_IP} dev eth1 proto dhcp src ${origin_ip} metric 1024"
  echo "set ${PROFILE_NAME} 's ${node_name} route done."
done