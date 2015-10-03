# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.synced_folder ".", "/home/vagrant/flashcards"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
 
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y build-essential ruby-dev python-software-properties libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev git libpq-dev postgresql nodejs
    sudo apt-get update -y
    sudo apt-get clean

    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"'               >> ~/.bashrc
    source ~/.bashrc

    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    sudo -H -u vagrant bash -i -c 'rbenv install 2.2.3'
    sudo -H -u vagrant bash -i -c 'rbenv rehash'
    sudo -H -u vagrant bash -i -c 'rbenv global 2.2.3'
    sudo -H -u vagrant bash -i -c 'gem install bundler --no-ri --no-rdoc'
    sudo -H -u vagrant bash -i -c 'rbenv rehash'

    cd ~/flashcards
    sudo -H -u vagrant bash -i -c 'bundle install'
    # echo "CREATE ROLE vagrant WITH CREATEDB LOGIN PASSWORD 'vagrant';" | sudo -u postgres psql
    sudo -u postgres createuser --superuser vagrant
    sudo -u postgres createdb -O vagrant flashcards_development
    DATABASE_URL='postgresql://localhost/flashcards_development'
    cat config/database.yml
    sudo -H -u vagrant bash -i -c 'rake db:create'
    sudo -H -u vagrant bash -i -c 'rake db:migrate'
    sudo -H -u vagrant bash -i -c 'unicorn --listen 3000'
  SHELL
end