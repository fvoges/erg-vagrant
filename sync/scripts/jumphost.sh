#!/bin/bash

set -e

cp /vagrant/keys/jump_key /root/.ssh/id_rsa

yum -yq install gcc wget python python-devel git gpm-devel
easy_install fabric

curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash

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

rbenv install 1.9.3-p547
rbenv global 1.9.3-p547


