# k8s-playground
For building a multi-nodes k8s environment with infra services.

Table Contents

- [k8s-playground](#k8s-playground)
  - [Architecture](#architecture)
  - [Install Steps](#install-steps)
    - [Install Ubuntu](#install-ubuntu)
    - [Install KVM and Docker](#install-kvm-and-docker)
    - [Install Minikube and Helm](#install-minikube-and-helm)
    - [Config Network Environment](#config-network-environment)
  - [Start K8s Cluster](#start-k8s-cluster)

## Architecture

Show as below.

![](imgs/architecture.png)

## Install Steps

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

You need to config network environment, includes create virtual bridge and virtual

Create bridge by netplan command. Pls check [network config file](configs/network/01-network-manager-all.yaml) first, and the default config will use a static ip which may not be right for you.

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

## Start K8s Cluster