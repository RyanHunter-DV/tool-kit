# <PACKER> - v2/lib_v1/mdRubyBuilder.rb,33204
require 'mdFileBuilder.rb'
class MDRubyBuilder < MDFileBuilder
	attr_accessor :classname;
	attr_accessor :modulename;
	attr_accessor :codelib;
	attr_accessor :globals;
	attr_accessor :requiredfiles;

	attr :contents;
	def initialize(fn,d)
		@classname = '';
		@modulename= '';
		super(fn,d);
		@contents=[];
		@globals =[];
		@requiredfiles=[];
	end
	def global(*lines)
		@globals.append(*lines);
	end
	def requires(*cnts)
		@requiredfiles.append(*cnts);
	end

	def build
		@contents.append(*@requiredfiles);
		@contents << "class #{@classname}" if @classname!='';
		@contents << "module #{@modulename}" if @modulename!='';
		@codes.each do |code|
			splitted = code.split("\n");
			@contents.append(*splitted);
		end
		@contents << "end" if @classname!='' or @modulename!='';
		@globals.each do |code|
			splitted = code.split("\n");
			@contents.append(*splitted);
		end
		@contents.append(*@codelib.codes) if @codelib;
		return;
	end

	def publish(fop)
		@debug.print("building file: #{@filename} ...");
		fop.buildfile(@filename,@contents);
	end

end
