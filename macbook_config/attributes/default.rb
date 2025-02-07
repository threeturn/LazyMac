


default['macbook_config']['rosetta']           = "false"
default['macbook_config']['cpu']               = "2"
default['macbook_config']['memory']            = "4096"
default['macbook_config']['podman_config_dir'] = "#{ENV['HOME']}/.config/containers"
default['macbook_config']['uid']               = ENV['SUDO_UID'].to_i
default['macbook_config']['gid']               = ENV['SUDO_GID'].to_i