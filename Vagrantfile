# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.provision "shell", inline: "echo Hello"

  config.vm.define "web" do |web|
    web.vm.provision "shell", inline: "echo ==== INSTALL WEB VM ===="
    web.vm.box = "ubuntu/trusty64"
    web.vm.network "forwarded_port", guest: 3000, host: 3000
    web.vm.synced_folder ".", "/home/vagrant/flashcards"
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
  end

  config.vm.define "elastic" do |elastic|
    elastic.vm.provision "shell", inline: "echo ==== INSTALL ELASTIC VM ===="
    elastic.vm.box = "ubuntu/trusty64"
    elastic.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
  end

  config.vm.define "kibana" do |kibana|
    kibana.vm.provision "shell", inline: "echo ==== INSTALL KIBANA VM ===="
    kibana.vm.box = "ubuntu/trusty64"
    kibana.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
  end

  # config.vm.box = "ubuntu/trusty64"
  # config.vm.network "forwarded_port", guest: 3000, host: 3000
  # config.vm.synced_folder ".", "/home/vagrant/flashcards"

  # config.vm.provider "virtualbox" do |vb|
  #   vb.memory = "2048"
  # end
 
  # config.vm.provision "shell", privileged: false, path: 'provision.sh'
end