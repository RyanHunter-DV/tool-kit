# <PACKER> - v2/lib_v1/mainentry.rb,33204
require 'exceptions.rb'
require 'mdRubyReader.rb'
require 'options.rb'
require 'fileOperator.rb'
class MainEntry
	attr :debug
	attr :options;
	def initialize(d)
		@debug = d;
		@options = Options.new(d).options;
	end

	def run
		fop = FileOperator.new(@debug);
		raise RunException.new("no source specific",3) unless @options.has_key?(:source) && @options[:source]!='';
		cnts = fop.read(@options[:source]);
		mr = MDRubyReader.new(cnts,@debug);
		mr.process();
		mr.build();
		mr.publish(fop);
	end
end
