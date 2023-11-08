"""
# Object description:
UserInterface, supported options:
cw -e <target commands>
cw -f <jobid>, update command status from RUN to FINISH
cw -u <jobid>, update command status from ISSUE to RUN
cw -s <cmd>,
"""
class UserInterface ##{{{

	attr_accessor :jobid;
	attr_accessor :info; # for updating to record db

	# the tool mode,
	# :issue -> issue a new command
	# :finish-> finish an running command
	# :kill-> execute kill action of the issued command
	# :update-> update state to recorded db
	attr :mode;

	attr :targetCmd;

	## init(), description
	def initialize(); ##{{{
		@jobid=-1; # default is -1, which is null
		@mode = :issue;
		@targetCmd='';
		@info=nil;
		args = ARGV.dup;
		processModeOption(args);
	end ##}}}

	## isCommandDone, return true if mode is :finish, else return false
	def isCommandDone; ##{{{
		return true if @mode==:finish;
		return false;
	end ##}}}

	## isShow, description
	def isShow; ##{{{
		#puts "#{__FILE__}:(isShow) is not ready yet."
		return true if @mode==:show;
		return false;
	end ##}}}

	## isKillMode(), description
	def isKillMode(); ##{{{
		return true if @mode==:kill;
		return false;
	end ##}}}

	## processModeOption, 
	# read -s/-f option
	def processModeOption(args); ##{{{
		if args.empty?
			puts "Error, please call this command with real commands";
			exit 3;
		end
		head = args.shift;
		if head=='-e'
			@targetCmd = args.join(' ');
		elsif head=='-f'
			@jobid = args.shift.to_i;
			@mode = :finish;
		elsif head=='-k'
			@jobid = args.shift.to_i;
			@mode = :kill;
		elsif head=='-u'
			@jobid = args.shift.to_i;
			@mode = :update;
		elsif head=='-s'
			# list command information
			@info = args.shift;
			@mode = :show;
		else
			puts "Error, invalid command format TBD"
		end
	end ##}}}

	## readTargetCommand, return the target user command
	def readTargetCommand; ##{{{
		return @targetCmd;
	end ##}}}

	## isUpdateMode, description
	def isUpdateMode; ##{{{
		
		return true if @mode==:update;
		return false;
		
	end ##}}}

end ##}}}