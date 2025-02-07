#
# Cookbook:: macbook_config
# Recipe:: developer
#
# Copyright:: 2025, The Authors, All Rights Reserved.


homebrew_cask 'intellij-idea-ce'

['jenv', 'chruby'].each do |pkg|
	homebrew_package pkg
end

