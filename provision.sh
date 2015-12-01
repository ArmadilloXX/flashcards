#!/bin/bash

echo 'Installing packages dependencies'
sudo apt-get -y update
sudo apt-get install -y build-essential ruby-dev git zlib1g zlib1g-dev \
                        libyaml-dev libreadline6 libreadline6-dev \
                        libpq-dev postgresql nodejs g++ flex bison \
                        gperf ruby perl libsqlite3-dev libfontconfig1-dev \
                        libicu-dev libfreetype6 libssl-dev libpng-dev \
                        libjpeg-dev python libx11-dev libxext-dev tcl8.5
sudo apt-get clean

if ! [ -d ~/.rbenv ]; then
  echo 'Installing rbenv'
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"'               >> ~/.bashrc
  source ~/.bashrc
fi

if ! [ -d ~/.rbenv/plugins/ruby-build ]; then
  echo 'Installing ruby-build'
  git clone https://github.com/sstephenson/ruby-build.git \
    ~/.rbenv/plugins/ruby-build
fi

if ! [ -d ~/.rbenv/plugins/rbenv-gem-rehash ]; then
  echo 'Installing rbenv-gem-rehash'
  git clone https://github.com/sstephenson/rbenv-gem-rehash.git \
    ~/.rbenv/plugins/rbenv-gem-rehash
fi

echo 'Setting PATH for rbenv shims'
export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
export PATH="${RBENV_ROOT}/shims:${PATH}"

if ! [ -d ~/.rbenv/versions/2.2.3 ]; then
  echo 'Installing Ruby 2.2.3'
  rbenv install 2.2.3
  rbenv global 2.2.3
fi

if ! [ -d ~/redis-3.0.5 ]; then
  echo 'Installing Redis'
  cd ~
  wget http://download.redis.io/releases/redis-3.0.5.tar.gz
  sudo tar xzf redis-3.0.5.tar.gz
  cd redis-3.0.5
  sudo make
  sudo make install
  cd utils
  sudo ./install_server.sh -y
fi

echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

echo 'Installing Bundler'
gem install bundler

echo 'Installing Foreman'
gem install foreman

echo 'Installing application'
cd ~/flashcards
bundle install

echo 'Preparing database connection'
cd ~/flashcards
sudo -u postgres createuser --superuser vagrant
cp -R config/sample_db.yml config/database.yml

echo 'Creating and migrating database'
rake db:create
rake db:migrate

echo 'Seeding the database'
rake db:seed

echo 'Starting application server'
export PORT=3000
foreman start