#
# Cookbook:: macbook_config
# Recipe:: zsh
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


homebrew_package 'oh-my-posh'

cookbook_file "#{ENV['HOME']}/.zshrc" do 
  source "zshrc"
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end

directory "#{ENV['HOME']}/.zplugins/zshrc.d" do
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0755'
  action :create
  recursive true
end

directory "#{ENV['HOME']}/.zshrc.d" do
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0755'
  action :create
end

cookbook_file "#{ENV['HOME']}/.zplugins/zshrc.d/zshrc.d.zsh" do 
  source "zshrcd.zsh"
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end

cookbook_file "#{ENV['HOME']}/.zplugins/zshrc.d/zshrc.d.plugin.zsh" do 
  source "zshrc.d.plugin.zsh"
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end

cookbook_file "#{ENV['HOME']}/.zshrc.d/oh-my-posh.zsh" do 
  source "oh-my-posh"
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end

