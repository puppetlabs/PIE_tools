# frozen_string_literal: true

require 'hocon'
require 'puppet'

# rubocop:disable Style/ClassAndModuleChildren
module Helpers
  module NodeGroups

    # May be overwritten for testing.
    def self.enterprise_module_path
      '/opt/puppetlabs/server/data/environments/enterprise/modules'
    end

    def require_module_lib(module_name)
      lib_path = "#{Helpers::NodeGroups.enterprise_module_path}/#{module_name}/lib"

      $LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)
    end

    # Add pe_install and pe_manager to the Ruby load path.
    # Initialize Puppet so that the pe_node_groups tool can make use of
    # the Puppet::Network::HttpPool for communication.
    # Require the tools we need from the modules.
    def initialize_pe_modules
      Puppet.initialize_settings(['--libdir=/dev/null', '--factpath=/dev/null'])
      require_module_lib('pe_install')
      require_module_lib('pe_manager')
      require 'puppet_x/util/classification'
      require 'puppet_x/util/service_status'
      require 'puppet/util/pe_node_groups'
    end

    def get_service_on_primary(service)
      if PuppetX::Util::ServiceStatus.respond_to?(:get_service_on_primary)
        # Method was added in 2018.1.9...
        PuppetX::Util::ServiceStatus.get_service_on_primary(service)
      else
        config = PuppetX::Util::ServiceStatus.load_services_config
        nodes_config = PuppetX::Util::ServiceStatus.load_nodes_config
        primary_node = nodes_config.find { |node| node[:role] == 'primary_master' }
        config.find { |svc| svc[:type] == service && svc[:node_certname] == primary_node[:certname] }
      end
    end

    # Handle to the PE Classifier service as defined for the primary
    # in the local /etc/puppetlabs/client-tools/services.conf file.
    def classifier
      unless @nc
        @nc_service = get_service_on_primary('classifier')
        @nc = Puppet::Util::Pe_node_groups.new(@nc_service[:server], @nc_service[:port].to_i, "/#{@nc_service[:prefix]}")
      end
      @nc
    end

    # @return [Array<Hash>] All the Classifier Node Groups as returned by the
    #   groups end point.
    def all_groups
      unless @all_groups
        @all_groups = classifier.get_groups
      end
      @all_groups
    end

    # @param name [String] The group name to look up.
    # @return [Hash] The specific PE Node Group hash matching the given name.
    def get_group(name, refresh: false)
      @all_groups = nil if refresh
      group = PuppetX::Util::Classifier.find_group(all_groups, name)
      group
    end

    def get_group_and_descendents(name)
      parent = get_group(name)
      children = all_groups.select { |g| g['parent'] == parent['id'] }
      descendents = children.map { |c| get_group_and_descendents(c['name']) }
      [parent, descendents].flatten.sort { |a, b| a['name'] <=> b['name'] } # rubocop:disable Performance/CompareWithBlock
    end

    def update_group(group_delta)
      classifier.update_group(group_delta)
    rescue Puppet::Error => e
      raise(e)
    end
  end
end