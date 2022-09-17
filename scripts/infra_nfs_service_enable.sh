#!/bin/bash
set -eux
set -o pipefail

WORKING_DIR=$(
  cd "$(dirname "$0")"
  pwd
)
WORKING_DIR="${WORKING_DIR}/.."

export WORKING_DIR=${WORKING_DIR}
export NFS_DOMAIN="192.168.1.0/24"  # Be Careful

cd ${WORKING_DIR}/infra_standalone_services/nfs_service
docker compose up -d
cd -