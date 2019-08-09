#!/usr/bin/env ruby
require 'json'
require 'net/http'
require 'yaml'
require 'puppet_litmus'

def get_inventory_hash(inventory_full_path)
  if File.file?(inventory_full_path)
    inventory_hash_from_inventory_file(inventory_full_path)
  else
    { 'groups' => [{ 'name' => 'docker_nodes', 'nodes' => [] }, { 'name' => 'ssh_nodes', 'nodes' => [] }, { 'name' => 'winrm_nodes', 'nodes' => [] }] }
  end
end

def run_local_command(command, wd = Dir.pwd)
  stdout, stderr, status = Open3.capture3(command, chdir: wd)
  error_message = "Attempted to run\ncommand:'#{command}'\nstdout:#{stdout}\nstderr:#{stderr}"
  raise error_message unless status.to_i.zero?
  stdout
end

def save_inventory(hostname, platform, inventory_location, vars_hash)
  if !File::ALT_SEPARATOR # ruby only sets this on windows private-key: ~/.ssh/id_rsa
    node = { 'name' => hostname,
             'config' => { 'transport' => 'ssh', 'ssh' => { 'user' => 'centos', 'private-key' => "#{ENV['AWS_PRIVATE_KEY']}.pem", 'host-key-check' => false } },
             'facts' => { 'provisioner' => 'aws', 'platform' => platform },
             'vars'  => vars_hash }
    group_name = 'ssh_nodes'
  else
    node = { 'name' => hostname,
             'config' => { 'transport' => 'winrm', 'winrm' => { 'user' => 'Administrator', 'password' => 'Qu@lity!', 'ssl' => false } },
             'facts' => { 'provisioner' => 'vmpooler', 'platform' => platform },
             'vars' => vars_hash }
    group_name = 'winrm_nodes'
  end
  inventory_full_path = './inventory.yaml'
  if inventory_location
    inventory_full_path = File.join(inventory_location, 'inventory.yaml')
  end
  inventory_hash = get_inventory_hash(inventory_full_path)
  add_node_to_group(inventory_hash, node, group_name)
  File.open(inventory_full_path, 'w') { |f| f.write inventory_hash.to_yaml }
  { status: 'ok', node_name: hostname }
end

def remove_node_from_inventory(node_name, inventory_location)
  inventory_full_path = File.join(inventory_location, 'inventory.yaml')
  if File.file?(inventory_full_path)
    inventory_hash = inventory_hash_from_inventory_file(inventory_full_path)
    remove_node(inventory_hash, node_name)
  end
  puts "Removed #{node_name}"
  File.open(inventory_full_path, 'w') { |f| f.write inventory_hash.to_yaml }
  { status: 'ok' }
end

def provision(node_name, platform, inventory_location, vars)
  include PuppetLitmus::InventoryManipulation
  unless vars.nil?
    vars_hash = YAML.safe_load(vars)
  end
  # vmpooler_hostname = if ENV['VMPOOLER_HOSTNAME'].nil?
  #                       'vcloud.delivery.puppetlabs.net'
  #                     else
  #                       ENV['VMPOOLER_HOSTNAME']
  #                     end
  # uri = URI.parse("http://#{vmpooler_hostname}/vm/#{platform}")

  # token = token_from_fogfile
  # headers = { 'X-AUTH-TOKEN' => token } unless token.nil?

  # http = Net::HTTP.new(uri.host, uri.port)
  # request = if token.nil?
  #             Net::HTTP::Post.new(uri.request_uri)
  #           else
  #             Net::HTTP::Post.new(uri.request_uri, headers)
  #           end
  # reply = http.request(request)
  # raise "Error: #{reply}: #{reply.message}" unless reply.is_a?(Net::HTTPSuccess)

  # data = JSON.parse(reply.body)
  # raise "VMPooler is not ok: #{data.inspect}" unless data['ok'] == true

  # hostname = "#{data[platform]['hostname']}.#{data['domain']}"
  
  save_inventory(node_name, platform, inventory_location, vars_hash)
end

def tear_down(node_name, inventory_location)
  include PuppetLitmus::InventoryManipulation
  # vmpooler_hostname = if ENV['VMPOOLER_HOSTNAME'].nil?
  #                       'vcloud.delivery.puppetlabs.net'
  #                     else
  #                       ENV['VMPOOLER_HOSTNAME']
  #                     end
  # uri = URI.parse("http://#{vmpooler_hostname}/vm/#{node_name}")
  # token = token_from_fogfile
  # headers = { 'X-AUTH-TOKEN' => token } unless token.nil?
  # http = Net::HTTP.new(uri.host, uri.port)
  # request = if token.nil?
  #             Net::HTTP::Delete.new(uri.request_uri)
  #           else
  #             Net::HTTP::Delete.new(uri.request_uri, headers)
  #           end
  # request.basic_auth @username, @password unless @username.nil?
  # http.request(request)
  remove_node_from_inventory(node_name, inventory_location)
end

params = JSON.parse(STDIN.read)
platform = params['platform']
action = params['action']
node_name = params['node_name']
inventory_location = params['inventory']
vars = params['vars']

# action = "provision"
# inventory_location  = "/Users/greghardy/.puppetlabs/bolt/"
# node_name = "ec2-54-194-103-12.eu-west-1.compute.amazonaws.com"
# platform = "aws"
# vars = ""

raise 'specify a node_name if tearing down' if action == 'tear_down' && node_name.nil?
raise 'specify a platform if provisioning' if action == 'provision' && platform.nil?

# begin
  result = provision(node_name, platform, inventory_location, vars) if action == 'provision'
  result = tear_down(node_name, inventory_location) if action == 'tear_down'
  puts result.to_json
  exit 0
# rescue => e
#   puts({ _error: { kind: 'facter_task/failure', msg: e.message } }.to_json)
#   exit 1
# end
