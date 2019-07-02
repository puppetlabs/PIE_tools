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

## Create an endpoint and generate a HEC token
output=$(/opt/splunk/bin/splunk http-event-collector create ${PT_hec_token_name} "${PT_hec_token_name}" -index default -uri "https://localhost:8089" -auth admin:simples1 2>&1)
is_ok $? "Failed to create the Http Event Controller [$PT_hec_token_name] $output"

splunk_token=$(echo ${output} | grep token= | cut -d\= -f2)
if [[ -z "${splunk_token}" ]];then
    echo -e "Could not find the generted splunk token. Check the logs above"
    exit 2
fi

## Report the splunk token to the user
echo -e $splunk_token
