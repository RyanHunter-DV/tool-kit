# <PACKER> - v2/lib_v1/debugger.rb,33204
class Debugger
	attr_accessor :enabled;
	def initialize(m)
		@enabled = m;
	end

	def print(msg)
		f = caller(1)[0];
		puts "[DEBUG] #{f}: #{msg}" if (@enabled);
	end
end
