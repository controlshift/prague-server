# -*- mode: ruby -*-
# vi: set ft=ruby :

repo_dir = File.expand_path(File.dirname __FILE__)

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.omnibus.chef_version = :latest
  config.cache.auto_detect = true

  config.vm.network :private_network, type: 'dhcp'
  config.vm.network "forwarded_port", guest: 3000, host: 3030
  config.vm.synced_folder '.', '/home/vagrant/code', nfs: true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision "chef_solo" do |chef|
    unless ENV["DEBUG_ENABLED"].nil?
      chef.log_level = :debug
    end

    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]
    chef.add_recipe "prague"
    chef.json = {}
  end
end
