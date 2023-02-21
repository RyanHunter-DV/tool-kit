# 1. record all dir and files according to given root
# 2.
class MainEntry

	attr :root;
	attr :debug;
	attr :exitSig;
	attr :allfiles;
	attr :pak; # the packed file

	attr :mode; # :compress,:decompress
	attr :source;
	def optionProcess ##{{{
		@mode = :compress; # default
		@mode = :decompress if ARGV[0]=='-d';
		@root = File.absolute_path(ARGV[0]) if @mode==:compress;
		@source = File.absolute_path(ARGV[1]) if @mode==:decompress;
	end ##}}}
	def initialize
		optionProcess;
		@exitSig = 0;
		@debug = false;
		if @mode==:compress
			@allfiles= [];
			@pak = '__installerPacker__.pak';
			@pakh= File.open(@pak,'w');
		end
	end

	def debug(msg)
		if @debug
			puts "[DEBUG]: #{msg}";
		end
	end

	def __getsubs__(p) ##{{{
		subs = Dir.children(p);
		subs.each do |s|
			s = File.join(p,s);
			if File.directory?(s)
				__getsubs__(s);
			else
				@allfiles << File.absolute_path(s);
			end
		end
	end ##}}}

	# to remove the root path strings in allfiles 
	# root -> /home/user/dir
	# change: /home/user/dir/file
	# to: <PACKER_ROOT>/file
	def __filehead__(f) ##{{{
		filterout = File.dirname(@root);
		line = f.sub("#{filterout}/",'# <PACKER> - ');
		line += ",#{File.stat(f).mode}";
	end ##}}}

	def __packfile__(f) ##{{{
		head = __filehead__(f);
		fh = File.open(f,'r');
		cnts = fh.readlines();
		@pakh.write("#{head}\n");
		cnts.each do |line|
			@pakh.write(line);
		end
	end ##}}}
	# pack all files into ./__installerPacker__.pak
	def __packall__ ##{{{
		@allfiles.each do |f|
			__packfile__(f);
		end
	end ##}}}

	def run
		debug("root: #{@root}");
		if @mode==:decompress
			decompress;
		else
			# find all files
			subs = Dir.children(@root);
			__getsubs__(@root);
			debug("#{@allfiles}");

			__packall__;
			@pakh.close();
		end
		return @exitSig;
	end

	def decompress ##{{{
		fh = File.open(@source,'r');
		cnts = fh.readlines();
		cfile='';
		cnts.each do |line|
			line.chomp!;
			ptrn = Regexp.new('\<PACKER\> - (.+),(\d+)');
			md = ptrn.match(line);
			if md
				fh.close if cfile!='';
				cfile = md[1];
				fmode = md[2].to_i;
				createRecursiveDir(cfile,fmode);
				fh = File.open(cfile,'w');
				puts "file: #{cfile} decompressed" if cfile!='';
			end
			fh.write(line+"\n");
		end
	end ##}}}

	def createRecursiveDir(f,mode) ##{{{
		stack = [];
		created = false;
		d = File.dirname(f);
		while (not Dir.exists?(d)) do
			stack << d;
			d = File.dirname(d);
		end
		stack.reverse!;
		stack.each do |d|
			Dir.mkdir(d);
		end
		# create file
		fh = File.new(f,'w',mode);fh.close;
	end ##}}}

end
