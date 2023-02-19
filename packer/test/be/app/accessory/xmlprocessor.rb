
class MarkDB ##{

	attr_accessor :currentLevel;
	attr :markScope;
	## attr :markvals;
	@@markvals={};

	def db ##{
		return @@markvals;
	end ##}

	def initialize l1mark ##{
		@currentLevel = 1;
		@markScope = l1mark;
		## @markvals = {};
	end ##}
	def addMarkLevel m ##{
		@markScope += "-#{m}";
		@currentLevel += 1;
	end ##}
	def decMarkLevel ##{
		@currentLevel -= 1;
		@markScope.sub!(/-\S+/,'');
	end ##}
	def addValue val ##{
		if not @@markvals.has_key?(@markScope)
			@@markvals[@markScope] = [];
		end
		@@markvals[@markScope] << val;
	end ##}

end ##}
class XmlProcessor ##{
	## format of marks: marks[<mark>] = <level>
	attr :markdbs;
	attr :envvars;

	def initialize
		@markdbs = [];
		@envvars = {};
	end

	def setenv(var,val)
		@envvars[var.to_s] = val.to_s;
	end
	def flush(fn)
		fh = File.open(fn,'w');
		fh.write("<env>\n");
		@envvars.each_pair do |var,val|
			val = val+':$PATH' if var=='PATH';
			fh.write("\t<var>#{var}</var>\n");
			fh.write("\t<val>#{val}</val>\n");
		end
		fh.write("</env>\n");
		fh.close();
	end

	def __markstart__ cnt ##{
		ptrn = Regexp.new(/<(\w+)>/);
		md = ptrn.match(cnt);
		return '' if md==nil;
		return md[1];
	end ##}
	def __markend__ cnt ##{
		ptrn = Regexp.new(/<\/(\w+)>/);
		md = ptrn.match(cnt);
		return '' if md==nil;
		return md[1];
	end ##}
	def __onelinemark__ cnt ##{
		ptrn = Regexp.new(/<\w+>(\S+)<\/\w+>/);
		md = ptrn.match(cnt);
		return '' if md==nil;
		return md[1];
	end ##}

	def loadSource f ##{{{
		return if not File.exists?(f);
		fp = File.open(f,'r');
		cnts = fp.readlines();
		md = nil;
		cnts.each do |raw|
			raw.chomp!;
			mark = __markstart__(raw)
			if mark!='' ##{
				if md==nil
					md=MarkDB.new(mark);
				else
					md.addMarkLevel(mark);
				end
				value = __onelinemark__(raw)
				if value!=''
					md.addValue(value);
					md.decMarkLevel();
				end
				next; ## markstart process done
			end ##}
			if __markend__(raw)
				if md.currentLevel()==1
					@markdbs<<md;
					md = nil;
				else
					md.decMarkLevel();
				end
				next;
			end
		end
	end ##}}}

	def __getmarkvals__ scope ##{{{
		return nil if @markdbs.empty?;
		@markdbs[0].db.each_pair do |s,vals|
			next if s!=scope;
			if vals.empty?
				return nil;
			else
				return vals;
			end
		end
	end ##}}}
	## the markscope exists and values not empty
	def has markscope ##{{{
		vals = __getmarkvals__ markscope;
		if vals!=nil
			return true;
		else
			return false;
		end
	end ##}}}

	def pop markscope ##{{{
		vals = __getmarkvals__ markscope;
		return '' if vals==nil;
		return vals.shift();
	end ##}}}

end ##}
