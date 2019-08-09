#!/usr/bin/ruby

require 'aws-sdk-ec2'  # v2: require 'aws-sdk'
require 'ap'

instance_name = ENV['PT_instance_name']
subnet_id = ENV['PT_subnet_id']
sg_id = ENV['PT_sg_id']

ec2 = Aws::EC2::Resource.new(region: ENV['AWS_REGION'])

instance = ec2.create_instances({
  image_id: 'ami-0ff760d16d9497662',
  min_count: 1,
  max_count: 1,
  key_name: ENV['AWS_KEY_NAME'],
  instance_type: 't2.medium',
  network_interfaces: [{device_index: 0,
    subnet_id: subnet_id,
    groups: [sg_id],
    delete_on_termination: true,
    associate_public_ip_address: true}]
})

# Wait for the instance to be created, running, and passed status checks
ec2.client.wait_until(:instance_running, {instance_ids: [instance.first.id]})

instance.create_tags({ tags: [{ key: 'Name', value: instance_name }, { key: 'lifetime', value: '1d' }]})
i = ec2.instance(instance.first.id)

print i.public_dns_name


