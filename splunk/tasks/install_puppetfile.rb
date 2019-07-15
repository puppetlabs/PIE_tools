#!/usr/bin/ruby

# PT_puppetfile

require 'open3'
require 'yaml'

homes = ["HOME", "HOMEPATH"]

realHome =  nil
homes.each do |h|
  realHome = ENV[h] if ENV[h] != nil
end

exit 2 if realHome.nil?

Open3.popen3("mkdir -p #{realHome}/.puppetlabs/bolt/")
Open3.popen3("mkdir -p #{realHome}/.puppetlabs/bolt/modules")
Open3.popen3("cp #{ENV['PT_puppetfile']} #{realHome}/.puppetlabs/bolt/Puppetfile")
Open3.popen3('bundle exec bolt puppetfile install')
