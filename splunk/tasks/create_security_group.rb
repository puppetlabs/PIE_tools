#!/usr/bin/ruby

require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

group_name = ENV['PT_group_name']
vpc_id = ENV['PT_vpc_id']

ec2 = Aws::EC2::Resource.new(region: ENV['AWS_REGION'])

sg = ec2.create_security_group({
  group_name: group_name,
  description: 'Security group for your splunk test framework',
  vpc_id: vpc_id
})

sg.authorize_ingress({
  ip_permissions: [{
    ip_protocol: 'tcp',
    from_port: 22,
    to_port: 22,
    ip_ranges: [{
      cidr_ip: '0.0.0.0/0'
    }]
  }]
})

print sg.id