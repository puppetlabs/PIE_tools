#!/bin/bash

SPLUNK_HEC_CONFIG="---\n  \"url\" : \"https://$PT_server:8088/services/collector\"\n  \"token\" : \"$PT_splunk_hec_token\""

echo -e $SPLUNK_HEC_CONFIG > /etc/puppetlabs/puppet/splunk_hec.yaml

if [ $? -ne 0 ];then
    echo "Failed to add the splunk HEC token to the splunk hec config yaml"
    exit 2
fi

