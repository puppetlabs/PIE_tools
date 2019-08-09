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

"GH: >>>>> ${PT_tar_file}"
ls
# tar xvf ${PT_tar_file}
is_ok $? “Error: Failed to untar [${PT_tar_file}]”

PE_FILE_NAME=$(echo $PT_tar_file | cut -d\. -f1-3)

echo "GH: Pe file is [$PE_FILE_NAME] [${PT_tar_file}]"

cd ${PE_FILE_NAME}
sudo ./puppet-enterprise-installer -c conf.d/pe.conf
is_ok $? “Error: Failed to install Puppet Enterprise. Please check the logs and call Bryan.x ”

## Finalize configuration
echo “Finalize PE install”
sudo puppet agent -t
# if [[ $? -ne 0 ]];then
#  echo “Error: Agent run failed. Check the logs above...”
#  exit 2
# fi

## Create and configure Certs
sudo chmod 777 /etc/puppetlabs/puppet/puppet.conf
echo "autosign = true" >> /etc/puppetlabs/puppet/puppet.conf
sudo chmod 755 /etc/puppetlabs/puppet/puppet.conf

echo "I'd restart the master now to be safe!"
