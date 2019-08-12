plan splunk::configure_splunk_in_aws(
  String[1] $splunk_server,
  String[1] $pe_master,
  String[2] $splunk_token_name
) {
  info('running splunk::configure_splunk_in_aws')
  $priv_key = '/Users/greghardy/.ssh/gregohardy.pem'

  $output = run_task('splunk::get_pe', 'localhost', key_file_path => $priv_key, dest => "centos@${pe_master}")
  $pe_tar_file = $output.first.value['_output']

  run_task('splunk::install_pe', $pe_master, tar_file => $pe_tar_file)

  $output = run_task('splunk::get_module_path', $pe_master)
  $modpath = $output.first.value['_output']
  run_task('splunk::upload_modules_aws', 'localhost', key_file => $priv_key, user_host => "centos@${pe_master}", dest_module_path => $modpath)

  run_task('splunk::bootstrap_splunk', $splunk_server, sudo => 'sudo', hec_token_name => $splunk_token_name)
  run_task('splunk::splunk', $splunk_server, state => 'start', sudo => 'sudo', options => '--accept-license --no-prompt')

  run_task('splunk::configure_a_hec', $splunk_server, hec_token_name => $splunk_token_name, sudo => 'sudo')
  run_task('splunk::enable_hec', $splunk_server, hec_token_name => $splunk_token_name, sudo => 'sudo')
  run_task('splunk::splunk', $splunk_server, state => 'restart', sudo => 'sudo')

  $token_result = run_task('splunk::get_hec_token', $splunk_server, hec_token_name => $splunk_token_name)
  $token = $token_result.first.value['_output']
  run_task('splunk::add_hec_token', $pe_master, server => $splunk_server, splunk_hec_token => $token, sudo => 'sudo')

  run_task('splunk::install_ta_viewer', $splunk_server, version => '1.5.1', sudo => 'sudo')
  run_task('splunk::splunk', $splunk_server, state => 'restart')

  info('splunk::configure_splunk_in_aws complete')
}
