#!/bin/bash

# PT_key_file
# PT_user_host
# PT_dest_module_path

ssh -i ${PT_key_file} ${PT_user_host} 'mkdir -p ~/modules'

scp -q -r -i ${PT_key_file} ${HOME}/.puppetlabs/bolt/modules/ $PT_user_host:~/modules

ssh -i ${PT_key_file} ${PT_user_host} "sudo cp -r /home/centos/modules/modules/* ${PT_dest_module_path}"

echo "Complete"
