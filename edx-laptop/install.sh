#!/bin/sh -f

ANACONDA_VERSION=2020.07
ANACONDA_HASH="38ce717758b95b3bd0b1797cc6ccfb76f29a90c25bdfa50ee45f11e583edfdbf"

DEBIAN_FRONTEND=noninteractive; export DEBIAN_FRONTEND
VCONF="/vagrant/conf"
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
	useradd -d ${ENV_HOME} -m -s /bin/bash ${ENV_USER}
        echo "${ENV_USER}:${ENV_PASS}" | chpasswd
fi
echo "${ENV_USER}   ALL=(ALL:ALL) NOPASSWD: ALL"  > /etc/sudoers.d/${ENV_USER}
mkdir -p ${ENV_HOME}/workspace
chown -R ${ENV_USER}: ${ENV_HOME}/workspace

if test -f ${ENV_HOME}/.bashrc; then
    echo '## .bash_profile"' > ${ENV_HOME}/.bash_profile
    echo 'export bash_profile_read=1' >> ${ENV_HOME}/.bash_profile
    echo 'test -f "${HOME}/.profile" && . "${HOME}/.profile"' >> ${ENV_HOME}/.bash_profile
    su - ${ENV_USER} -c "git config --global pull.ff only"
    PREFIX="${ENV_HOME}/anaconda3"
    if test ! -d ${PREFIX}; then
        cd /tmp
	set -x
        curl -skL https://repo.anaconda.com/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -o anaconda.sh
        echo "${ANACONDA_HASH} anaconda.sh" > anaconda.sha256sum
        sha256sum -c anaconda.sha256sum || exit
        bash anaconda.sh -b -p ${PREFIX}
        rm -f anaconda.sh anaconda.sha256sum
        chown -R ${ENV_USER}: ${PREFIX}
        echo 'test -f "${HOME}/anaconda3/etc/profile.d/conda.sh" && . "${HOME}/anaconda3/etc/profile.d/conda.sh"' >> ${ENV_HOME}/.bash_profile
        echo 'test -d "${HOME}/anaconda3/bin" && PATH="${HOME}/anaconda3/bin:${PATH}" && export PATH' >> ${ENV_HOME}/.bash_profile
    fi
    # user environment customisations that need X running
    sed -e "s/%VERSION%/${VERSION}/g" \
	-e "s/%INSTALL_VERSION%/${INSTALL_VERSION}/g" \
	-e "s/%ANACONDA_VERSION%/${ANACONDA_VERSION}/g" \
       	< ${VCONF}/xsetup.tmpl > ${ENV_HOME}/.xsetup
    echo 'test "$DISPLAY" != "" && test -f "${HOME}/.xsetup" && "${HOME}/.xsetup"' >> ${ENV_HOME}/.bash_profile
    #echo 'test -f "${HOME}/.bash_profile" && "${HOME}/.bash_profile"' >> ${ENV_HOME}/.bashrc
    mkdir -p ${ENV_HOME}/.config/autostart
    dex -v  -e MATE -t ${ENV_HOME}/.config/autostart/ -c ${ENV_HOME}/.xsetup
    chown -R ${ENV_USER}: ${ENV_HOME}/.xsetup ${ENV_HOME}/.bash_profile ${ENV_HOME}/.config/
    chmod -R 0750 ${ENV_HOME}/.xsetup ${ENV_HOME}/.bash_profile
fi
exit 0

