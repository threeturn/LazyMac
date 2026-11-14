#
# Cookbook:: macbook_config
# Recipe:: ssh
#
# Copyright:: 2026, The Authors, All Rights Reserved.

directory "#{ENV['HOME']}/.ssh" do
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0700'
  action :create
end

template "#{ENV['HOME']}/.ssh/config" do
  source 'ssh_config.erb'
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0600'
end

cookbook_file "#{ENV['HOME']}/.zshrc.d/ssh.zsh" do
  source 'ssh.zsh'
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end
