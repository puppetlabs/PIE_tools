#!/opt/puppetlabs/puppet/bin/ruby

require_relative '../files/task_helper.rb'
require_relative '../lib/helpers/puppet_helper.rb'
require 'open3'

class RunPuppet < TaskHelper
  include Helpers::PuppetHelper

  def task(alternate_host: nil, exit_codes: [0, 2], max_timeout: 0, env_vars: {}, additional_args: nil, **_kwargs)
    # This is necessary because TaskHelper#walk_keys() recursively symbolizes for named parameters and Open3 expects strings
    env = env_vars.each_with_object({}) do |e, hash|
      hash[e[0].to_s] = e[1].to_s
    end
    cmd = [puppet_bin, 'config', 'print', 'certname']
    certname = Open3.capture2e(*cmd)[0].strip
    puppet_cmd = [puppet_bin, 'agent', '-t','--color', 'false', '--no-noop', '--no-use_cached_catalog']
    if alternate_host
      puppet_cmd << '--server_list'
      puppet_cmd << "#{alternate_host}:8140"
    end

    puppet_cmd += additional_args if additional_args

    if max_timeout.zero?
      output, status = Open3.capture2e(env, *puppet_cmd)
    else
      timeout = 1
      while timeout < max_timeout
        output, status = Open3.capture2e(env, *puppet_cmd)
        # We only want to wait for a run in progress. If we exit
        # with an unallowed exit code, we don't want to keep
        # doing puppet runs until timeout.
        break unless status.exitstatus == 1 && output =~ /Run of Puppet configuration client already in progress/
        sleep(timeout)
        timeout *= 2
      end
    end

    if !exit_codes.include? status.exitstatus
      raise TaskHelper::Error.new("Running puppet failed on host with certname #{certname}. Output: #{output}", 'puppetlabs.run-puppet/run-puppet-failed', 'output' => output)
    end

    result = { _output: output }
    result.to_json
  end
end

RunPuppet.run if __FILE__ == $PROGRAM_NAME