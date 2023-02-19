# 1. record all dir and files according to given root
# 2.
class MainEntry

	attr :root;
	attr :debug;
	attr :exitSig;
	attr :allfiles;
	attr :pak; # the packed file

	def initialize r
		@root = File.absolute_path(r);
		@exitSig = 0;
		@debug = false;
		@allfiles= [];
		@pak = '__installerPacker__.pak';
		@pakh= File.open(@pak,'w');
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
		return f.sub("#{@root}/",'# <PACKER> - ');
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
		# find all files
		subs = Dir.children(@root);
		__getsubs__(@root);
		debug("#{@allfiles}");

		__packall__;
		@pakh.close();
		return @exitSig;
	end

end
