#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require_relative '../lib/helpers/node_groups'
require_relative '../files/task_helper.rb'

class UpdateNodeGroup < TaskHelper
  include Helpers::NodeGroups

  def task(group_name:, class_parameters:, config_data: {}, **_kwargs)
    initialize_pe_modules
    group = get_group(group_name)

    if !config_data.empty?
      update_group({
        id: group['id'],
        classes: class_parameters,
        config_data: config_data
      })
    else
      update_group({
        id: group['id'],
        classes: class_parameters,
      })
    end

    group = get_group(group_name, refresh: true)

    {
      success: true,
      group: group,
    }
  end
end

UpdateNodeGroup.run if __FILE__ == $PROGRAM_NAME