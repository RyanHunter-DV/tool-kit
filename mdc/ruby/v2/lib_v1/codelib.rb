# <PACKER> - v2/lib_v1/codelib.rb,33204
# support operations for ruby codelib
require 'open3';
class Codelib
	attr :debug;
	attr :codeid;
	attr :codes;
	def initialize(id,d)
		@debug =d;
		@codeid=id;
		getcodes;
	end

	def getcodes
		tmpfile = ".mdc_tmp_#{Process.pid}";
		fh = File.open(tmpfile,'w');fh.close();
		cmd = %Q|cb-rb -i #{@codeid} -f #{tmpfile},1|;
		out,err,st = Open3.capture3(cmd);
		raise RunException.new("codelib process error(codeid: #{@codeid})",5) if st.exitstatus!=0;
		fh = File.open(tmpfile,'r');
		@codes = fh.readlines(); fh.close(); File.delete(tmpfile);
		@codes.map!{|l| l.chomp;};
		return;
	end

	def apio(api,ovrd)
		ovrd.map!{|l| "\t"+l;};
		ovrd.insert(0,"def #{api} ## {{{");
		ovrd << "end ## }}}";
		ptrn = Regexp.new("def +#{api}");
		ncodes=[];
		sindex=0;
		filter=false;
		@codes.each_with_index do |l,i|
			if ptrn.match(l);
				filter=true;
				sindex=i;
			end
			ncodes<<l if not filter;
			if filter
				filter=false if l=="\tend";
			end
		end
		ovrd.map!{|l| "\t"+l;};
		# ovrd.reverse!;
		ncodes.insert(sindex,*ovrd);
		@codes = ncodes;
	end

end
