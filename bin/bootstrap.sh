#!/usr/bin/env bash

set -e


function ensure_gems() {
  echo "    bootstrap: ensuring gem dependencies are up to date"
  bundle check || bundle install
}

function ensure_cookbooks() {
  echo "    bootstrap: ensuring cookbook dependencies are up to date"
  if [[ -d cookbooks ]]; then
    rm -rf cookbooks
  fi
  gem install berkshelf
  berks vendor ./cookbooks
}


function ensure_vagrant() {
  echo "    bootstrap: ensuring vagrant is installed"
  if [[ -n `hash vagrant >/dev/null` ]]; then
    echo "    bootstrap: please install Vagrant"
    exit -1
  fi
  echo "    install vagrant plugins"
  vagrant plugin install vagrant-omnibus
  vagrant plugin install vagrant-cachier

  echo "    bootstrap: vagrant is installed"
}

function ensure_geoip() {
  ./bin/load_geoip.sh
}

function copy_configs() {
  cp .env.sample .env
  cp config/database.yml.example config/database.yml
  cp config/pusher.yml.example config/pusher.yml
}

function main() {
  ensure_cookbooks
  ensure_gems
  ensure_vagrant
  ensure_geoip
  copy_configs
}

main
