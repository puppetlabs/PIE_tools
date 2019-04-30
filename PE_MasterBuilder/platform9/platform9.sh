function launch_in_platform9
{
  # Validate the host setup for openstack 
  s=$(which openstack)
  is_ok $? "Ensure python-openstackclient is installed"

  s=$(openstack image list -f value)
  is_ok $? "openstack coms failed. Check you have sourced your config.env. Try : openstack image list"

  # Globals
  MASTER_NAME="$USER-PuppetEnterprise-Master"
  NETWORK_ID=$(openstack network list -f value | grep network1 | awk '{ print $1 }')
  IMAGE=centos_7_x86_64
  FLAVOUR=m1.medium

  # Validate the ENV setup 
  is_set "${NETWORK_ID}" "Failed to find the network ID. Please check openstack network list"
  is_set "${SSL_KEY}" "Failed to find the SSL_KEY. Ensure your SSL_KEY name is exported"
  is_set "${OS_PROJECT_NAME}" "Failed to find the OS_PROJECT_NAME. Ensure your OS_PROJECT_NAME name is exported"
  is_set "${OS_USERNAME}" "Failed to find the OS_USERNAME. Ensure your OS_USERNAME name is exported"
  is_set "${OS_PASSWORD}" "Failed to find the OS_PASSWORD. Ensure your OS_PASSWORD name is exported"
  is_set "${OS_AUTH_URL}" "Failed to find the OS_AUTH_URL. Ensure your OS_AUTH_URL name is exported"
  is_set "${OS_IDENTITY_API_VERSION}" "Failed to find the OS_IDENTITY_API_VERSION. Ensure your OS_IDENTITY_API_VERSION name is exported"
  is_set "${OS_REGION_NAME}" "Failed to find the OS_REGION_NAME. Ensure your OS_REGION_NAME name is exported"
  is_set "${OS_USER_DOMAIN_ID}" "Failed to find the OS_USER_DOMAIN_ID. Ensure your OS_USER_DOMAIN_ID name is exported"
  is_set "${OS_PROJECT_DOMAIN_ID}" "Failed to find the OS_PROJECT_DOMAIN_ID. Ensure your OS_PROJECT_DOMAIN_ID name is exported"

  log "Comms are set"
  log "Creating Platform9 Master node"

  openstack server create --flavor m1.medium --image "centos_7_x86_64" --key-name $SSL_KEY --security-group default --nic net-id=$NETWORK_ID $MASTER_NAME
  response=$(openstack server list -f value)
  node_id=$(echo $response | awk '{ print $1 }')
  node_name=$(echo $response | awk '{ print $2 }')
  sleep 2
  node_network_raw=$(openstack server list --name ${node_name} -c Networks -f value)
  while [[ -z "${node_network_raw}" ]]; do
    node_network_raw=$(openstack server list --name ${node_name} -c Networks -f value)
  done


  node_network=$(echo $node_network_raw | cut -d\= -f1)

  openstack server add fixed ip $node_id $node_network
  is_ok $? "Failed to create the fixed ip address on the $node_network"

  fixed_ip=$(openstack server list --instance-name $node_id -f value -c Networks | cut -d\, -f2 | xargs)
  is_ok $? "Failed to find the fixed ip for $node_name"

  port_id=$(openstack port list -f value | grep "$fixed_ip" | awk '{ print $1 }')
  is_ok $? "Failed to find the port list for $fixed_ip"

  raw_float_text=$(openstack floating ip create external --fixed-ip-address $fixed_ip --port $port_id) 
  id=$(echo $raw_float_text| cut -d\| -f 27 | xargs)
  is_ok $? "Failed to create the fixed ip address on the $node_network"

  # okay this sucks. capture the one you created and search for it.
  floating_ip=$(openstack floating ip list -f value | grep $id | awk '{ print $2 }' | xargs)
  is_ok $? "Failed to find the floating ip"
  
  openstack server add floating ip $node_id $floating_ip
  is_ok $? "Failed to add the floating ip to the server"

  log "Master Created [$node_name]"
  
  
  # Construct the SSH command
  SSH_COMMAND="ssh -o LogLevel=quiet -i ${PEM_FILE} root@${fqdn}"
  SCP_COMMAND="scp -i ${PEM_FILE} "

  # Set the lifetime in the pooler until max
  ft=$(floaty modify ${hostname} --lifetime 24)
  is_ok $? "Failed to set the pooler lifetime for [${hostname}]"

  log "The Master ${hostname} is ready for install"

  # Attempt SSH comms
  node_arch=$(${SSH_COMMAND} uname)
  is_ok $? "Failed to ssh to ${fqdn}. Check your PEM file at [${PEM_FILE}]"

  # Ensure SSH response works
  test "$node_arch" == "Linux"
  is_ok $? "SSH comms failed to [$fqdn]. Unable to uname "

  log "Ready to install PE to the Master node"

  ${SCP_COMMAND} ./install_pe.sh root@${fqdn}:/root/install_pe.sh
  ${SSH_COMMAND} /root/install_pe.sh
  is_ok $? "Failed to install Puppet Enterprise on [$hostname]. Check the logs above"

  log "Complete: Puppet Enterprise is installed and configured on [${hostname}]"
}