#!/bin/bash

PT_hec_token_name=$PT_hec_token_name

function is_ok
{
    ret=$1
    error=$2

    if [[ ${ret} -ne 0 ]];then
        echo -e "${error}"
        exit 2
    fi
}

## Enable the collectors. Dont forget the default collector, or you aint getting nothing collected...
output=$(/opt/splunk/bin/splunk http-event-collector enable $PT_hec_token_name  -uri 'https://localhost:8089' -auth admin:simples1 2>&1)
is_ok $? "Failed to enable the Http Event Controller [$PT_hec_token_name] $output"


output=$(/opt/splunk/bin/splunk http-event-collector enable http -uri 'https://localhost:8089' -auth admin:simples1 2>&1)
is_ok $? "Failed to enable the base Http Event Controller [default] $output"
