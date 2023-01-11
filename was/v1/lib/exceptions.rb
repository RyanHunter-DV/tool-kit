rhload 'exceptionbase.rb'
class WasConfigException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=1;
		@eFlag  ='WCE';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
