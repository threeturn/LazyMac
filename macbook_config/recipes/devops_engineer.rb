#
# Cookbook:: macbook_config
# Recipe:: devops_engineer
#
# Copyright:: 2025, The Authors, All Rights Reserved.


homebrew_tap 'hashicorp/tap'

['tflint', 'hashicorp/tap/terraform', 'opentofu', 'awscli', 'tfswitch', 
 'tgswitch', 'packer', 'granted','helm', 'k9s', 'checkov','kubectx','jfrog-cli'].each do |pkg|
	homebrew_package pkg
end

