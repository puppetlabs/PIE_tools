#!/usr/bin/ruby

require 'open3'

_, stdout, stderr = Open3.popen3('/opt/splunk/bin/splunk search host="$PT_host" -auth admin:simples1')
puts stdout.read
