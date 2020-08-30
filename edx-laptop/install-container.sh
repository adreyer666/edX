#!/bin/bash -f

if grep -E 'vmx|svm' /proc/cpuinfo;
    then  echo "CPU has virtualization enabled"
    else  echo "Virtualization not enabled"; exit
fi

CRIO_VERSION=1.17
# . /etc/os-release
NAME="Debian"
VERSION_ID="Testing"
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/${NAME}_${VERSION_ID}/ /" >/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -sL "https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/${NAME}_${VERSION_ID}/Release.key" | apt-key add -
apt-get update -qq
apt-get install -q -y --no-install-recommends \
    buildah cri-o-runc umoci slirp4netns cri-o-${CRIO_VERSION} crun varlink \
    podman
    # podman-rootless

# activate user namespaces
echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/10-userns.conf
sysctl -p /etc/sysctl.d/10-userns.conf


