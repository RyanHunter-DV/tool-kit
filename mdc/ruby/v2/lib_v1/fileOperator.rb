# <PACKER> - v2/lib_v1/fileOperator.rb,33204
class FileOperator
	attr :debug;
	def initialize(d)
		@debug = d;
	end

	def read(f)
		fh = File.open(f,'r');
		cnts = fh.readlines();
		fh.close();
		return cnts;
	end

	def buildfile(f,cnts)
		p = File.dirname(File.absolute_path(f));
		stack=[];
		while not Dir.exists?(p) do
			stack << p;
			p = File.dirname(p);
		end
		stack.reverse!;
		__builddir__(stack);
		__buildfile__(f,cnts);
	end
	def __buildfile__(f,cnts)
		fh = File.open(f,'w');
		cnts.each do |line|
			fh.write("#{line}\n");
		end
	end
	
	def __builddir__(ps)
		ps.each do |p|
			@debug.print("building dir: #{p}");
			Dir.mkdir(p) unless Dir.exists?(p);
		end
	end
end
