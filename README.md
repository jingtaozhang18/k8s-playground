# k8s-playground
For building a multi-nodes k8s environment with infra services.

## Architecture

Show as below.

![](imgs/architecture.png)

## Install Step

### Install Ubuntu

Install Ubuntu22 in HP Z440 Workstation and install common command.

Ubuntu ISO:
  
  * [download page](https://ubuntu.com/download/desktop)
  * [download link](https://ubuntu.osuosl.org/releases/22.04.1/ubuntu-22.04.1-desktop-amd64.iso)

Install Common Command:

```bash
sudo apt update
sudo apt install -y \
  htop iftop \
  vim \
  curl wget \
  make
```

### Install KVM

Install KVM through apt command

```bash
sudo apt -y install \
  bridge-utils \
  cpu-checker \
  libvirt-clients \
  libvirt-daemon \
  qemu \
  qemu-kvm
```

Refer Page: [KVM hypervisor: a beginners’ guide](https://ubuntu.com/blog/kvm-hyphervisor)

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

Minikube Install Page: [Minikube Start](https://minikube.sigs.k8s.io/docs/start/)
Helm Install Page: [Installing Helm](https://helm.sh/docs/intro/install/)

