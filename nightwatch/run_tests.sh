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
SNOW_USERNAME=$(vault kv get -format=json -mount=secret username)
worked $? "Failed to get username from vault"
SNOW_PASSWORD=$(vault kv get -field=password -mount=secret password)
worked $? "Failed to get password from vault"

if [ -z "${SNOW_USERNAME}" || -z "${SNOW_PASSWORD}" ]; then
  echo "Failed to get username or password from vault"
  exit 1
fi

# Set up the environment
NIGHTWATCH_HOME=~/PIE_tools/nightwatch

# Get the latest code from PIE_tools
cd ~/PIE_tools
git pull
worked $? "Failed to pull latest code from PIE_tools"

# Install nightwatch
cd ${NIGHTWATCH_HOME}
npm install package.json
worked $? "Failed to install nightwatch"

SNOW_USERNAME=${SNOW_USERNAME} SNOW_PASSWORD=${SNOW_PASSWORD} \
  npx nightwatch --config nightwatch.conf.js tests/snow_run_command.js
worked $? "Failed to run nightwatch tests"
