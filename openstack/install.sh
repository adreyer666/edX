#!/bin/sh -f

VHOME="/vagrant"
VERSION="`cat ${VHOME}/.version`"

dnf clean all
dnf update -y
dnf install -y \
    procps iproute iptables nftables \
    curl ca-certificates psmisc sudo \
    vim-minimal gpg git jq \
    qemu-guest-agent epel-release \
    openssl-devel nss-devel \
    python3-pip python3-setuptools

#     liberasurecode-dev
#     # libssl1.0-dev

# cleanup
dnf clean all && rm -rf /tmp/* # /var/lib/apt/lists/* /var/cache/apt/archives/partial

#------------------#

ENV_USER="stack"
ENV_HOME="/opt/${ENV_USER}"
useradd -s /bin/bash -d ${ENV_HOME} -m ${ENV_USER}
echo "${ENV_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${ENV_USER}
chmod 755 ${ENV_HOME}

su - ${ENV_USER} -c "git clone https://opendev.org/openstack/devstack"
cp -av ${ENV_HOME}/devstack/samples/local.conf ${ENV_HOME}/devstack
cat >> ${ENV_HOME}/devstack/local.conf <<'eom'
[[local|localrc]]
ADMIN_PASSWORD=secret
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
eom
su - ${ENV_USER} -c "cd devstack && ./stack.sh"

exit 0

