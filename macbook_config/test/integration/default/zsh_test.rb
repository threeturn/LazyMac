# Cinc Auditor test for recipe macbook_config::zsh

control 'zsh-packages' do
  impact 1.0
  title 'Install Oh My Posh through Homebrew'

  describe package('oh-my-posh') do
    it { should be_installed }
  end

  describe command('oh-my-posh --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/\d+\.\d+\.\d+/) }
  end
end

control 'zsh-config' do
  impact 1.0
  title 'Configure zsh, zshrc.d, and Oh My Posh'

  describe directory("#{ENV['HOME']}/.zplugins/zshrc.d") do
    it { should exist }
  end

  describe directory("#{ENV['HOME']}/.zshrc.d") do
    it { should exist }
  end

  %W(
    #{ENV['HOME']}/.zshrc
    #{ENV['HOME']}/.zplugins/zshrc.d/zshrc.d.zsh
    #{ENV['HOME']}/.zplugins/zshrc.d/zshrc.d.plugin.zsh
    #{ENV['HOME']}/.zshrc.d/oh-my-posh.zsh
  ).each do |cfg|
    describe file(cfg) do
      it { should exist }
      its('mode') { should cmp '0644' }
    end
  end
end
