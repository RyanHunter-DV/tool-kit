"""
# Object description:
CommandInfo, store command configurations for issuing
"""
class CommandInfo ##{{{

	# [:x] => int, [:y] => int
	attr_accessor :winPos;
	attr_accessor :jobid;
	# [:width] => int, [:height] => int
	attr_accessor :winSize;
	attr_accessor :process;
	attr_accessor :status;
	attr_accessor :command;
	attr_accessor :tty;

	## init(), description
	def initialize(); ##{{{
		@winSize={:width=>'200',:height=>'20'};
		@winPos ={:x=>0,:y=>0};
		@status ='ISSUE';
		@process='<MARKER>';
		@command='<MARKER>';
		@tty = getTty;
	end ##}}}


	## getTty, description
	def getTty; ##{{{
		#puts "#{__FILE__}:(getTty) is not ready yet."
		return `tty`.chomp;
	end ##}}}

end ##}}}