require_relative 'ui'
require_relative 'hostconfig'

class MainEntry
	attr_reader :ui, :remote_config, :local_config

	def initialize
		@ui = UI.new
		@ui.parse!
	end

	def find_root_anchor
		current_dir = File.absolute_path(Dir.pwd)
		dir = current_dir

		loop do
			anchor_path = File.join(dir, "rjob.anchor")
			if File.exist?(anchor_path)
				return File.dirname(anchor_path)
			end
			parent = File.dirname(dir)
			break if parent == dir # reached root
			dir = parent
		end

		raise "Cannot find rjob.anchor from #{current_dir}"
	end

	def load_config(rc,lc)
		config_dir = File.expand_path(File.join(File.dirname(__FILE__),'..', 'configs'))
		remote_config_file= File.join(config_dir, rc)
		local_config_file = File.join(config_dir, lc)

		unless File.exist?(remote_config_file)
			raise "Missing #{rc} in #{config_dir}"
		end

		unless File.exist?(local_config_file)
			raise "Missing #{lc} in #{config_dir}"
		end

		@remote_config = HostConfig.new(remote_config_file)
		@local_config = HostConfig.new(local_config_file)
	end

	def find_relative_path(current_dir, root_dir)
		abs_current = File.absolute_path(current_dir)
		abs_root = File.absolute_path(root_dir)
		# If root_dir is a file, get its directory
		abs_root = File.dirname(abs_root) if File.file?(abs_root)
		if abs_current.start_with?(abs_root)
			rel = abs_current[abs_root.length..-1]
			rel = rel.sub(%r{^/}, '') # remove leading slash if present
			return rel.empty? ? "." : rel
		else
			# fallback to FileUtils
			require 'pathname'
			return Pathname.new(abs_current).relative_path_from(Pathname.new(abs_root)).to_s
		end
	end

	def execute_command(project_name)
		# 1.prepare options used in rjob-server.
		# 2.prepare for ssh command.
		# ssh -f user@host 'cd /path/to/project;bootenv;run command'
		# ssh -f user@host "cd /path/to/project;rjob-server -e 'command'"
		# Assemble the SSH command using remote config information
		user = @remote_config.username
		host = @remote_config.remote_ip
		remote_path = @remote_config.project_root

		# Determine the command to run remotely
		cmd_to_run = "rjob-server -e '#{@ui.cmd}' -p #{project_name}"
		# Compose the SSH command
		ssh_cmd = [
			"ssh -f",
			"#{user}@#{host}",
			%Q{"cd #{remote_path}; #{cmd_to_run}"}
		].join(' ')
		puts "Executing SSH command:"
		puts ssh_cmd

		# Actually execute the command
		system(ssh_cmd)
	end

	def run
		anchor_path = find_root_anchor
		relative_path=find_relative_path(Dir.pwd, anchor_path)
		load_config(@ui.remote, @ui.local)
		# the anchor path is the root of the project
		puts "Anchor path: #{anchor_path}"
		puts "Relative path: #{relative_path}"
		puts "Remote config: #{@remote_config.username}@#{@remote_config.remote_ip}:#{@remote_config.project_root}"
		puts "Local config: #{@local_config.username}@#{@local_config.remote_ip}:#{@local_config.project_root}"
		execute_command(File.basename(anchor_path))

	end
end

