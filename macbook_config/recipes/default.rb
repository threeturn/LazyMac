#
# Cookbook:: macbook_config
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.



homebrew_cask w%(iterm2 visual-studio-code) pkg do
  options       "--force"
end

homebrew_package w%(git tmux) 
