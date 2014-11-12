# -*- mode: ruby -*-
# vi: set ft=ruby :

repo_dir = File.expand_path(File.dirname __FILE__)

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.omnibus.chef_version = :latest
  config.cache.auto_detect = true

  config.ssh.forward_agent = true
  config.vm.network :private_network, type: 'dhcp'
  config.vm.network "forwarded_port", guest: 3000, host: 3030
  config.vm.synced_folder '.', '/home/vagrant/code', nfs: true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    host = RbConfig::CONFIG['host_os']

    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 2
      mem = 1024
    end

    vb.customize ["modifyvm", :id, "--memory", mem]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
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
