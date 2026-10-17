# Cookbook:: macbook_config
# Copyright:: Copyright 2026, Andrea C. Granata
# License:: Apache-2.0
#
# Temporary extension for Chef/Cinc 19.3.14. Load from cookbook libraries/.
# Grants explicit formula trust; does not trust whole taps or disable checks.

require 'etc'
require 'json'
require 'chef/resource/homebrew_tap'

class Chef
  class Resource
    class HomebrewTap
      property :trusted_formulae, Array, default: []

      action :trust do
        formulae = new_resource.trusted_formulae
        unless formulae.all? { |f| f.is_a?(String) && f.split('/').length == 3 && f.start_with?("#{new_resource.tap_name}/") }
          raise ArgumentError, 'trusted_formulae must contain fully qualified formula names from this tap'
        end

        unless formulae.empty?
          owner = Etc.getpwnam(new_resource.owner)
          brew = homebrew_bin_path(new_resource.homebrew_path)
          command_options = {
            user: owner.uid,
            group: owner.gid,
            login: true,
            cwd: owner.dir,
            environment: {
              'HOME' => owner.dir,
              'RUBYOPT' => nil,
              'TMPDIR' => nil,
            },
          }

          result = shell_out!(brew, 'trust', '--formula', '--json=v1', **command_options)
          trusted = JSON.parse(result.stdout)
          unless trusted.is_a?(Array) && trusted.all? { |entry| entry.is_a?(String) }
            raise 'Unexpected output from brew trust --formula --json=v1'
          end

          (formulae.uniq - trusted).each do |formula|
            converge_by("trust Homebrew formula #{formula} as #{owner.name}") do
              shell_out!(brew, 'trust', '--formula', formula, **command_options)
            end
          end
        end
      end

      action_class do
        include Chef::Mixin::Homebrew
      end
    end
  end
end
