# Policyfile: devops (DevOps / Platform Engineer Persona)

require 'yaml'

name 'lazymac_devops'
default_source :supermarket
cookbook 'macbook_config', path: '../macbook_config'

run_list(
  'macbook_config::default',
  'macbook_config::zsh',
  'macbook_config::devops_engineer',
  'macbook_config::podman',
  'macbook_config::harness',
  'macbook_config::lima',
  'macbook_config::ssh'
)

# Sensible defaults for container-heavy DevOps workflows
default['macbook_config']['cpu']    = '4'
default['macbook_config']['memory'] = '8192'

attrs_file = ENV['LAZYMAC_ATTRIBUTES_FILE'] || File.expand_path('../attributes.local.yml', __dir__)
if File.exist?(attrs_file)
  local_attrs = YAML.safe_load(File.read(attrs_file))
  if local_attrs.is_a?(Hash)
    local_attrs.each do |ns, values|
      if values.is_a?(Hash)
        values.each { |k, v| override[ns][k] = v }
      else
        override[ns] = values
      end
    end
  end
end
