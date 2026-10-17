# Cinc Auditor test for recipe macbook_config::harness



control 'harness-packages' do
  impact 1.0
  title 'Install the AI coding tools through Homebrew'

  describe package('anomalyco/tap/opencode-v2') do
    it { should be_installed }
  end

  describe command('brew list --cask --versions antigravity-cli') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^antigravity-cli\s+\S+/) }
end

  describe command('brew list --cask --versions codex') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/^codex\s+\S+/) }
  end
end

control 'harness-executables' do
  impact 1.0
  title 'Run each AI coding CLI successfully'

  %w(codex opencode agy).each do |cli|
    describe command("#{cli} --version") do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/\d+\.\d+\.\d+/) }
    end
  end
end
