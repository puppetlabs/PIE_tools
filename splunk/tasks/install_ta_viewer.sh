#!/bin/bash

function is_ok
{
    ret=$1
    error=$2

    if [[ ${ret} -ne 0 ]];then
        echo -e "${error}"
        exit 2
    fi
}

## Install TA report viewer
wget -O /tmp/$PT_version.tar.gz https://github.com/puppetlabs/TA-puppet-report-viewer/archive/$PT_version.tar.gz
is_ok $? "Failed download the TA-puppet-report-viewer"
gunzip -c /tmp/$PT_version.tar.gz | tar -C /opt/splunk/etc/apps/ -xf -
is_ok $? "Failed to install the TA-puppet-report-viewer"
