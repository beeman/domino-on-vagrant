# -*- mode: ruby -*-
# vi: set ft=ruby :

box      = 'centos-6-amd64'
url      = 'https://dl.dropboxusercontent.com/s/uky9fimq2eal2l4/centos-6-amd64.box'
hostname = 'vagrant'
domain   = 'domino.dev'
ip       = '10.2.2.2'
ram      = '1024'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = box
  config.vm.box_url = url
  config.vm.host_name = hostname + '.' + domain

  config.vm.network :private_network, ip: ip

  config.vm.synced_folder "./data/", "/data/"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", ram, "--name", hostname, "--natdnshostresolver1", "on"]
  end

  config.vm.provision "shell", path: "provision.sh"

end
