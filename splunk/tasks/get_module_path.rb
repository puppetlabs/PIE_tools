#!/usr/bin/ruby

require 'open3'

_, stdout, stderr = Open3.popen3("puppet config print | egrep \"^modulepath =\" | cut -d\: -f1 | cut -d\= -f2 | xargs")

config = stdout.read
print config.strip