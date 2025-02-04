#
# Cookbook:: macbook_config
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.


['iterm2','visual-studio-code'].each do |pkg|
	homebrew_cask pkg do
		options "--force"
	end
end

['git', 'oh-my-posh' 'podman'].each do |pkg|
	homebrew_package pkg
end



