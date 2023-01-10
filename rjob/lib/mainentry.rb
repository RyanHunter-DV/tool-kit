rhload 'lib/options.rb'
rhload 'cmdshell.rb'
class MainEntry
    attr :option;
    def initialize ##{{{
        @option = Options.new();
    end ##}}}

	def __prepareCommand__ ##{{{
		"""
		to prepare the command file being executed by remote server, nomatter what kind of cmdmode
		it will finally arranged to a series of shell commands
		"""
		cmds = [];
		cmds << "ssh -f #{@option.user}@#{@option.host}";
		cmds << __singleCommand__ if @option.cmdmode==:cmd;
	end ##}}}
	def __singleCommand__ ##{{{
		return @option.cmd;
	end ##}}}
	def __setuphost__ fn ##{{{
		t = "#{$toolhome}/configs/#{fn}.hostconfig";
		cnts = [];
		cnts << @options.user;
		cnts << @options.password;
		cnts << @options.host;
		cnts << @options.path;
		Shell.generate(:file,t,*cnts);
	end ##}}}
	def run ##{{{
		sname = @option.setup;
		__setuphost__(sname) if sname!='';
		__prepareCommand__ if @option.cmdmode == :cmd;
	end ##}}}
end