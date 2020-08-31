#!/bin/sh -f

ANACONDA_VERSION=2020.07
ANACONDA_HASH="38ce717758b95b3bd0b1797cc6ccfb76f29a90c25bdfa50ee45f11e583edfdbf"

VCONF="/vagrant/conf"
VERSION="`cat ${VCONF}/../.version`"
INSTALL_VERSION="${ANACONDA_VERSION}--${VERSION}"

test "${ENV_USER}" = '' && ENV_USER="student"
test "${ENV_HOME}" = '' && ENV_HOME="/home/${ENV_USER}"
test -f ${ENV_HOME}/.bashrc || exit

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
    mkdir -p ${ENV_HOME}/.config/spyder-py3/config/
    cp -v ${VCONF}/spyder.ini ${ENV_HOME}/.config/spyder-py3/config/transient.ini
    mkdir -p ${ENV_HOME}/.anaconda/navigator/
    cp -v ${VCONF}/anaconda-navigator.ini ${ENV_HOME}/.anaconda/navigator/anaconda-navigator.ini
    chown -R ${ENV_USER}: ${PREFIX} ${ENV_HOME}/.config ${ENV_HOME}/.anaconda
    echo 'test -f "${HOME}/anaconda3/etc/profile.d/conda.sh" && . "${HOME}/anaconda3/etc/profile.d/conda.sh"' >> ${ENV_HOME}/.bash_profile
    echo 'test -d "${HOME}/anaconda3/bin" && PATH="${HOME}/anaconda3/bin:${PATH}" && export PATH' >> ${ENV_HOME}/.bash_profile
fi

# user environment customisations that need X running
sed -e "s/%VERSION%/${VERSION}/g" \
    -e "s/%INSTALL_VERSION%/${INSTALL_VERSION}/g" \
    -e "s/%ANACONDA_VERSION%/${ANACONDA_VERSION}/g" \
    < ${VCONF}/xsetup.tmpl > ${ENV_HOME}/.xsetup
echo 'test "$DISPLAY" != "" && test -f "${HOME}/.xsetup" && "${HOME}/.xsetup"' >> ${ENV_HOME}/.bash_profile
echo '#test -f "${HOME}/.bash_profile" && "${HOME}/.bash_profile"' >> ${ENV_HOME}/.bashrc
mkdir -p ${ENV_HOME}/.config/autostart
dex -v  -e MATE -t ${ENV_HOME}/.config/autostart/ -c ${ENV_HOME}/.xsetup
chown -R ${ENV_USER}: ${ENV_HOME}/.xsetup ${ENV_HOME}/.bash_profile ${ENV_HOME}/.config/
chmod -R 0750 ${ENV_HOME}/.xsetup ${ENV_HOME}/.bash_profile

