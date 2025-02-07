

# Install the Podman package using Homebrew
['podman', 'podman-desktop'].each do |pkg|
	homebrew_package pkg
end

# Create the directory for Podman containers configuration
directory "#{podman_config_dir}/containers.conf.d/" do
  owner uid
  group gid
  recursive true
end

# Create the Podman machine configuration file from a template
template "#{node['macbook_config']['podman_config_dir']}/containers.conf.d/machine.conf" do
  source 'machine.erb'
  owner node['macbook_config']['uid']
  group node['macbook_config']['git']
  mode '0755'
  notifies :run, 'execute[podman machine init]'  # Notify the 'podman machine init' command to run if this template changes
end

# Define the 'podman machine init' command to initialize the Podman machine
execute 'podman machine init' do
  command 'podman machine init'
  user  node['macbook_config']['uid']
  group node['macbook_config']['git']
  creates  "#{node['macbook_config']['podman_config_dir']}/podman-connections.json"
  action :nothing  # Only run this command when notified
end