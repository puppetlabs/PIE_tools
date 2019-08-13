plan splunk::inject_aws(
  String[1] $server
) {
  info('running splunk::inject')
  run_command("sudo /usr/local/bin/puppet apply -e 'notify { \"hello world\": }' --reports=splunk_hec", $server)
  info('splunk::inject completed')
}
