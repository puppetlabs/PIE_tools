#!/usr/bin/ruby

# PT_puppetfile

require 'open3'
require 'yaml'

homes = ["HOME", "HOMEPATH"]

realHome =  nil
homes.each do |h|
  realHome = ENV[h] if ENV[h] != nil
end

exit 4 if realHome.nil?

print realHome