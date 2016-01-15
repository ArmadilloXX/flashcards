# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
VM_BOX = "bento/centos-7.1"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "web" do |web|
    WEBAPP_DIR = "/home/vagrant/flashcards"
    if Vagrant.has_plugin?("vagrant-omnibus")
      web.omnibus.chef_version = "latest"
    end
    web.vm.provision "shell", inline: "echo ==== INSTALL WEB VM ===="
    web.vm.hostname = "webapp"
    web.berkshelf.enabled = true
    web.vm.box = VM_BOX
    web.vm.network :private_network, ip: "192.168.50.101"
    web.vm.network :forwarded_port, guest: 3000, host: 3000
    web.vm.network :forwarded_port, guest: 5432, host: 5432
    web.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"
    web.vm.synced_folder ".", WEBAPP_DIR
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    web.vm.provision :chef_solo do |chef|
      chef.json = {
        webapp: {
          username: "vagrant",
          directory: WEBAPP_DIR
        },
        rbenv: {
          user: 'vagrant'
        },
      }
      chef.run_list = [
        "recipe[flashcards-cookbook::default]"
      ]
    end
  end

  config.vm.define "elastic" do |elastic|
    elastic.vm.provision "shell", inline: "echo ==== INSTALL ELASTIC VM ===="
    elastic.vm.box = VM_BOX
    elastic.vm.network :private_network, ip: "192.168.50.102"
    elastic.berkshelf.enabled = true
    elastic.vm.network "forwarded_port", guest: 9200, host: 9200
    elastic.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
    elastic.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    elastic.vm.provision :chef_solo do |chef|
      chef.json = {
        java: {
          jdk_version: 8
        }
      }
      chef.run_list = [
        "recipe[flashcards-cookbook::elastic]"
      ]
    end
  end

  config.vm.define "kibana" do |kibana|
    kibana.vm.provision "shell", inline: "echo ==== INSTALL KIBANA VM ===="
    kibana.vm.box = VM_BOX
    kibana.vm.network :private_network, ip: "192.168.50.103"
    kibana.berkshelf.enabled = true
    kibana.vm.network "forwarded_port", guest: 5601, host: 5601
    kibana.vm.network :forwarded_port, guest: 22, host: 10322, id: "ssh"
    kibana.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    kibana.vm.provision :chef_solo do |chef|
      chef.json = {
        kibana: {
          download_url: 'https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz',
          checksum: '67d586e43a35652adeb6780eaa785d3d785ce60cc74fbf3b6a9a53b753c8f985',
          version: '4.2.0',
          service: {
            source: 'upstart.conf.erb'
          },
          config: {
            base_dir: '/opt/kibana',
            elasticsearch_url: 'http://192.168.50.102:9200'
          }
        }
      }
      chef.run_list = [
        "recipe[flashcards-cookbook::kibana]"
        # "recipe[flashcards-cookbook::kibana_service]"
      ]
    end
  end
end
