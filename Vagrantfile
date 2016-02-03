# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.8.1"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # Ubuntu 14.04 LTS box from
  # https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
  box = "ubuntu1404"
  config.vm.provider "virtualbox" do |vm|
    vm.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # Disable the new default behavior introduced in Vagrant 1.7, to
  # ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/mitchellh/vagrant/issues/5005
  config.ssh.insert_key = false
  (10..10).each do |addr|
    name = "whale." + "#{`hostname`}".split(".").first.chomp + ".local"
    config.vm.define name do |server|
      server.vm.box = box
      server.vm.hostname = name
      server.vm.network "private_network", type: "dhcp"
    end
  end
  config.vm.provision "shell" do |s|
    s.inline = "apt-get install -y avahi-daemon sysstat zsh tree"
    s.privileged = true
  end
  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
   # ansible.raw_arguments = ["--extra-vars=@env.json"]
    ansible.playbook = "playbook.yml"
  end
  config.vm.provision "shell" do |s|
    s.inline = "DD_API_KEY=d94f2c2de6f98f1dd9cb057ee6614179 bash -c \"$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)\""
    s.privileged = true
  end
  config.vm.provision "shell" do |s|
    s.inline = "ausermod -a -G docker dd-agent"
    s.privileged = true
  end
  config.vm.provision "shell" do |s|
    s.inline = "docker run -d --restart=always --name dd-agent -h `hostname` -v /var/run/docker.sock:/var/run/docker.sock -v /proc/:/host/proc/:ro -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro -e API_KEY=d94f2c2de6f98f1dd9cb057ee6614179 datadog/docker-dd-agent:latest"
    s.privileged = true
  end
end
