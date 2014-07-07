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
    :instance_type  =>  'm3.medium',
    :extra_script   =>  '/vagrant/scripts/jumphost.sh',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.10',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-puppetca',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.11',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-puppetdb',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.12',
    :elastic_ip     =>  'true',
  },
#  {
#    :name           =>  'fv-erg-puppetlb',
#    :primary        =>  'false',
#    :instance_type  =>  'm3.medium',
#    :elastic_ip     =>  'true',
#  },
  {
    :name           =>  'fv-erg-puppetmaster01',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.13',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-puppetmaster02',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.14',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-puppetmaster03',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.15',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-mcohub',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.16',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-mcospoke01',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.17',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-mcospoke02',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.18',
    :elastic_ip     =>  'true',
  },
  {
    :name           =>  'fv-erg-mcospoke03',
    :primary        =>  'false',
    :instance_type  =>  'm3.medium',
    :subnet_id      =>  'subnet-d46f8da3',
    :private_ip     =>  '10.0.0.19',
    :elastic_ip     =>  'true',
  },

]

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
BOX_TIMEOUT             = 180


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  boxes.each do |box|
    config.hostmanager.enabled            = false
    config.hostmanager.manage_host        = false
    config.hostmanager.ignore_private_ip  = false
    config.hostmanager.include_offline    = false

    config.vm.define box[:name], primary: box[:primary] do |node|
      node.vm.box                 = 'dummy'
      node.vm.box_url             = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'
      node.vm.hostname            = box[:name]

      node.vm.boot_timeout        = BOX_TIMEOUT
      node.vm.synced_folder '.', '/vagrant', :disabled => true
      node.vm.synced_folder 'sync', '/vagrant'

      node.vm.provider :aws do |aws, override|
        aws.access_key_id                       = ENV['AWS_ACCESS_KEY']
        aws.secret_access_key                   = ENV['AWS_SECRET_KEY']

        aws.keypair_name                        = aws_config['keypair_name']
        aws.user_data                           = aws_config['user_data']
        aws.ami                                 = aws_config["ami"]
        aws.instance_type                       = box[:instance_type]
        aws.region                              = aws_config['region']
        aws.security_groups                     = aws_config['security_groups']
        aws.instance_ready_timeout              = BOX_TIMEOUT
        if box[:subnet_id]
          aws.subnet_id                         = box[:subnet_id]
          aws.private_ip_address                = box[:private_ip]
          aws.associate_public_ip               = box[:elastic_ip]

          # We want to setup /etc/hosts with the private IPs
          node.hostmanager.ip_resolver = proc do |vm, resolving_vm|
            box[:private_ip]
          end
          node.hostmanager.aliases      = [ box[:name] + ".puppetlabs.vm" ]
        end

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

#      node.vm.provision :shell, :privileged => false, :inline => "sudo cp -f /vagrant/etc-setup/etc-resolv-conf /etc/resolv.conf"
#      node.vm.provision :shell, :privileged => false, :inline => "cp /vagrant/ssh-setup/config /home/ec2-user/.ssh/"
#      node.vm.provision :shell, :privileged => false, :inline => "cp /vagrant/ssh-setup/RHEL-OSE-DEMO.pem /home/ec2-user/.ssh/"
#      node.vm.provision :shell, :privileged => false, :inline => "sudo yum -y -q update"
      node.vm.provision :shell, :privileged => false, :inline => "sudo yum -y -q install screen"

      node.vm.provision :shell, :privileged => true, :inline => '/vagrant/scripts/provision.sh'
      node.vm.provision :hostmanager

      if box[:extra_script]
        node.vm.provision :shell, :privileged => true, :inline => box[:extra_script]
      end

      node.ssh.pty                  = true
    end
  end
end
