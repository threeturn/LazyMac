#
# Cookbook:: macbook_config
# Recipe:: developer
#
# Copyright:: 2025, The Authors, All Rights Reserved.


homebrew_cask 'intellij-idea-ce'
homebrew_package %w(jenv chruby jfrog-cli)

cookbook_file "#{ENV['HOME']}/.zshrc/jenv" do 
  source "zshrc"
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end

template '#{ENV['HOME']}/.zshrc/' do
  source 'chruby.erb'
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end


