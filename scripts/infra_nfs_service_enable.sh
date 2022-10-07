#!/bin/bash
set -eux
set -o pipefail

WORKING_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
WORKING_DIR="${WORKING_DIR}/.."

export WORKING_DIR=${WORKING_DIR}
# export NFS_DOMAIN=$(ip addr show br0 | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:") # Be Careful
export NFS_DOMAIN="192.168.0.0/16" # Be Careful

echo "NFS_DOMAIN has been set to ${NFS_DOMAIN}"

cd ${WORKING_DIR}/infra_standalone_services/nfs_service
docker compose up -d
cd -
