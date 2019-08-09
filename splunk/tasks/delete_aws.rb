#!/usr/bin/ruby

# Assumptions. 
# You have tagged your resources with a common tag. This tag is passed by the ENV var below.
# The security group name is the tag_name as well.

require 'aws-sdk-ec2'

tag_name = ENV['PT_tag_name']

ec2 = Aws::EC2::Resource.new(region: ENV['AWS_REGION'])
client = Aws::EC2::Client.new(region: ENV['AWS_REGION'])

ec2.instances({filters: [{name: 'tag:Name', values: [tag_name]}]}).each do |i|
  if i.exists?
    case i.state.code
    when 48  # terminated
      puts "#{i.id} is already terminated"
    else
      puts "#{i.id} terminating"
      devices = i.block_device_mappings
      i.terminate
      i.wait_until_terminated

      # delete the ebs volumes
      devices.each do |device|
        client.delete_volume({
          volume_id: device.ebs.volume_id, 
        })
      end
    end
  end
end

route_tables = ec2.route_tables({
  filters: [
    {
      name: "tag:Name",
      values: [tag_name],
    },
  ]
})

subnets = ec2.subnets({
  filters: [
    {
      name: "tag:Name",
      values: [tag_name],
    },
  ]
})

igws = ec2.internet_gateways({
  filters: [
    {
      name: "tag:Name",
      values: [tag_name],
    },
  ]
})

sgs = ec2.security_groups()
vpcs = ec2.vpcs ({
  filters: [
    {
      name: "tag:Name",
      values: [tag_name],
    },
  ]
})

# Lets watch the world burn

subnets.each do |subnet|
  resp = client.delete_subnet({
    subnet_id: subnet.id, 
  })
end

igws.each do |ig| 
  ig.attachments.each do |vpc|
    ig.detach_from_vpc({vpc_id: vpc.vpc_id})
  end
  resp = client.delete_internet_gateway({
    internet_gateway_id: ig.id, 
  })
end

route_tables.each do |rt|
  client.delete_route_table({route_table_id: rt.id})
end

sgs.each do |sg|
  if sg.group_name == tag_name
    client.delete_security_group({group_id: sg.group_id})
  end
end

vpcs.each do |vpc|
  resp = client.delete_vpc({vpc_id: vpc.vpc_id})
end
