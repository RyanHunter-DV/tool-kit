
require 'optparse';

class Options; ##{

	attr :options;

    def __initoptions__ ##{{{
		@options = {};
		@options[:help]   = false;
		@options[:path]   = './';
		@options[:project]='';
		@options[:tool]= :git;
		@options[:debug]= false;
    end ##}}}
	def initialize ##{{{
        __initoptions__;
		OptionParser.new do |opts|
			opts.on('-h') do |v|
				@options[:help]=true;
			end
			opts.on('-t','--tool=TOOL','specify the tree manage tool') do |val|
				@options[:tool] = val.to_sym;
			end
			opts.on('-r','--path=PATH','specify path of workarea') do |val|
				@options[:path] = val;
			end
			opts.on('-p','--project=PROJECT','specify the project to be downloaded') do |val|
				@options[:project] = val;
			end
			opts.on('-d','--debug','enable the debug feature') do |val|
				@options[:debug] = true;
			end
		end.parse!
	end ##}}}

	def helpMessage ##{{{
		puts "help information, TBD";
		exit 0;
	end ##}}}
	def project; return @options[:project]; end
	def path; return @options[:path]; end
	def tool; return @options[:tool]; end
	def debug; return @options[:debug]; end

	def gethelp ##{{{
		helpMessage if @options[:help]==true;
	end ##}}}
end ##}
