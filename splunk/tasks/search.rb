#!/usr/bin/ruby

require 'open3'
host = ENV['PT_host']
sudo = ENV['sudo']

_, stdout, stderr = Open3.popen3("#{sudo} /opt/splunk/bin/splunk search host=#{host} -auth admin:simples1")

puts stdout.read
