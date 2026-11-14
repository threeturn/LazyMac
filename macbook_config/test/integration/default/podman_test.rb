# Cinc Auditor test for recipe macbook_config::podman

control 'podman-packages' do
  impact 1.0
  title 'Install Podman and Podman Desktop through Homebrew'

  describe package('podman') do
    it { should be_installed }
  end

  describe command('brew list --cask --versions podman-desktop') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/^podman-desktop\s+\S+/) }
  end

  describe command('podman --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/podman version/i) }
  end
end

control 'podman-config' do
  impact 1.0
  title 'Configure Podman machine settings'

  describe directory("#{ENV['HOME']}/.config/containers/containers.conf.d") do
    it { should exist }
  end

  describe file("#{ENV['HOME']}/.config/containers/containers.conf.d/machine.conf") do
    it { should exist }
    its('mode') { should cmp '0755' }
  end
end
