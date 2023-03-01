# <PACKER> - v2/lib_v1/options.rb,33204
require 'optparse';

class Options
	# mode: idle,help,store,display,insert
	# idle is doing nothing
	attr_accessor :options;
	attr :debug;
	def initialize(d)
		@debug  = d;
		@options= {};
		loption = OptionParser.new() do |opt|
			opt.on('-s','--source=SOURCE','specify the source document') do |v|
				@options[:source] = v;
			end
		end.parse!
	end

end
