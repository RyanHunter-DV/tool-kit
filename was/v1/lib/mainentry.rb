rhload 'lib/options.rb'
rhload 'lib/gittool.rb'
rhload 'cmdshell.rb'
rhload 'debug.rb'
rhload 'lib/exceptions.rb'
class MainEntry
    attr :option;
	attr :tool;
	attr :importDir;
    def initialize ##{{{
        @option = Options.new();
		@debug  = Debug.new(@option.debug);
		@tool = nil;
		@importDir = 'imports';
    end ##}}}

	def __selectTool__ t ##{{{
		@tool = GitTool.new(@debug) if t==:git;
		return ;
	end ##}}}
	def __setupWorkarea__ path,project ##{{{
		## path = File.join(path,project) if path=='./' or path=='.'
		begin
			rtns = Shell.makedir(path);
			raise ShellException.new("makedir failed(#{rtns[0]})") if rtns[1]!=0;
		rescue ShellException => e
			e.process();
		end
		## return path;
	end ##}}}
	def run ##{{{
		__selectTool__(@option.tool);
		wa = File.join(@option.path,@option.project) if @option.path=='./' or @option.path=='.'
		downloadProjects(wa,@option.project);
		## @tool.download(wa,@option.project);
		## MARKER, consider nested imports?
		return 0;
	end ##}}}

	def __findProjectAnchor__ wa ##{{{
		anchors = Shell.find(wa,'was.anchor','-type f');
		return anchors;
	end ##}}}
	def downloadProjects wa,project ##{{{
		__downloadLocal__(wa,project);
		puts "finding wa.anchor to locate the real project root";
		## do this because in one tree, there might be multiple projects
		anchors = __findProjectAnchor__(wa);
		puts "no wa.anchor found for project(#{project}), no imports will be downloaded" if anchors.empty?;
		anchors.each do |anchor|
			_wa = File.dirname(anchor);
			__downloadImports__(_wa,project);
		end
	end ##}}}

	def __downloadLocal__ wa,project ##{{{
		puts "downloading #{project} into #{wa}";
		__setupWorkarea__(wa,project);
		@tool.download(wa,project);
	end ##}}}
	def __processwasConfig__ wa ##{{{
		"""
		the format of imports:
		imports = []
		imports[<index>] = {:wa=>'',:project=>'',:version=>''};
		"""
		imports = [];
		wasConfig = File.join(wa,"__be__/#{@tool.name}.was");
		fh = nil;
		fh = File.open(wasConfig,'r') if File.exists?(wasConfig);
		if fh != nil
			begin
				cnts = fh.readlines();
				fh.close();
				cnts.each do |cnt|
					imported = {};
					splited = cnt.split(',');
					md = /(\S+)\s*=\s*(\S+)/.match(splited[0]);
					raise WasConfigException.new("syntax error") if md==nil;
					imported[:wa] = File.join(wa,@importDir,md[1]);
					imported[:project] = md[2];
					md = /version\s*=\s*(\S+)/.match(splited[1]);
					raise WasConfigException.new("syntax error") if md==nil;
					imported[:version] = md[1];
					imports << imported;
				end
			rescue WasConfigException => e
				e.process("#{wasConfig} process error, ");
			end
		end
		return imports;
	end ##}}}
	def __buildImportDir__ wa ##{{{
		Shell.makedir(File.join(wa,@importDir));
		return;
	end ##}}}
	def __downloadImports__ wa,project=nil ##{{{
		__buildImportDir__(wa);
		imports = __processwasConfig__(wa);
		imports.each do |imported|
			@debug.print("get imported info:");
			@debug.print("wa: #{imported[:wa]}");
			@debug.print("project: #{imported[:project]}");
			@debug.print("version: #{imported[:version]}");
			downloadProjects(imported[:wa],imported[:project]);
		end
	end ##}}}
end
