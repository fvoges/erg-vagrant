# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# Load sensitive AWS credentials from external file
if File.exist?('config/aws.yaml')
  aws_config  = YAML.load_file('config/aws.yaml')['aws']
  pemfile     = aws_config['pemfile']
end
boxes = [
  {
    :name           =>  'fv-erg-jump',
    :primary        =>  'true',
    :instance_type  =>  'm3.medium'
  },
  {
    :name           =>  'fv-erg-ipuppetca',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium'
  },

]

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
BOX_TIMEOUT             = 180


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  boxes.each do |box|
    config.vm.define box[:name], primary: box[:primary] do |config|
      config.vm.box                 = 'dummy'
      config.vm.box_url             = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'

      config.vm.boot_timeout        = BOX_TIMEOUT
      config.vm.synced_folder '.', '/vagrant', :disabled => true
      config.vm.synced_folder 'pe-install', '/tmp/pe-install/'

      config.vm.provider :aws do |aws, override|
        aws.access_key_id             = ENV['AWS_ACCESS_KEY']
        aws.secret_access_key         = ENV['AWS_SECRET_KEY']

        aws.keypair_name               = aws_config['keypair_name']
        aws.user_data                 = aws_config['user_data']
        aws.ami                       = aws_config["ami"]
        aws.instance_type             = box[:instance_type]
        aws.region                    = aws_config['region']
        aws.security_groups           = aws_config['security_groups']
        aws.instance_ready_timeout    = BOX_TIMEOUT

        aws.tags = {
          'Name'        => box[:name],
          'Project'     => 'ERG',
          'Department'  => 'CS',
          'Owner'       => 'fvoges'
        }

        override.ssh.username         = 'ec2-user'
        override.ssh.private_key_path = pemfile
        override.ssh.forward_agent    = true
      end

#      config.vm.provision :shell, :privileged => false, :inline => "sudo cp -f /vagrant/etc-setup/etc-resolv-conf /etc/resolv.conf"
#      config.vm.provision :shell, :privileged => false, :inline => "cp /vagrant/ssh-setup/config /home/ec2-user/.ssh/"
#      config.vm.provision :shell, :privileged => false, :inline => "cp /vagrant/ssh-setup/RHEL-OSE-DEMO.pem /home/ec2-user/.ssh/"
#      config.vm.provision :shell, :privileged => false, :inline => "sudo yum -y install screen"
#      config.vm.provision :shell, :privileged => false, :inline => "sudo yum -y update"

      config.ssh.pty                  = true
    end
  end
end
