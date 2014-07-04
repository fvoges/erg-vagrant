#!/bin/bash

set -e

yum -yq update

cat /vagrant/keys/*.pub > ~root/.ssh/authorized_keys
cat /vagrant/keys/*.pub > ~ec2-user/.ssh/authorized_keys

PE_VER=3.2.3
PE_TAR=puppet-enterprise-${PE_VER}-el-6-x86_64.tar.gz

mkdir -p /tmp/pe-install
cp -r /vagrant/pe-install/. /tmp/pe-install
curl -Lo /tmp/pe-install/${PE_TAR} https://s3.amazonaws.com/pe-builds/released/${PE_VER}/${PE_TAR}
