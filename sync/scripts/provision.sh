#!/bin/bash

set -e

test -f /tmp/$(basename $0).run && exit 0

#yum -y -q update
yum -y -q install ntp

ntpdate -u us.pool.ntp.org

cat /vagrant/keys/*.pub > ~root/.ssh/authorized_keys
cat /vagrant/keys/*.pub > ~ec2-user/.ssh/authorized_keys

cat >> /root/.ssh/config <<EOF

Host *
  BatchMode yes
  StrictHostKeyChecking no

EOF

touch /tmp/$(basename $0).run

