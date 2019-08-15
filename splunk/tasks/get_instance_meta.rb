#!/usr/bin/ruby

require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'awesome_print'

tag_name = ENV['PT_tag_name']
# tag_name = 'greghardy-splunk'
public_dns_name = ENV['PT_public_dns_name']
# public_dns_name = 'ec2-52-210-158-156.eu-west-1.compute.amazonaws.com'

param = ENV['PT_param']
# param = 'public_dns_name'


ec2 = Aws::EC2::Resource.new(region: ENV['AWS_REGION'])

instances = ec2.instances({
  filters: [
    {
      name: "tag:Name",
      values: [tag_name],
    },
  ]
})

instances.each do |i|
  if i.public_dns_name == public_dns_name
    if param
      print i.data.to_hash[param.to_sym]
    else
      print i.data.to_hash
    end
    break
  end
end

