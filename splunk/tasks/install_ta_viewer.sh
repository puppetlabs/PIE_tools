#!/bin/bash

# PT_version
# PT_sudo

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
wget -O $PT_version.tar.gz https://github.com/puppetlabs/TA-puppet-report-viewer/archive/$PT_version.tar.gz
is_ok $? "Failed download the TA-puppet-report-viewer"

gunzip -c $PT_version.tar.gz
is_ok $? "Unable to unzip the tar"

tar xvf $PT_version.tar
is_ok $? "Unable to unpack the tar file [$PT_version.tar]"

$PT_sudo mv TA-puppet-report-viewer-${PT_version} /opt/splunk/etc/apps/
is_ok $? "Failed to install the TA-puppet-report-viewer"
