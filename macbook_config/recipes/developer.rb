#
# Cookbook:: macbook_config
# Recipe:: developer
#
# Copyright:: Copyright 2025, Andrea C. Granata
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


homebrew_cask 'intellij-idea-ce' do
  options       "--force"
end

homebrew_package %w(jenv chruby jfrog-cli)

cookbook_file "#{ENV['HOME']}/.zshrc.d/jenv.zsh" do 
  source "jenv"
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end

template "#{ENV['HOME']}/.zshrc.d/chruby.zsh" do
  source 'chruby.erb'
  owner node['macbook_config']['uid']
  group node['macbook_config']['gid']
  mode '0644'
end


