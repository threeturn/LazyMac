#
# Cookbook:: macbook_config
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.


['iterm2','visual-studio-code'].each do |pkg|
	homebrew_cask pkg
end

['git', 'podman'].each do |pkg|
	homebrew_package pkg
end



