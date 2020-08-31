#!/bin/bash -f

if grep -E 'vmx|svm' /proc/cpuinfo;
    then  echo "CPU has virtualization enabled"
    else  echo "Virtualization not enabled"; exit
fi

test "${ENV_USER}" = '' && ENV_USER="student"

apt install -y \
	ssvnc \
	qemu-system-x86 qemu-kvm qemu-utils qemu-block-extra \
	libvirt-daemon libvirt-daemon-system libvirt-daemon-driver-qemu \
	libvirt-clients \
	vagrant #vagrant-libvirt
systemctl start libvirtd

## configure user settings
su - ${ENV_USER} -c "vagrant plugin install vagrant-libvirt"

