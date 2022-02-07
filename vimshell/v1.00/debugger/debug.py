class DebugConfig: #{
	debugEn = 0;

	def enableDebug(): #{
		DebugConfig.debugEn = 1;
	#}

#}

def debug(func): #{
	def inner(arg):
		if DebugConfig.debugEn: print ("calling func: ",func);
		return func(arg);
	return inner;
#}
	
