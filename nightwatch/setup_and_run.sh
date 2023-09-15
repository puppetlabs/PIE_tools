#!/bin/bash

SNOW_USERNAME=$1
SNOW_PASS=$2

if [ $# -ne 2 ]; then
  echo "Usage: $0 <snow_username> <snow_password>"
  exit 1
fi

if [ -z "$SNOW_USERNAME" ] || [ -z "$SNOW_PASS" ]; then
  echo "Usage: $0 <snow_username> <snow_password>"
  exit 1
fi

worked(){
  result=$1
  if [ ${result} -ne 0 ]; then
    echo "$2"
    exit 1
  fi
}

# This script is meant to be run on a fresh Ubuntu 20.04 install.

# Set up the environment
NIGHTWATCH_HOME=~/PIE_tools/nightwatch

# Install git
apt-get update
git clone https://github.com/puppetlabs/PIE_tools.git
worked $? "Failed to clone PIE_tools repo"

# Install nodejs
apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
worked $? "Failed to install nvm"

source ~/.bashrc
worked $? "Failed to source bashrc"

# Install chrome from a google apt repo

wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub
worked $? "Failed to download google signing key"

gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub
worked $? "Failed to import google signing key"

echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
worked $? "Failed to add google apt repo"

apt-get update
worked $? "Failed to update apt"

apt-get install google-chrome-stable
worked $? "Failed to install google-chrome-stable"

# Install vault
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
worked $? "Failed to download hashicorp signing key"

gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
worked $? "Failed to import hashicorp signing key"

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
worked $? "Failed to add hashicorp apt repo"

apt update
worked $? "Failed to update apt"

apt install vault
worked $? "Failed to install vault"

# Check this step below, it might not be needed.
apt --fix-broken install
worked $? "Failed to fix broken apt packages"

# Install nodejs
nvm install 18
worked $? "Failed to install nodejs"

# Install nightwatch
cd ${NIGHTWATCH_HOME}
npm install package.json
worked $? "Failed to install nightwatch"

# Run tests
npx nightwatch --config nightwatch.conf.js tests/snow_run_command.js
worked $? "Failed to run nightwatch tests"
