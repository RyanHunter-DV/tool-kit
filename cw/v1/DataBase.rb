"""
# Object description:
DataBase, the db operates local records, file format:
<JOBID> <PROCESS> <STATUS> <COMMAND>
0000 xxx ISSUE/RUN/KILLED/FINISHED
0001 xxx ISSUE/RUN/KILLED/FINISHED
...
"""
require 'CommandInfo'
class DataBase ##{{{

	attr :logf;
	attr :contents;
	
	## init(), description
	def initialize(path); ##{{{
		puts "#{__FILE__}:(init()) is not ready yet."
		#@fileHandle = File.open(File.join(path,'CWDB.log'));
		@logf = File.join(path,'CWDB.log');
		@contents=[];
		loadingDbFile();
	end ##}}}

	## updateProcess(id,process), description
	def updateProcess(id,process); ##{{{
		matchedIndex=0;matchedLine='';
		@contents.each_with_index do |line,index|
			splitted = line.split(/ +/);
			jobid  =splitted[0].to_i;
			if id == jobid
				matchedLine =line.gsub(/<MARKER>/,process+'   ');
				matchedIndex=index;
				break;
			end
		end
		@contents.delete_at(matchedIndex);
		@contents.insert(matchedIndex,matchedLine)
		flushToLog;
	end ##}}}

	## updateContent(ci,cmd), 
	# update command info into contents
	def updateContent(ci,cmd); ##{{{
		id = formatJobId(ci.jobid);
		status = 'ISSUE';
		process= '<MARKER>';
		tty = ci.tty;
		if ci.jobid.to_i <= @contents.length
			@contents.insert(ci.jobid.to_i,%Q|#{id}       #{process}     #{status}       #{tty}  #{cmd}|);
		else
			@contents << %Q|#{id}       #{process}     #{status}       #{tty}  #{cmd}|;
		end
	end ##}}}

	## flushToLog(), description
	def flushToLog(); ##{{{
		#puts "#{__FILE__}:(flushToLog()) is not ready yet."
		fh = File.open(@logf,'w');
		@contents.each do |line|
			fh.write(line+"\n");
		end
		fh.close;
	end ##}}}

	## updateStatus(id,s), 
	def updateStatus(id,s); ##{{{
		s=s.to_s;id=id.to_i;
		matchedIndex=0;matchedLine='';
		@contents.each_with_index do |line,index|
			splitted = line.split(/ +/);
			jobid  =splitted[0].to_i;
			if id == jobid
				if s=='RUN'
					matchedLine = line.gsub(/ISSUE/,s+'  ');
				elsif s=='FINISHED'
					matchedLine = line.gsub(/RUN     /,s);
				elsif s=='KILLED'
					matchedLine = line.gsub(/RUN   /,s);
				end
				matchedIndex=index;
				break;
			end
		end
		@contents.delete_at(matchedIndex);
		@contents.insert(matchedIndex,matchedLine)
		flushToLog;
	end ##}}}
	 

	## finishCommand(), update database to finish
	def finishCommand(id); ##{{{
		updateStatus(id,'FINISHED');
	end ##}}}

	## searchFinishedCommand(), 
	#
	def searchFinishedCommand(); ##{{{
		cmdInfo = CommandInfo.new();
		@contents.each_with_index do |content,index|
			#content = @contents.at(-1);
			splitted = content.split(/ +/);
			status =splitted[2];
			if status=='FINISHED' or status=='KILLED'
				cmdInfo.jobid  =splitted[0];
				cmdInfo.process=splitted[1];
				cmdInfo.status =splitted[2];
				cmdInfo.tty    =splitted[3]
				cmdInfo.command=splitted[4];
				@contents.delete_at(index);
				return cmdInfo;
			end
		end
		return nil;
	end ##}}}

	## buildNewCommand, description
	def buildNewCommand; ##{{{
		#puts "#{__FILE__}:(buildNewCommand) is not ready yet."
		cmdInfo = CommandInfo.new();
		content = @contents.at(-1);
		splitted = content.split(/ +/);
		cmdInfo.jobid  =splitted[0].to_i + 1;
		return cmdInfo;
	end ##}}}


	## searchCommand(), 
	# search command from database in @contents
	def searchCommand(t=:normal,info=''); ##{{{
		if t==:issue
			# search next available command slot
			return nil if @contents.empty?;
			cmdInfo = searchFinishedCommand();
			cmdInfo = buildNewCommand() if cmdInfo==nil;
			return cmdInfo;
		end
		if t==:show
			matched=[];
			@contents.each do |line|
				ptrn = Regexp.new(info);
				md = ptrn.match(line);
				matched << line if md;
			end
			return matched;
		end
		if t==:normal
			cmdInfo=CommandInfo.new();
			@contents.each do |line|
				splitted = line.split();
				if splitted[0].to_i==info.to_i
					cmdInfo.jobid = splitted[0].to_i;
					cmdInfo.process=splitted[1];
					cmdInfo.status =splitted[2];
					cmdInfo.tty    =splitted[3];
					cmdInfo.command=splitted[4];
				end
			end
			return cmdInfo;
		end
	end ##}}}


	## record(ci,cmd), 
	# store new cmd info and target command to be issued.
	# ci -> CommandInfo object
	# cmd-> target command
	def record(ci,cmd); ##{{{
		updateContent(ci,cmd);
		flushToLog;
	end ##}}}


private

	## formatJobId(raw), description
	def formatJobId(raw); ##{{{
		puts "#{__FILE__}:(formatJobId(raw)) is not ready yet."
		return sprintf("%.4d"%raw);
	end ##}}}


	## loadingDbFile, description
	def loadingDbFile; ##{{{
		if File.exists?(@logf)
			fh = File.open(@logf,'r');
			@contents = fh.readlines().map{|l| l.chomp;};
			fh.close();
		else
			@contents<<'<JOBID>    <PROCESS>    <STATUS>    <TERMINAL>    <COMMAND>';
		end
	end ##}}}

end ##}}}