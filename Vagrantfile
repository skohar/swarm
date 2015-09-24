# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # Ubuntu 14.04 LTS box from
  # https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
  box = "ubuntu1404"
  (10..10).each do |addr|
    name = "cc-sandbox-" + addr.to_s
    config.vm.define name do |server|
      server.vm.box = box
      server.vm.hostname = name
      server.vm.network "private_network", ip: "192.168.66." + addr.to_s
    end
  end
end
