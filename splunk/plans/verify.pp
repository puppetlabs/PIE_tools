plan splunk::verify(
  String[1] $splunk_server,
  String[2] $search_host
) {
  info('running splunk::verify')
  $output = run_task('splunk::search', $splunk_server, host => $search_host)
  $records = $output.first.value['_output']

  info($records)
  info('')
  info('splunk::verify completed')
}
