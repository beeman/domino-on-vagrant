# -*- mode: ruby -*-
# vi: set ft=ruby :

gui      = true

box      = 'centos-6-amd64'
url      = 'https://dl.dropboxusercontent.com/s/uky9fimq2eal2l4/centos-6-amd64.box'
hostname = 'dov'
domain   = 'domino.dev'
ip       = '10.2.2.2'
ram      = '2048'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box
  config.vm.box_url = url
  config.vm.host_name = hostname + '.' + domain

  config.vm.network :private_network, ip: ip

  config.vm.synced_folder "./data/", "/data/"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", ram, "--name", hostname, "--natdnshostresolver1", "on"]

  	# VirtualBox console
    vb.gui = gui
  end

  config.vm.provision "shell", path: "scripts/provision.sh"


end
