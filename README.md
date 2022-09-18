# k8s-playground
For building a multi-nodes k8s cluster environment with infra services.

Table Contents

- [k8s-playground](#k8s-playground)
  - [Architecture](#architecture)
  - [Prepare the Host Environment](#prepare-the-host-environment)
    - [Install Ubuntu](#install-ubuntu)
    - [Install KVM and Docker](#install-kvm-and-docker)
    - [Install Minikube and Helm](#install-minikube-and-helm)
    - [Config Network Environment](#config-network-environment)
  - [Create K8S Cluster](#create-k8s-cluster)
    - [Create Infra Standalone Services](#create-infra-standalone-services)
      - [Create NFS Server](#create-nfs-server)
    - [Start K8S Cluster](#start-k8s-cluster)
  - [Install Infra Service in K8S](#install-infra-service-in-k8s)
    - [Install `nfs-client` Storage Class](#install-nfs-client-storage-class)

## Architecture

The overall structure is shown in the figure below

![](imgs/architecture.png)

## Prepare the Host Environment

### Install Ubuntu

Install Ubuntu22 in HP Z440 Workstation and install common command.

Install common command through apt.

```bash
sudo apt update
sudo apt install -y \
  htop iftop \
  vim \
  curl wget \
  make
```

Refer:

  * [Ubuntu Desktop Download Page](https://ubuntu.com/download/desktop)
  * [Ubuntu22.04 ISO Download Link](https://ubuntu.osuosl.org/releases/22.04.1/ubuntu-22.04.1-desktop-amd64.iso)

### Install KVM and Docker

Install KVM through apt command.

```bash
sudo apt -y install \
  bridge-utils \
  cpu-checker \
  libvirt-clients \
  libvirt-daemon \
  qemu \
  qemu-kvm
```

Install Docker through apt command. It is recommended to install according to the latest official website introduction.

```bash
sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install \
  docker-ce docker-ce-cli \
  containerd.io \
  docker-compose-plugin
```

Refer:

  * [KVM Hypervisor: a Beginners’ Guide](https://ubuntu.com/blog/kvm-hyphervisor)
  * [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

### Install Minikube and Helm

This repo used special version of minikube and helm.

Install Minikube:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/v1.26.1/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
```

Install Helm:

```bash
curl -fsSL -o ./get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 ./get_helm.sh
./get_helm.sh
rm ./get_helm.sh
```

Refer:

  * [Minikube Start](https://minikube.sigs.k8s.io/docs/start/)
  * [Installing Helm](https://helm.sh/docs/intro/install/)

### Config Network Environment

Config network environment, includes creating virtual bridge and kvm virtual network. They will be `bridge br0` as shown in the architecture diagram.

Create virtual bridge by netplan command. Pls check [network config file](configs/network/01-network-manager-all.yaml) first, and the default config will use a static ip which may not be right for you.

```bash
mv /etc/netplan/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml.backup
mv configs/network/01-network-manager-all.yaml /etc/netplan/01-network-manager-all.yaml
sudo netplan apply
```

Create KVM virtual network.

```bash
sudo virsh net-define configs/network/kvm-bridged-network.xml
sudo virsh net-start bridged-network
sudo virsh net-autostart bridged-network
sudo virsh net-list
```

## Create K8S Cluster

### Create Infra Standalone Services

It is need to create some infra to support k8s running well because this is a multi-nodes cluster.

#### Create NFS Server

Create NFS server through [bash script](scripts/infra_nfs_service_enable.sh), before running it, pls check `NFS_DOMAIN` variable which indicates the subnet that can access the NFS service.

### Start K8S Cluster

Now, It is all ready for starting k8s cluster! Start it through below command.

```bash
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
```

To get nodes:

```bash
PROFILE_NAME="playground"
minikube kubectl --profile ${PROFILE_NAME} -- get pods -A
```

To access dashboard:

```bash
PROFILE_NAME="playground"
minikube dashboard --profile ${PROFILE_NAME} --url
```

Refer to [multi-nodes-minikube_env_start.sh](scripts/multi-nodes-minikube_env_start.sh).

## Install Infra Service in K8S

Refer to [k8s_infra_services_enable.sh](scripts/k8s_infra_services_enable.sh) for all deploy code.

### Install `nfs-client` Storage Class

Because this is a multi-nodes k8s, so the default storage class which using a certain host path can't satisfy the need. And the `nfs-client` storage class can mount a nfs path which can be accessed by any node.

Deploy it using below command.

```bash
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update
CONTEXT_NAME="playground"
NFS_STORAGE_NAMESPACE="storage-nfs"
helm upgrade --install nfs-subdir-external-provisioner            \
  --kube-context ${CONTEXT_NAME}                                  \
  --namespace ${NFS_STORAGE_NAMESPACE}                            \
  --values configs/charts_values/nfs-values.yaml                  \
  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
```

Refer:
  * [Kubernetes NFS Subdir External Provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)

