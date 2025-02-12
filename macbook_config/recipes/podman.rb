

# Install the Podman package using Homebrew
homebrew_package 'podman'
homebrew_cask 'podman-desktop'


# Create the directory for Podman containers configuration
%W(#{} /containers/ /containers/containers.conf.d/).each do |dir|
  directory "#{node['macbook_config']['podman_config_dir']}#{dir}" do
    owner node['macbook_config']['uid']
    group node['macbook_config']['gid']
  end
end

# Define the 'podman machine init' command to initialize the Podman machine
execute 'podman machine init' do
  command 'podman machine init'
  user  node['macbook_config']['uid']
  group node['macbook_config']['gid']
  creates  "#{node['macbook_config']['podman_config_dir']}/containers/podman-connections.json"
  action :nothing  # Only run this command when notified
end

# Create the Podman machine configuration file from a template
template "#{node['macbook_config']['podman_config_dir']}/containers/containers.conf.d/machine.conf" do
  source 'machine.erb'
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0755'
  notifies :run, 'execute[podman machine init]'  # Notify the 'podman machine init' command to run if this template changes
end



