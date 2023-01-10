rhload 'lib/options.rb'
rhload 'cmdshell.rb'
rhload 'debug.rb'
class MainEntry
    attr :option;
	attr :configHome;
    def initialize ##{{{
        @option = Options.new();
		@configHome = "#{$toolhome}/configs";
    end ##}}}

	def __getconfigs__ ##{{{
		c = {};
		configf = @option.config;
		if configf != ''
			cnts = File.open("#{@configHome}/#{configf}.hostconfig",'r').readlines();
			cnts.each do |line|
				line.chomp!;
			end
			c[:user]     = cnts[0];
			c[:password] = cnts[1];
			c[:host]     = cnts[2];
			c[:path]     = cnts[3];
		else
			c[:user]     = @option.user;
			c[:password] = @option.password;
			c[:host]     = @option.host;
			c[:path]     = @option.path;
		end
		return c;
	end ##}}}
	def __prepareCommand__ ##{{{
		"""
		to prepare the command file being executed by remote server, nomatter what kind of cmdmode
		it will finally arranged to a series of shell commands
		"""
		cmds = [];
		cmds << "ssh -f";
		configs = __getconfigs__;
		cmds << "#{configs[:user]}@#{configs[:host]}";
		cmds << "'cd #{configs[:path]};"+__singleCommand__+"'" if @option.cmdmode==:cmd;
		# run commands on shell
		cmd = cmds.join(' ');
		puts "cmd: #{cmd}"
		rtns = Shell.exec('./',cmd);
		return rtns[1];
	end ##}}}
	def __singleCommand__ ##{{{
		return @option.cmd;
	end ##}}}
	def __setuphost__ fn ##{{{
		t = "#{@configHome}/#{fn}.hostconfig";
		cnts = [];
		cnts << @option.user;
		cnts << @option.password;
		cnts << @option.host;
		cnts << @option.path;
		Shell.generate(:file,t,*cnts);
	end ##}}}
	def run ##{{{
		sname = @option.setup;
		if sname!=''
			__setuphost__(sname);
		else
			return __prepareCommand__;
		end
		return 0;
	end ##}}}
end
