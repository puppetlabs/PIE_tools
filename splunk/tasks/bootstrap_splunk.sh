#!/bin/bash

PT_hec_token_name=$PT_hec_token_name

function is_ok
{
    ret=$1
    error=$2

    if [[ ${ret} -ne 0 ]];then
        echo -e "[${error}] failed with code [$ret]"
        exit 2
    fi
}
## Download and install
wget -O splunk.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.3.0&product=splunk&filename=splunk-7.3.0-657388c7a488-linux-2.6-x86_64.rpm&wget=true'
is_ok $? "Failed to download the splunk enterprise rpm"

rpm -ivh splunk.rpm
is_ok $? "Failed to install the splunk rpm"

echo -e "[user_info]\n  USERNAME = admin\n  PASSWORD = simples1\n" > /opt/splunk/etc/system/local/user-seed.conf
is_ok $? "Failed to set the admin credentials in the user-seed.conf"



