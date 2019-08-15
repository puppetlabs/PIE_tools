#!/bin/bash

PT_hec_token_name=$PT_hec_token_name
PT_sudo=$PT_sudo

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
wget_installed=$(which wget)
if [ -z "${wget_installed}" ];then
    $PT_sudo yum install -y wget
fi

wget -O splunk.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.3.0&product=splunk&filename=splunk-7.3.0-657388c7a488-linux-2.6-x86_64.rpm&wget=true'
is_ok $? "Failed to download the splunk enterprise rpm"

$PT_sudo rpm -ivh splunk.rpm
is_ok $? "Failed to install the splunk rpm"

echo -e "[user_info]\n  USERNAME = admin\n  PASSWORD = simples1\n" > user-seed.conf
is_ok $? "Failed to set the admin credentials in the user-seed.conf"

$PT_sudo mv user-seed.conf /opt/splunk/etc/system/local/.
is_ok $? "Failed to move user-seed.conf to /opt/splunk/etc/system/local/"

$PT_sudo yum install -y ruby




