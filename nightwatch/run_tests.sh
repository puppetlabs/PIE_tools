#!/bin/bash
TO_EMAIL_ADDRESS="w5q9n8m2j0m2p1f8@perforce.slack.com"

worked(){
  result=$1
  if [ ${result} -ne 0 ]; then
    echo "$2"
    notify_slack "Nightwatch Nightly Builds Status - Failed" "$2"
    exit 1
  fi
}

notify_slack(){
  subject_line=$1
  message=$2
  echo "${message}" | mutt -s "${subject_line}" -- ${TO_EMAIL_ADDRESS}
  worked $? "Failed to send email to ${TO_EMAIL_ADDRESS}"
}


# This script is meant to be run on a fresh Ubuntu 20.04 install.
SNOW_USERNAME=$(vault kv get -field=username -mount=secret username)
worked $? "Failed to get username from vault"

SNOW_PASS=$(vault kv get -field=password -mount=secret password)
worked $? "Failed to get password from vault"

if [ "${SNOW_USERNAME}" == "" ] || [ "${SNOW_PASS}" == "" ]; then
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

SNOW_USERNAME=${SNOW_USERNAME} SNOW_PASS=${SNOW_PASS} \
  npx nightwatch --config nightwatch.conf.js tests/snow_run_command.js
worked $? "Failed to run nightwatch tests"

notify_slack "Nightwatch Nightly Builds Status - Succeeded" "All tests passed"
