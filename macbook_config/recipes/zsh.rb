#
# Cookbook:: macbook_config
# Recipe:: zsh
#
# Copyright:: 2025, The Authors, All Rights Reserved.



homebrew_package 'oh-my-posh'
homebrew_cask 'font-fira-code-nerd-font'


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

