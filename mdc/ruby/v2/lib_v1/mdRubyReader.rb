# <PACKER> - v2/lib_v1/mdRubyReader.rb,33204
require 'mdRubyBuilder.rb'
require 'exceptions.rb'
require 'codelib.rb'

class MDRubyReader

	attr :rawcontents;
	attr :currentline;
	attr :maxline;
	attr :current; # current file object to build
	attr :files;
	attr :debug;

	def initialize(cnts,d)
		@rawcontents = cnts;
		@maxline = @rawcontents.length;
		@currentline = 1;
		@files = {};
		@debug = d;
	end

	def filtmark(line)
		ptrn = Regexp.new(/\*\*(\S+)\*\*/);
		mdata= ptrn.match(line);
		return nil unless mdata;
		mark = mdata[1].to_s;
		@debug.print("detect mark:#{mark}");
		message = "mark#{mark}".to_sym;
		self.send(message,line);
		return mark;
	end
	# when this method is called, then file mark is detected
	# supported marks
	def markfile(line)
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		raise MarkException.new("no filename found in file mark(#{line})") unless mdata;
		# @filename = mdata[1];
		@debug.print("building new file: #{mdata[1]}");
		@files[mdata[1]] = MDRubyBuilder.new(mdata[1],@debug);
		@current = @files[mdata[1]];
		return nil;
	end
	def markclass(line)
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		raise MarkException.new("no classname found in line(#{line})") unless mdata;
		@current.classname= mdata[1];
		return nil;
	end
	def markmodule(line)
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		raise MarkException.new("no modulename found in line(#{line})") unless mdata;
		@current.modulename= mdata[1];
		return nil;
	end
	def markrequire(line)
		cnts = getCodeblock;
		cnts.map!{|line| line.chomp;};
		cnts.map!{|line| %Q|require "#{line}";|;}
		@debug.print("require code: #{cnts}");
		@current.requires(*cnts);
		return;
	end
	def markapi(line)
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		cnts=[];
		raise MarkException.new("no api name found in line(#{line})") unless mdata;
		api = mdata[1];
		body=getCodeblock;
		body.map!{|line| line.chomp;};
		body.map!{|line| "\t"+line;};
		cnts << "def #{api} "+'##{{{';
		cnts.append(*body);
		cnts << "end"+'##}}}';
		cnts.map!{|line| "\t"+line;};
		@current.code(*cnts);
	end
	def markfield(line)
		cnts=[];
		body=getCodeblock;
		body.each do |l|
			cnts << "\tattr_accessor :#{l};";
		end
		@current.code(*cnts);
	end
	def markdef(line)
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		cnts=[];
		raise MarkException.new("no api name found in line(#{line})") unless mdata;
		api = mdata[1];
		body=getCodeblock;
		body.map!{|line| line.chomp;};
		body.map!{|line| "\t"+line;};
		cnts << "def #{api} "+'##{{{';
		cnts.append(*body);
		cnts << "end"+'##}}}';
		# cnts.map!{|line| "\t"+line;};
		@current.global(*cnts);
	end
	def markapio(line)
		# api replacement, used for rbcode
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		raise MarkException.new("no api name found in line(#{line})") unless mdata;
		api = mdata[1];
		cnts=getCodeblock;
		@current.codelib.apio(api,cnts);
	end

	def __filtOptions__(line)
		rtns = {};
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		raise MarkException.new("no option found in line(#{line})") unless mdata;
		option = mdata[1];
		options= option.split(',');
		options.each do |o|
			ptrn = Regexp.new(/(\S+)\s*:\s*(\S+)/);
			mdata= ptrn.match(o);
			rtns[mdata[1].to_s]=mdata[2].to_s if mdata;
		end
		return rtns;
	end
	def getCodeblock
		cnts = [];
		@currentline += 1;
		started = false;
		while (@currentline <= @maxline) do
			#@debug.print("mdfile: currentline:#{@currentline},cnt:#{@rawcontents[@currentline-1]}");
			break if /^```/=~@rawcontents[@currentline-1] and started==true;
			cnts << @rawcontents[@currentline-1] if started==true;
			started=true if /^```/=~@rawcontents[@currentline-1] and started==false;
			@currentline += 1;
		end
		cnts.map!{|l| l.chomp;};
		return cnts;
	end
	# def markcode(line)
	# 	options = __filtOptions__(line);
	# 	options['indent'] = 0 unless options.has_key?('indent');
	# 	cnts = getCodeblock;
	# 	@current.code(cnts,:indent=>options['indent']);
	# end
	def markrbcode(line)
		ptrn = Regexp.new(/`(.+)`/);
		mdata= ptrn.match(line);
		raise MarkException.new("no codeid found in line(#{line})") unless mdata;
		codeid = mdata[1];
		## get all option lines for codeid
		## cnts = readCodelibOptions;
		processCodelib(codeid);
	end

	def processCodelib(id)
		# process codelib
		cb = Codelib.new(id,@debug);
		@current.codelib = cb;
	end

	## def readCodelibOptions
	## 	# reading from current line until next line not started with `
	## 	cnts = [];
	## 	@currentline += 1;
	## 	while (@currentline <= @maxline) do
	## 		break if @rawcontents[@currentline-1][0..0] != '`';
	## 		cnts << @rawcontents[@currentline-1];
	## 		@currentline += 1;
	## 	end
	## 	return cnts;
	## end

	def process()
		while (@currentline <= @maxline) do
			filtmark(@rawcontents[@currentline-1]);
			@currentline+=1;
		end
	end

	def build
		@files.each_pair do |n,o|
			o.build(); # building @contents in each self
		end
	end

	def publish(fop)
		@files.each_pair do |n,o|
			o.publish(fop); # building contents into files
		end
	end
end
