from debugger import *;
from optparse import OptionParser;

print ("get debugEn: ",DebugConfig.debugEn);

class ConfigTable: #{

	_options = None;
	_args = None;

	def __init__(self): #{
		parser = OptionParser();
		parser.add_option('-l',
			action='store_true',
			dest='list',
			default=False,
			help='get recorded files'
		);
		parser.add_option('-r',
			dest='index',
			help='reopen file specified by <index>'
		);
		(self._options,self._args)=parser.parse_args();
	#}


	@debug
	def hasReopen(self): #{
		if self._options.index != None:
			return self._options.index;
		else:
			return False;
	#}

	@debug
	def isListMode(self): #{
		return self._options.list;
	#}

#}
