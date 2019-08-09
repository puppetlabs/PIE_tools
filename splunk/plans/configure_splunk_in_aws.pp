plan splunk::configure_splunk_in_aws(
  String[1] $splunk_server,
  String[1] $pe_master,
  String[2] $splunk_token_name
) {
  info('running splunk::configure_splunk_in_aws')

  $output = run_task('splunk::get_pe', 'localhost', key_file_path => '/Users/greghardy/.ssh/gregohardy.pem', dest => "centos@${pe_master}")
  $pe_tar_file = $output.first.value['_output']

  run_task('splunk::install_pe', $pe_master, tar_file => $pe_tar_file)
  info('splunk::configure_splunk_in_aws complete')
}
