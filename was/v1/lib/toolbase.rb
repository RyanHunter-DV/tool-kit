rhload 'cmdshell.rb'
class ToolBase

	attr :toolexe;
	attr :debug;

	attr_accessor :name;
	def initialize tn,d ##{{{
		@name = tn.to_s;
		@toolexe = tn;
		@debug   = d;
	end ##}}}

	def downloadCmds(path,project); return []; end
	def download path,project ##{{{
		cmds = [];
		cmds.append(downloadCmds(path,project));
		cmd = cmds.join(' ');
		@debug.print("download cmd: #{cmd}");
		begin
			rtns = Shell.exec('.',cmd);
			raise ShellException.new("failed reason(#{rtns[0]})") if rtns[1]!=0;
		rescue ShellException => e
			e.process("download(#{project}) to #{path} failed\n");
		end
	end ##}}}
end
