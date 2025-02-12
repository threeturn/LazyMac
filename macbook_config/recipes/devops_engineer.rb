#
# Cookbook:: macbook_config
# Recipe:: devops_engineer
#
# Copyright:: 2025, The Authors, All Rights Reserved.


homebrew_tap 'hashicorp/tap'
homebrew_tap 'warrensbox/tap'

# Terraform
homebrew_package %w(warrensbox/tap/tfswitch warrensbox/tap/tgswitch opentofu tflint checkov terragrunt)

# Aws
homebrew_package 'awscli'

# Kubernetes
homebrew_package %w(k9s kubectx helm)

# vm management
homebrew_package %w(hashicorp/tap/packer)

