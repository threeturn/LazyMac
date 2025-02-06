

homebrew_package 'podman'

podman_config_dir = "#{ENV['HOME']}/.config/containers"
uid               = ENV['SUDO_UID'].to_i
gid               = ENV['SUDO_GID'].to_i

directory "#{podman_config_dir}/containers.conf.d/" do
  owner uid
  group gid
  recursive true
end

template "#{podman_config_dir}/containers.conf.d/machine.conf" do
  source 'machine.erb'
  owner uid
  group gid
  mode '0755'
  notifies :run, 'execute[podman machine init]'
end


execute 'podman machine init' do
  command 'podman machine init'
  user  uid
  group gid
  creates  "#{podman_config_dir}/podman-connections.json"
  action :nothing
end

