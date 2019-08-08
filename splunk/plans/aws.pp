plan splunk::aws(
) {
  info('running splunk::aws')

  # $user               = $facts['id']
  $user               = 'gregohardy'
  $basename           = "${user}-splunk"

  $inv = '~/.puppetlabs/bolt/'
  $sec_group = "${basename}-sg"

  $output_vpc = run_task('splunk::create_vpc', 'localhost', tag_name => $basename)
  $vpc_id = $output_vpc.first.value['_output']
  info("vpc_id is ${vpc_id}")

  $output_sg = run_task('splunk::create_security_group', 'localhost', group_name => $sec_group, vpc_id => $vpc_id)
  $sg_id = $output_sg.first.value['_output']
  info("sg_id is ${sg_id}")

  $output_sub = run_task('splunk::create_subnet', 'localhost', tag_name => $basename, vpc_id => $vpc_id)
  $subnet_id = $output_sub.first.value['_output']
  info("subnet_id is ${subnet_id}")

  $output_ig = run_task('splunk::create_internet_gateway', 'localhost', tag_name => $basename, vpc_id => $vpc_id)
  $ig_id = $output_ig.first.value['_output']
  info("ig_id is ${ig_id}")

  $output = run_task('splunk::create_instance', 'localhost', instance_name => $basename, subnet_id => $subnet_id, sg_id => $sg_id)
  $pe_master = $output.first.value['_output']
  info("instance id is ${pe_master}")

  $output_table = run_task('splunk::create_route', 'localhost', tag_name => $basename, vpc_id => $vpc_id, subnet_id => $subnet_id, ig_id => $ig_id)
  $table_id = $output_sub.first.value['_output']
  info("table_id is ${table_id}")

  info("Run inventory with ${inv} ${pe_master}")
  run_task('splunk::update_aws_inventory', 'localhost', action => 'provision', platform => 'aws', inventory => $inv, node_name => $pe_master)
  # run_task('splunk::update_aws_inventory', 'localhost', action => 'provision', inventory => $inv, node_name => $agent01_name)
  # run_task('splunk::update_aws_inventory', 'localhost', action => 'provision', inventory => $inv, node_name => $splunk_server_name)

  info('splunk::aws complete')
}
