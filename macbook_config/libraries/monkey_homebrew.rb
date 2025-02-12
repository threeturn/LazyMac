

class Chef
  class Provider
    class Package
      class Homebrew < Chef::Provider::Package
        def brew_cmd_output(*command, **options)
          homebrew_uid = find_homebrew_uid(new_resource.respond_to?(:homebrew_user) && new_resource.homebrew_user)
          homebrew_user = Etc.getpwuid(homebrew_uid)
          homebrew_group = homebrew_user.gid

          logger.trace "Executing '#{homebrew_bin_path} #{command.join(" ")}' as user '#{homebrew_user.name}'"

          # allow the calling method to decide if the cmd should raise or not
          # brew_info uses this when querying out available package info since a bad
          # package name will raise and we want to surface a nil available package so that
          # the package provider can magically handle that
          shell_out_cmd = options[:allow_failure] ? :shell_out : :shell_out!

          output = send(shell_out_cmd, homebrew_bin_path, *command, user: homebrew_uid, group: homebrew_group, login: true, environment: { "HOME" => homebrew_user.dir, "RUBYOPT" => nil, "TMPDIR" => nil })
          output.stdout.chomp
        end
       end
    end
  end
end




