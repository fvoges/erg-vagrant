#!/bin/bash

set -e

test -f /tmp/$(basename $0).run && exit 0

PE_VER=3.2.3
PE_TAR=puppet-enterprise-${PE_VER}-el-6-x86_64.tar.gz

curl -sLo /vagrant/pe-install/${PE_TAR} https://s3.amazonaws.com/pe-builds/released/${PE_VER}/${PE_TAR}

cp /vagrant/keys/jump_key /root/.ssh/id_rsa

yum -y -q install gcc wget python python-devel git gpm-devel
easy_install fabric

curl -s https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

cat >> /root/.bashrc <<"EOF"

### RBENV ###
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
### RBENV ###

EOF

source /root/.bashrc

rbenv install --skip-existing 1.9.3-p547
rbenv global 1.9.3-p547

touch /tmp/$(basename $0).run

