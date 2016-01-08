# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-omnibus")
    web.omnibus.chef_version = 'latest'
  end

  config.vm.define "web" do |web|
    web.vm.provision "shell", inline: "echo ==== INSTALL WEB VM ===="
    web.vm.hostname = "webapp"
    web.berkshelf.enabled = true
    web.vm.box = "ubuntu/trusty64"
    web.vm.network :private_network, ip: "192.168.50.101"
    # web.vm.network "forwarded_port", guest: 3000, host: 3000, auto_correct: true
    # web.vm.network "forwarded_port", guest: 5435, host: 5432, auto_correct: true
    web.vm.network "forwarded_port", guest: 3000, host: 3000
    web.vm.network "forwarded_port", guest: 5432, host: 5432
    web.vm.synced_folder ".", "/home/vagrant/flashcards"
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
    web.vm.provision :chef_solo do |chef|
      chef.json = {
        ruby_version: "2.2.3",
        gems: {
          webapp: [
            "bundler",
            "rbenv-rehash",
            "foreman"
          ]
        },
        postgresql: {
          version: '9.4',
          password: {
            postgres: "testpass"
          },
          config: {
            port: 5432
          }
        },
        redisio: {
          version: "3.0.6",
          safe_install: false
        }
        # java: {
        #   jdk_version: 8
        # }
      }
      chef.run_list = [
        'recipe[flashcards-cookbook::default]'
      ]
    end
  end

  # config.vm.define "elastic" do |elastic|
  #   elastic.vm.provision "shell", inline: "echo ==== INSTALL ELASTIC VM ===="
  #   elastic.vm.box = "ubuntu/trusty64"
  #   elastic.vm.provider "virtualbox" do |vb|
  #     vb.memory = "1024"
  #   end
  # end

  # config.vm.define "kibana" do |kibana|
  #   kibana.vm.provision "shell", inline: "echo ==== INSTALL KIBANA VM ===="
  #   kibana.vm.box = "ubuntu/trusty64"
  #   kibana.vm.provider "virtualbox" do |vb|
  #     vb.memory = "1024"
  #   end
  # end
end
