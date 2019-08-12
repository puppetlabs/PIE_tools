#!/usr/bin/ruby

# PT_key_file
# PT_user_host
# PT_dest_module_path

require 'open3'

require 'pry'

binding.pry
dest=ENV['PT_dest_module_path'][0..-1]

Open3.popen3("ssh -i #{ENV['PT_key_file']} #{ENV['PT_user_host']} 'mkdir -p ~/modules'")

_, stdout, stderr = Open3.popen3("scp -r -i #{ENV['PT_key_file']} #{Dir.home}/.puppetlabs/bolt/modules/* #{ENV['PT_user_host']}:~/modules")

_, stdout, stderr = Open3.popen3("ssh -i #{ENV['PT_key_file']} #{ENV['PT_user_host']} \"sudo mv ~/modules/* #{dest}\"")

puts "Complete"
