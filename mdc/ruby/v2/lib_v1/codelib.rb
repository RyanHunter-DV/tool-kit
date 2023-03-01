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
		cmd = %Q|/local_vol1_nobackup/ryanh/Git/codelib/codelib-main/bin/cb-rb -i #{@codeid} -f #{tmpfile},1|;
		out,err,st = Open3.capture3(cmd);
		raise RunException.new("codelib process e
