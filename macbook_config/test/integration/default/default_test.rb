# Cinc Auditor test for recipe macbook_config::default

control 'default-packages' do
  impact 1.0
  title 'Install core packages and casks through Homebrew'

  %w(git tmux).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  %w(ghostty visual-studio-code).each do |cask|
    describe command("brew list --cask --versions #{cask}") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/^#{cask}\s+\S+/) }
    end
  end
end

control 'default-executables' do
  impact 1.0
  title 'Run core CLIs successfully'

  describe command('git --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/git version/i) }
  end

  describe command('tmux -V') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/tmux/i) }
  end
end
