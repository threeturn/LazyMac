#
# Cookbook:: macbook_config
# Recipe:: podman
#
# Copyright:: Copyright 2025, Andrea C. Granata
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
  command "#{node['macbook_config']['homebrew_prefix']}/bin/podman machine init"
  user    node['macbook_config']['uid']
  group   node['macbook_config']['gid']
  creates "#{node['macbook_config']['podman_config_dir']}/containers/podman-connections.json"
  action  :nothing
end

# Create the Podman machine configuration file from a template
template "#{node['macbook_config']['podman_config_dir']}/containers/containers.conf.d/machine.conf" do
  source 'machine.erb'
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0755'
  notifies :run, 'execute[podman machine init]'  # Notify the 'podman machine init' command to run if this template changes
end



