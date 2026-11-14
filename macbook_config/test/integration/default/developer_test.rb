# Cinc Auditor test for recipe macbook_config::developer

control 'developer-packages' do
  impact 1.0
  title 'Install developer tools through Homebrew'

  %w(jenv chruby jfrog-cli).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe command('brew list --cask --versions intellij-idea-ce') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/^intellij-idea-ce\s+\S+/) }
  end
end

control 'developer-config' do
  impact 1.0
  title 'Configure jenv and chruby in zshrc.d'

  describe file("#{ENV['HOME']}/.zshrc.d/jenv.zsh") do
    it { should exist }
    its('mode') { should cmp '0644' }
  end

  describe file("#{ENV['HOME']}/.zshrc.d/chruby.zsh") do
    it { should exist }
    its('mode') { should cmp '0644' }
    its('content') { should match(/chruby\.sh/) }
    its('content') { should match(/RUBIES\+=/) }
  end
end
