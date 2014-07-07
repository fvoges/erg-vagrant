erg-vagrant
===========

Vagrantfile to launch a bunch of Amazon EC2 instances using https://github.com/mitchellh/vagrant-aws

Users environment variables for the EC2 keys:

```shell
export AWS_ACCESS_KEY=YOUR_ACCESS_KEY
export AWS_SECRET_KEY=YOUR_SECRET_KEY
```

The provisioning script expects to find the priv and pub keys for the jump host inside sync/keys/jump_key{,.pub} 
It will *overwrite* /root/.ssh/authorized_keys using /vagrant/sync/keys/*.pub. so make sure you add your pub keys there if you want to be able to login :D

Based on https://github.com/ichristo/vagrant-aws-rhel

Network setup

This setup now uses Amazon VPC to allow to easily setup host resolution.

For it to work, you'll have to create a single public subnet VPC (no extra cost) and a security group (unless the Allow ALL default SG works for you). The Security Group has to be configured in the VPC console, not the EC2 one.

To configure the Vagrant file, you'll need the security group ID and the subnet info. Amazon reserves a few IPs at the beginning of the netblock. If you use the default CIDR (10.0.0.0/16), that means that you are going to be using IPs in the 10.0.0.0/24 range (start at 10.0.0.10 to be safe).


