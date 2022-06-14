#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Helpers
  module PuppetHelper
    def puppet_bin
      if Gem.win_platform?
        require 'win32/registry'
        installed_dir =
          begin
            Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Puppet Labs\Puppet') do |reg|
              # rubocop:disable Style/RescueModifier
              # Rescue missing key
              dir = reg['RememberedInstallDir64'] rescue ''
              # Both keys may exist, make sure the dir exists
              break dir if File.exist?(dir)

              # Rescue missing key
              reg['RememberedInstallDir'] rescue ''
              # rubocop:enable Style/RescueModifier
            end
          rescue Win32::Registry::Error
            # Rescue missing registry path
            ''
          end

        path =
          if installed_dir.empty?
            ''
          else
            File.join(installed_dir, 'bin', 'puppet.bat')
          end
      else
        path = '/opt/puppetlabs/puppet/bin/puppet'
      end
      path
    end

    def catalog_path
      if Gem.win_platform?
        'C:/ProgramData/PuppetLabs/puppet/cache/client_data/catalog/'
      else
        '/opt/puppetlabs/puppet/cache/client_data/catalog/'
      end
    end

    def csr_attributes_file
      if Gem.win_platform?
        'C:/ProgramData/PuppetLabs/puppet/etc/csr_attributes.yaml'
      else
        '/etc/puppetlabs/puppet/csr_attributes.yaml'
      end
    end

  end
end