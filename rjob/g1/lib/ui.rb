require 'optparse'

class UI
	attr_reader :options, :parser

	def initialize
		@options = {
			help: false,
			cmd: '',
			remote: 'remote.hostconfig',
			local: 'local.hostconfig',
			shell: ''
		}

		@parser = ::OptionParser.new do |opts|
			# Basic options
			opts.on('-h', '--help', 'Show this help message') do
				@options[:help] = true
			end

			# Connection options
			opts.on('-r', '--remote=HOSTID', 'Specify remote host ID') do |val|
				@options[:remote] = val
			end

			# Shell execution option
			opts.on('-s', '--shell=shellfile', 'Specify shell file to execute remotely') do |val|
				@options[:shell] = val
			end

			# Version and info options
			opts.on('--version', 'Show version information') do
				@options[:version] = true
			end

			opts.on('--list-configs', 'List available configuration files') do
				@options[:list_configs] = true
			end
		end

		# Set banner and separator
		@parser.banner = "Usage: rjob [options] [command]"
		@parser.separator ""
		@parser.separator "Options:"
	end

	def parse!
		begin
			@parser.parse!

			# Handle help
			if @options[:help]
				show_help
				exit 0
			end

			# Handle version
			if @options[:version]
				show_version
				exit 0
			end

			# Handle list configs
			if @options[:list_configs]
				list_configs
				exit 0
			end

			# Extract command from remaining arguments
			if ARGV.length > 0
				@options[:cmd] = ARGV.join(' ')
			end

			# Validate required options
			validate_options!

		rescue ::OptionParser::InvalidOption, ::OptionParser::MissingArgument => e
			puts "Error: #{e.message}"
			show_help
			exit 1
		end
	end

	def show_help
		puts @parser
		puts ""
		puts "Examples:"
		puts "  rjob -r host 'ls -la'                    # Execute single command"
		puts "  rjob -r host -s shellfile.sh             # Execute shell file remotely"
		puts ""
		puts "Configuration files are stored in: #{$toolhome}/configs/"
	end

	def show_version
		puts "rjob - Remote Job Submission Tool"
		puts "Version: g1"
		puts "Built with UI class"
	end

	def list_configs
		config_dir = "#{$toolhome}/configs"
		if Dir.exist?(config_dir)
			configs = Dir.glob("#{config_dir}/*.hostconfig")
			if configs.empty?
				puts "No configuration files found in #{config_dir}"
			else
				puts "Available configurations:"
				configs.each do |config|
					name = File.basename(config, '.hostconfig')
					puts "  #{name}"
				end
			end
		else
			puts "Configuration directory not found: #{config_dir}"
		end
	end

	def validate_options!
		# Check if we have a command mode
		if (@options[:cmd].nil? || @options[:cmd].empty?) && 
		   (@options[:shell].nil? || @options[:shell].empty?)
			puts "Error: No command specified. Use -h for help."
			exit 1
		end

		# Validate shell file exists
		if !@options[:shell].nil? && !@options[:shell].empty? && !File.exist?(@options[:shell])
			puts "Error: Shell file not found: #{@options[:shell]}"
			exit 1
		end
	end

	# Getter methods for options
	def help?; @options[:help]; end
	def verbose?; false; end
	def dry_run?; false; end
	def user; nil; end
	def password; nil; end
	def host; @options[:host]; end
	def path; nil; end
	def cmd; @options[:cmd]; end
	def cmdf; nil; end
	def shell; @options[:shell]; end
	def setup; nil; end
	def select; nil; end

	def cmdmode
		return :shell if !@options[:shell].nil? && !@options[:shell].empty?
		return :cmd if !@options[:cmd].nil? && !@options[:cmd].empty?
		:none
	end

	def remote
		@options[:remote]
	end

	def local
		@options[:local]
	end
end