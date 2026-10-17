#
# Cookbook:: macbook_config
# Recipe:: harness
#
# Copyright:: 2026, The Authors, All Rights Reserved.

homebrew_cask 'codex'
homebrew_cask 'antigravity-cli'

homebrew_tap 'anomalyco/tap' do
  trusted_formulae ['anomalyco/tap/opencode-v2']
  action [:tap, :trust]
end

homebrew_package 'anomalyco/tap/opencode-v2'