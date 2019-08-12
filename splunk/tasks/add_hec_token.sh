#!/bin/bash

# PT_spunk_hec_token
# PT_server
# PT_sudo

SPLUNK_HEC_CONFIG="---\n  \"url\" : \"https://$PT_server:8088/services/collector\"\n  \"token\" : \"$PT_splunk_hec_token\""

echo -e $SPLUNK_HEC_CONFIG > splunk_hec.yaml
if [ $? -ne 0 ];then
    echo "Failed to add the splunk HEC token to the splunk hec config yaml"
    exit 2
fi

$PT_sudo mv splunk_hec.yaml /etc/puppetlabs/puppet/.
if [ $? -ne 0 ];then
    echo "Failed to copy HEC token to the splunk hec config yaml location"
    exit 2
fi

