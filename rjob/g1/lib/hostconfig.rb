class HostConfig
	attr_reader :file, :username, :password, :remote_ip, :project_root
	def initialize(file)
		@file = file
		lines = File.readlines(file).map(&:strip)
		@username = lines[0]
		@password = lines[1]
		@remote_ip = lines[2]
		@project_root = lines[3]
	end
end