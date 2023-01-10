require 'optparse';

class Options; ##{

	attr :options;

    def __initoptions__ ##{{{
		@options = {};
		@options[:help] = false;
        @options[:user] = '';
        @options[:path] = '';
		@options[:cmdf] = '';
		@options[:cmd]  = '';
		@options[:host] = '';
		@options[:setup]= '';
		@options[:password] = '';
		@options[:select] = '';
    end ##}}}
    def __filtercmd__ ##{{{
        @options[:cmd] = ARGV.pop;
    end ##}}}
	def initialize ##{{{
        __initoptions__;
		OptionParser.new do |opts|
			opts.on('-h') do |v|
				@options[:help]=true;
			end
			opts.on('-u','--user=USER','specify user name for remote acccessing') do |val|
				@options[:user] = val;
			end
			opts.on('-p','--path=PATH','specify path for remote executing') do |val|
				@options[:path] = val;
			end
			opts.on('-c','--cmdf=cmdfile','specify command file for remote executing') do |val|
				@options[:cmdf] = val;
			end
			opts.on('-t','--setup=name','setup a host config') do |val|
				@options[:setup] = val;
			end
			opts.on('-w','--password=PASSWORD','specify user password') do |val|
				@options[:password] = val;
			end
			opts.on('-r','--remote=HOSTID','specify remote hostid') do |val|
				@options[:host] = val;
			end
			opts.on('-x','--select=configfile','specify to use a config file instead of manual specify user/path etc') do |val|
				@options[:select] = val;
			end
		end.parse!
        __filtercmd__ if @options[:cmdf]==''; # TODO, need test
	end ##}}}

	def helpMessage ##{
		puts "help information, TBD";
		exit 0;
	end ##}

	def gethelp ##{{{
		helpMessage if @options[:help]==true;
	end ##}}}
    def user ##{{{
        @options[:user] = 'ryan' if @options[:user]=='';
        return @options[:user];
    end ##}}}
	def cmdmode ##{{{
		"""
		cmdmode:
		- :cmd, single command mode
		- :cmdf, command file mode
		- :shell, shell file mode, currently not supported
		"""
		return :cmd  if @options[:cmd]!='';
		return :cmdf if @options[:cmdf]!='';
		#TODO, shell mode not supported yet.
	end ##}}}
	def cmd ##{{{
		return @options[:cmd];
	end ##}}}
	def host; return @options[:host]; end
	def setup; return @options[:setup]; end
	def password; return @options[:password]; end
	def path; return @options[:path]; end
	def config; return @options[:select]; end
end ##}