"""
# Object description:
Core, the kernel object of a tool, will be called by the tool shell with provided two apis:
1. init, while creating this object, this api will be called automatically
2. run, after initialized, to call run to start this tool
"""

require 'UserInterface'
require 'CommandIssuer'
require 'DataBase'

class Core ##{{{

	attr :ui;
	attr :ci;

	## init(), description
	def initialize(); ##{{{
		puts "#{__FILE__}:(init()) is not ready yet."
		@ui = UserInterface.new();
		@ci = CommandIssuer.new();
		@db = DataBase.new(File.join($toolHome,$toolName,$version));
	end ##}}}

	## run(), description
	def run(); ##{{{
		#puts "#{__FILE__}:(run()) is not ready yet."
		if @ui.isCommandDone()
			completeCommand(@ui.jobid,@db);
		elsif @ui.isUpdateMode()
			updateInfo(@ui.jobid,@db);
		elsif @ui.isShow
			searchCommand(@ui.info,@db);
		elsif @ui.isKillMode
			killCommand(@ui.jobid,@db);
		else
			ci.issueCommand(@ui,@db);
		end
		return 0;
	end ##}}}


private

	## killCommand(id,db),normal 
	def killCommand(id,db); ##{{{
		cmdInfo = db.searchCommand(:normal,id);
		cmd = %Q|kill #{cmdInfo.process}|;
		if cmdInfo.process!='<MARKER>' and cmdInfo.process!=''
			exec cmd;
		else
			puts "Error, specified job id(#{id}) has no correct process(#{cmdInfo.process})";
		end
		db.updateStatus(id,'KILLED');
	end ##}}}

	## searchCommand(cmd,@db), description
	def searchCommand(cmd,db); ##{{{
		#puts "#{__FILE__}:(searchCommand(cmd,@db)) is not ready yet."
		matched = db.searchCommand(:show,cmd);
		if matched.empty?
			puts "No matched command searched in database";
		else
			puts "Command(s) matched:";
			matched.each do |m|
				puts "#{m}";
			end
		end
	end ##}}}



	## updateInfo(jobid), 
	# record the target executing process to local db, so that it can be
	# killed by caller panel.
	def updateInfo(jobid,db); ##{{{
		#puts "#{__FILE__}:(updateInfo) is not ready yet."
		process = `echo $$`.chomp;
		db.updateProcess(jobid,process);
		db.updateStatus(jobid,'RUN');
		#1.get current tty
		#2.search processes of 'xterm -geometry', find matched tty
		#3.record process to jobid matched local db.
	end ##}}}


	## completeCommand, 
	# action to complete the issued command, this only executed
	# by the callee after the target command executed.
	def completeCommand(jobid,db); ##{{{
		#puts "#{__FILE__}:(completeCommand) is not ready yet."
		db.finishCommand(jobid);
	end ##}}}


end ##}}}