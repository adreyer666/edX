#!/bin/bash -f

if grep -E 'vmx|svm' /proc/cpuinfo;
    then  echo "CPU has virtualization enabled"
    else  echo "Virtualization not enabled"; exit
fi

test "${ENV_USER}" = '' && ENV_USER="student"
test "${ENV_HOME}" = '' && ENV_HOME="/home/${ENV_USER}"

curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl

#KUBECTL_VER=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
#curl -sL "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VER}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
#chmod 0755  /usr/local/bin/kubectl

kubectl version --client

MINIKUBE_VER=1.12.3
cd /var/tmp
curl -LOR https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
apt install ./minikube_latest_amd64.deb

## configure user settings
su - ${ENV_USER} -c "minikube config set driver podman"
su - ${ENV_USER} -c "minikube config set driver docker"
su - ${ENV_USER} -c "minikube config set container-runtime cri-o"
# su - ${ENV_USER} -c "minikube start --alsologtostderr -v=7"
# su - ${ENV_USER} -c "minikube status"
# su - ${ENV_USER} -c "kubectl config view; cat ~/.kube/config"
