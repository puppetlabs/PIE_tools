#!/usr/bin/ruby

# PT_install_node
# PT_dest_module_path

require 'open3'

dest=ENV['PT_dest_module_path'][0..-1]

inventory_file = File.join(Dir.pwd, 'inventory.yaml')

_, stdout, stderr = Open3.popen3("bundle exec bolt file upload #{Dir.home}/.puppetlabs/bolt/modules/* #{dest} --nodes #{ENV['PT_install_node']} --inventoryfile #{Dir.pwd}/inventory.yaml")
puts "#{stdout.read} #{stderr.read}"
