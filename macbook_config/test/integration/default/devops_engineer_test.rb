# Cinc Auditor test for recipe macbook_config::devops_engineer

control 'devops-packages' do
  impact 1.0
  title 'Install DevOps packages and casks through Homebrew'

  %w(
    opentofu
    tflint
    checkov
    terragrunt
    warrensbox/tap/tgswitch
    common-fate/granted/granted
    awscli
    k9s
    kubectx
    helm
    hashicorp/tap/packer
  ).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe command('brew list --cask --versions tfswitch') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/^tfswitch\s+\S+/) }
  end
end

control 'devops-executables' do
  impact 1.0
  title 'Run DevOps CLIs successfully'

  {
    'tofu --version' => /OpenTofu/i,
    'tflint --version' => /TFLint version/i,
    'terragrunt --version' => /terragrunt version/i,
    'aws --version' => /aws-cli/i,
    'helm version --short' => /v\d+\.\d+\.\d+/,
    'packer --version' => /Packer/i,
  }.each do |cmd, pattern|
    describe command(cmd) do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(pattern) }
    end
  end
end
