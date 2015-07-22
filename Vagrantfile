# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box      = "hydra/sufia.0.6"
  config.vm.box_url  = "https://s3-us-west-2.amazonaws.com/osfsufiabox/hydra-sufia-0.6.box"
  config.vm.network   "forwarded_port", guest: 3000, host: 3000
  config.vm.network   "forwarded_port", guest: 8080, host: 8080
  config.vm.network   "forwarded_port", guest: 8081, host: 8081
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "3"]
  end

  config.vm.provision "shell",
      inline: 'echo "cd /vagrant" >> .bash_profile'
end

