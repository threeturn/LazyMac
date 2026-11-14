# Cinc Auditor test for recipe macbook_config::ssh

control 'ssh-config' do
  impact 1.0
  title 'Configure SSH agent and macOS Keychain integration'

  describe directory("#{ENV['HOME']}/.ssh") do
    it { should exist }
    its('mode') { should cmp '0700' }
  end

  describe file("#{ENV['HOME']}/.ssh/config") do
    it { should exist }
    its('mode') { should cmp '0600' }
    its('content') { should match(/AddKeysToAgent yes/) }
    its('content') { should match(/UseKeychain yes/) }
    its('content') { should match(%r{IdentityFile ~/.ssh/id_rsa}) }
  end

  describe file("#{ENV['HOME']}/.zshrc.d/ssh.zsh") do
    it { should exist }
    its('mode') { should cmp '0644' }
    its('content') { should match(/ssh-add --apple-load-keychain/) }
  end
end
