"""
# Object description:
CommandIssuer, the command building class
"""

require 'CommandInfo'
class CommandIssuer ##{{{

	
	## init(), description
	def initialize(); ##{{{
		#puts "#{__FILE__}:(init()) is not ready yet."
	end ##}}}

	## issueCommand(ui,db), 
	# 1.get last command information from database
	# 2.add current position, last position +20
	# 3.fixed window size is 200x100
	def issueCommand(ui,db); ##{{{
		targetCmd = ui.readTargetCommand();
		cmdInfo = db.searchCommand(:issue);
		setTermPosition(cmdInfo);
		fullCmd = createIssueCommand(targetCmd,cmdInfo);
		db.record(cmdInfo,targetCmd);
		dispatch(fullCmd);
	end ##}}}


private

	## dispatch(cmd), 
	# dispatch cmd 
	def dispatch(cmd); ##{{{
		puts "DEBUG, issuing command:(#{cmd})"
		exec cmd;
	end ##}}}


	## setTermPosition(), description
	def setTermPosition(lc); ##{{{
		id = lc.jobid.to_i;
		lc.winPos[:x]=20*id;
		lc.winPos[:y]=20*id;
	end ##}}}

	## createIssueCommand(), create and return
	# the string based command to:
	# 0.start and set the xterm
	# 1.target command to be executed
	# 2.finish cw command after the target command is executed.
	# attention that this version not support to cancel the command by users. But can kill
	# it by calling cw -k
	def createIssueCommand(targetCmd,ci); ##{{{
		# 0.setup xterm command and options
		geometry = "#{ci.winSize[:width]}x#{ci.winSize[:height]}+#{ci.winPos[:x]}+#{ci.winPos[:y]}";
		cmdlog   = "CW-#{ci.jobid}.log";
		id = ci.jobid;
		termCmd = %Q|xterm -geometry #{geometry}|;
		# 1.setup cw -u <jobid> command
		updateCmd = %Q|cw -u #{id}|;
		# 2.setup cw -f <jobid> command
		finishCmd = %Q|cw -f #{id}|;
		# 3.assemble command
		# TODO, this redirection is applicable for cshell only.
		fullCmd = %Q|#{termCmd} -e "#{updateCmd};#{targetCmd} \|& tee #{cmdlog};#{finishCmd}" &|;

		return fullCmd;
	end ##}}}

end ##}}}