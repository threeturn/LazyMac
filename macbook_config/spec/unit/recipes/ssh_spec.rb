#
# Cookbook:: macbook_config
# Spec:: ssh
#
# Copyright:: 2026, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'macbook_config::ssh' do
  context 'When all attributes are default, on macOS' do
    platform 'mac_os_x'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
