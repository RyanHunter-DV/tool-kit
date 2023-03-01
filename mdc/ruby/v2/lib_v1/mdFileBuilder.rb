# <PACKER> - v2/lib_v1/mdFileBuilder.rb,33204
class MDFileBuilder

	attr_accessor :filename;
	attr_accessor :codes;
	attr :debug;
	def initialize(fn,d)
		@filename = fn;
		@debug = d;
		@codes = [];
	end

	def code(*lines)
		@codes.append(*lines);
	end

	# add code for this file, will be added into @codes
	# every time call this code method, will ad one string with "\n"
	# sa->source in array
	## def code(sa,**opts)
	## 	indent=0;
	## 	indent=opts[:indent] if opts.has_key?(:indent);
	## 	sa.map!{|line| ("\t"*indent)+line;};
	## 	line = sa.join("\n");
	## 	@codes << line;
	## end
end
