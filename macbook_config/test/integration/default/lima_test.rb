# Cinc Auditor test for recipe macbook_config::lima

control 'lima-packages' do
  impact 1.0
  title 'Install Lima and QEMU through Homebrew'

  describe package('lima') do
    it { should be_installed }
  end

  describe package('qemu') do
    it { should be_installed }
  end
end

control 'lima-executables' do
  impact 1.0
  title 'Run Lima and QEMU CLIs successfully'

  describe command('limactl --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/limactl version/i) }
  end

  describe command('qemu-img --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/qemu-img version/i) }
  end
end
