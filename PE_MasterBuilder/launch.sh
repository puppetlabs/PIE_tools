#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")  # get the directory name

source $DIR/utils/shared_functions.sh
source $DIR/vmpooler/vmpooler.sh
source $DIR/platform9/platform9.sh
source $DIR/config.env

if [[ -z "$PLATFORM" ]]; then
    error "PLATFORM must be set in the config.env"
fi

log "Launching your node in [$PLATFORM]"

if [[ "${PLATFORM}" == "vmpooler" ]];then
    launch_in_vmpooler $DIR
elif [[ "${PLATFORM}" == "platform9" ]]; then
    launch_in_platform9 $DIR
else
    error "Unsupported platform [$PLATFORM]"
fi




