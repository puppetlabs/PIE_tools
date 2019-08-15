plan splunk::verify_aws(
  String[1] $splunk_server,
  String[2] $search_host
) {
  info('running splunk::verify')

  $output_user = run_task('splunk::facts', 'localhost', fact_name => 'id')
  $user = $output_user.first.value['_output']
  $basename = "${user}-splunk"

  $output_meta = run_task('splunk::get_instance_meta', 'localhost', tag_name => $basename, public_dns_name => $search_host, param => 'private_dns_name')
  $priv_dns_name = $output_meta.first.value['_output']

  info("GH: priv host is ${priv_dns_name}")

  $output = run_task('splunk::search', $splunk_server, host => $priv_dns_name, sudo => 'sudo')
  $records = $output.first.value['_output']

  info($records)
  info('')
  info('splunk::verify completed')
}
