#!/bin/bash

# $PT_tar_file

function is_ok
{
    ret=$1
    error=$2

    if [[ ${ret} -ne 0 ]];then
        echo -e "[${error}] failed with code [$ret]"
        exit 2
    fi
}

if [ ! -f "${PT_tar_file}" ];then
    echo -n "Failed to find the tar file [${PT_tar_file}]. Check the upload."
    exit 2
fi

tar xvf ${PT_tar_file}
is_ok $? “Error: Failed to untar [${PT_tar_file}]”

PE_FILE_NAME=$(echo $PT_tar_file | cut -d\. -f1-3)

cd ${PE_FILE_NAME}
consol_admin_password_omit=$(grep '#"console_admin_password' conf.d/pe.conf)
if [ -z "${consol_admin_password_omit}" ];then
    sed -i 's/"console_admin_password/#"console_admin_password/' conf.d/pe.conf
fi
sudo ./puppet-enterprise-installer -c conf.d/pe.conf
is_ok $? “Error: Failed to install Puppet Enterprise. Please check the logs and call Bryan.x ”

## Finalize configuration
echo “Finalize PE install”
sudo puppet agent -t

## Create and configure Certs
sudo chmod 777 /etc/puppetlabs/puppet/puppet.conf
echo "autosign = true" >> /etc/puppetlabs/puppet/puppet.conf
sudo chmod 755 /etc/puppetlabs/puppet/puppet.conf

sudo yum install -y ruby

echo "I'd restart the master now to be safe!"
