#!/usr/bin/ruby

require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'ap'

tag_name = ENV['PT_tag_name']

ec2 = Aws::EC2::Resource.new(region: ENV['AWS_REGION'])

# Get all instances with tag key 'Group'
# and tag value 'MyGroovyGroup':
ec2.instances({filters: [{name: 'tag:Name', values: [tag_name]}]}).each do |i|
  puts 'ID:    ' + i.id
  puts 'State: ' + i.state.name
 
  if i.exists?
    case i.state.code
    when 48  # terminated
      puts "#{id} is already terminated"
    else
      puts "#{id} terminating"
      i.terminate
      i.wait_until_terminated
    end
  end
end





