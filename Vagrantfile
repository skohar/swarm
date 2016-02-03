# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.8.1"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # Ubuntu 14.04 LTS box from
  # https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
  box = "ubuntu1404"
  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--memory", "2048"]
  end
  (10..10).each do |addr|
    name = "cc-sandbox-" + addr.to_s
    config.vm.define name do |server|
      server.vm.box = box
      server.vm.hostname = name
      server.vm.network "private_network", type: "dhcp"
    end
  end
end
