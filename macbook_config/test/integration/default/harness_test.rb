# Cinc Auditor test for recipe macbook_config::harness



control 'harness-packages' do
  impact 1.0
  title 'Install the AI coding tools through Homebrew'

  describe package('anomalyco/tap/opencode-v2') do
    it { should be_installed }
  end

  %w(antigravity-cli codex claude-code).each do |cask|
    describe command("brew list --cask --versions #{cask}") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/^#{cask}\s+\S+/) }
    end
  end
end

control 'harness-executables' do
  impact 1.0
  title 'Run each AI coding CLI successfully'

  %w(codex opencode agy claude).each do |cli|
    describe command("#{cli} --version") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/\d+\.\d+\.\d+/) }
    end
  end
end
