#!/usr/bin/ruby

require 'open3'

_, stdout, stderr = Open3.popen3("/opt/splunk/bin/splunk #{ENV['PT_state']} #{ENV['PT_options']}")
output = stdout.read
errors = stderr.read

puts output + errors
