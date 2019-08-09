plan splunk::deprovision_aws(
) {
  info('running splunk::delete_aws')

  $output_user = run_task('splunk::facts', 'localhost', fact_name => 'id')
  $user = $output_user.first.value['_output']
  info("User is ${user}")

  $basename           = "${user}-splunk"

  $output_vpc = run_task('splunk::delete_aws', 'localhost', tag_name => $basename)
  $vpc_id = $output_vpc.first.value['_output']
  info("vpc_id is ${vpc_id}")

  info('splunk::delete_aws complete')
}
