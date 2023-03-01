# <PACKER> - v2/lib_v1/exceptions.rb,33204
class RunException < Exception
	attr :message;
	attr :signal;
	def initialize msg,s=0
		@message = msg;
		@signal = s;
		@signal = -1 if @signal==0;
	end
	
	def process
		$stderr.puts "[ERROR], #{@message}";
		return @signal;
	end
end

class MarkException < Exception
	attr :signal;
	attr :message;
	def initialize msg
		@message = msg;
		@signal  = 15;
	end
	def process
		$stderr.puts "[ERROR], #{@message}";
		return @signal;
	end
end
