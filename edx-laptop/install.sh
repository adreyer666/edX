#!/bin/sh -f

ANACONDA_VERSION=2020.07
ANACONDA_HASH="38ce717758b95b3bd0b1797cc6ccfb76f29a90c25bdfa50ee45f11e583edfdbf"

DEBIAN_FRONTEND=noninteractive; export DEBIAN_FRONTEND
VHOME="/vagrant"
VCONF="${VHOME}/conf"
VERSION="`cat ${VCONF}/../.version`"
INSTALL_VERSION="${ANACONDA_VERSION}--${VERSION}"

apt-get update -q
apt-get upgrade -q -y
apt-get dist-upgrade -q -y

apt-get install -q -y --no-install-recommends \
    procps iproute2 iptables nftables \
    curl ca-certificates psmisc sudo \
    vim-tiny openssh-client gpg gpg-agent lrzip \
    qemu-guest-agent git jq \
    xauth x11-apps x11-utils xterm libxtst6 libasound2 xdg-utils \
    build-essential fakeroot \
    pandoc fonts-dejavu sshpass \
    libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libxi6 libasound2 libxtst6 \
    darkmint-gtk-theme gtk-theme-switch gnome-tweaks

# make it a desktop install
apt-get install -q -y --no-install-recommends \
    plymouth xserver-xorg lightdm desktop-file-utils dex dconf-cli \
    mate-desktop-environment mate-session-manager mate-control-center mate-terminal mate-themes
systemctl set-default graphical.target
systemctl start graphical.target

# add more utils and GUI apps
apt-get install -q -y --no-install-recommends \
    meld gitk sqlitebrowser \
    atril audacious firefox-esr

# cleanup
apt-get autoremove -y
apt-get install -f
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/partial


#------------------#

#cp -v ${VCONF}/org.edx.edx-laptop.gschema.xml /usr/share/glib-2.0/schemas/
#glib-compile-schemas /usr/share/glib-2.0/schemas/

ENV_USER="user"
ENV_PASS="pass"
ENV_HOME="/home/${ENV_USER}"
if id ${ENV_USER};
    then echo
    else
	#groupadd -g 999 ${ENV_USER}
	#useradd -d ${ENV_HOME} -u 999 -g 999 -m -s /bin/bash ${ENV_USER}
        useradd -d ${ENV_HOME} -m -s /bin/bash ${ENV_USER}
        echo "${ENV_USER}:${ENV_PASS}" | chpasswd
fi
echo "${ENV_USER}   ALL=(ALL:ALL) NOPASSWD: ALL"  > /etc/sudoers.d/${ENV_USER}
mkdir -p /data/workspace
ln -s /data/workspace ${ENV_HOME}/workspace

test -x ${VHOME}/install-dev.sh && ${VHOME}/install-dev.sh
test -x ${VHOME}/install-container.sh && ${VHOME}/install-container.sh
test -x ${VHOME}/install-kubernetes.sh && ${VHOME}/install-kubernetes.sh

exit 0

