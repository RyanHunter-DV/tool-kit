rhload 'lib/toolbase.rb'
class GitTool < ToolBase
	def initialize d ##{{{
		super('git',d);
	end ##}}}

	def downloadCmds path,project ##{{{
		cmds = [];
		cmds << "cd #{path};";
		cmds << "#{@toolexe} clone git@github.com:RyanHunter-DV/#{project}.git .";
		return cmds;
	end ##}}}
end
