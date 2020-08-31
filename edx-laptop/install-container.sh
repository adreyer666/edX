#!/bin/bash -f

if grep -E 'vmx|svm' /proc/cpuinfo;
    then  echo "CPU has virtualization enabled"
    else  echo "Virtualization not enabled"; exit
fi

test "${ENV_USER}" = '' && ENV_USER="student"
CRIO_VERSION=1.17
NAME="Debian"
VERSION_ID="Testing"
DOCKER_REL="buster"  # $(lsb_release -cs) 

echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/${NAME}_${VERSION_ID}/ /" >/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -sL "https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/${NAME}_${VERSION_ID}/Release.key" | apt-key add -
apt-get update -qq
apt-get install -q -y --no-install-recommends \
    cri-o-runc umoci slirp4netns cri-o-${CRIO_VERSION} crun varlink \
    buildah podman # podman-rootless

echo "deb [arch=amd64] https://download.docker.com/linux/debian  ${DOCKER_REL} stable" > /etc/apt/sources.list.d/docker-ce.list
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-get install -q -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io fuse-overlayfs
usermod -aG docker ${ENV_USER}

# activate user namespaces
echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/10-userns.conf
sysctl -p /etc/sysctl.d/10-userns.conf


