minikube -p playground delete
sudo rm -rf nfs_mount_point/k8s-playground/infra*
bash scripts/k8s_start.sh
bash scripts/k8s_infra_services_enable.sh