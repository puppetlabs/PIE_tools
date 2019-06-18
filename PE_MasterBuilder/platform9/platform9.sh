


function validate_env
{
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
  is_set "${MASTER_LOGIN_USER}" "Failed to find the MASTER_LOGIN_USER. Ensure the user is set based on the OS type. root/centos/Administrator etc..."
  log "Comms are set"
}

function attach_fixed_ip
{
  n_id=$1
  n_network=$2

  openstack server add fixed ip $n_id $n_network
  ret=$?
  counter=0
  while [ $ret -ne 0 ] && [ $counter -lt 5 ]; do
    openstack server add fixed ip $n_id $n_network
    ret=$?
    let counter=counter+1
    sleep 2
  done
  is_ok $ret "Failed to create the fixed ip address on the $n_network"
}

function verify_ssh_comms
{
  node_id=$1
  floating_ip=$2

  SSH_COMMAND="ssh -t -o StrictHostKeyChecking=no -o LogLevel=quiet -i ${PEM_FILE} ${MASTER_LOGIN_USER}"

  # Attempt to communicate via SSH with the new server
  arch=$(${SSH_COMMAND}@${floating_ip} uname)
  ret=$?
  counter=0
  while [ $ret -ne 0 ] && [ $counter -lt 5 ]; do
    $(${SSH_COMMAND}@${floating_ip} uname)
    ret=$?
    let counter=counter+1
    # It appears that openstack can report a successful attach, even though it was unsuccessful.
    openstack server add floating ip $node_id $floating_ip
    sleep 5
  done
  is_ok $ret "Failed to ssh to ${floating_ip}. Check your PEM file at [${PEM_FILE}]"
}

function install_pe_on_master
{
  floating_ip=$1

  SSH_COMMAND="ssh -t -o StrictHostKeyChecking=no -o LogLevel=quiet -i ${PEM_FILE} ${MASTER_LOGIN_USER}"
  SCP_COMMAND="scp -o StrictHostKeyChecking=no -i ${PEM_FILE} "
  
  log "Ready to install PE to the Master node"

  ${SCP_COMMAND} ./PE/install_pe.sh ${MASTER_LOGIN_USER}@${floating_ip}:/tmp/install_pe.sh
  ${SSH_COMMAND}@${floating_ip} sudo /tmp/install_pe.sh
  is_ok $? "Failed to install Puppet Enterprise on [$floating_ip]. Check the logs above"

  log "Complete: Puppet Enterprise is installed and configured on [${floating_ip}]"
}

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

  validate_env

  log "Creating Platform9 Master node"
  output=$(openstack server create --flavor m1.medium --image "centos_7_x86_64" --wait --key-name $SSL_KEY --security-group default -f value --nic net-id=$NETWORK_ID $MASTER_NAME)
  node_id=$(echo $output | awk '{ print $15 }')
  node_name=$(echo $output | awk '{ print $19 }')

  # There is a param --instance_name which is supposed to filter the returned
  # hosts, but guess what. It doesnt work.
  node_status=$(openstack server list -f value | grep $node_id | awk '{ print $3 }')
  while [[ "${node_status}" != "ACTIVE" ]];do
    sleep 2
    node_status=$(openstack server list  -f value | grep $node_id | awk '{ print $3 }')
  done

  node_network_raw=$(openstack server list -f value | grep ${node_name} | awk '{ print $4" "$5 }')
  while [[ -z "${node_network_raw}" ]]; do
    node_network_raw=$(openstack server list -f value | grep ${node_name} | awk '{ print $4" "$5 }')
  done

  node_network=$(echo $node_network_raw | cut -d\= -f1)

  attach_fixed_ip "${node_name}" "${node_network}"

  fixed_ip=$(openstack server list -f value | grep  $node_name | awk '{ print $4" "$5 }' | cut -d\, -f2 | xargs)
  is_ok $? "Failed to find the fixed ip for $node_name"

  port_id=$(openstack port list -f value | grep "$fixed_ip" | awk '{ print $1 }')
  is_ok $? "Failed to find the port list for $fixed_ip"

  sleep 10

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
  log "The Master ${floating_ip} is ready for install"

  # We are doing a lame sleep because it appears that the server sshd has not correctly and falls
  # back to password, even if you present a valid private key.
  sleep 15
  verify_ssh_comms $node_id $floating_ip
  install_pe_on_master $floating_ip   
}
