#
# Cookbook:: macbook_config
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.



%w(ghostty visual-studio-code).each do |pkg|
  homebrew_cask pkg do
    options       "--force"
    cask_name     pkg
  end
end

homebrew_package %w(git tmux) 
