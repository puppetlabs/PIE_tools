#!/usr/bin/ruby

require 'open3'

def build_hash_from_cli_data(output)
    hash = Hash.new
    current = ''
    output.select do |x,y|
            if not x.include? '='
                    current = x
                    hash[current] = {}
            else
                    l = x.split('=')
                    hash[current][l[0]] = l[1]
            end
    end
    hash
end

token_key="http://#{ENV['PT_hec_token_name']}"

_, stdout, stderr = Open3.popen3('/opt/splunk/bin/splunk http-event-collector list -uri "https://localhost:8089" -auth admin:simples1')
output = stdout.read.gsub(/\t/, ' ').gsub(/\n/, ' ').split
hash = build_hash_from_cli_data(output)
token_hash = hash.select { |x,y| y['token'] if x.include? ENV['PT_hec_token_name'] }
print token_hash[token_key]['token']