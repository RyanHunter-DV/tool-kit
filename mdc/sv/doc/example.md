svclass 'RhAhb5MstDriver','RhDriverBase#(REQ,RSP)' do
	tparam 'REQ','RhAhb5ReqTrans'
	tparam 'RSP','RhAhb5RspTrans'
	# normal field
	field 'uvm_analysis_port#(REQ)'=>'reqP',
		'int'=>'outstandingData'

	# field that can be registered to uvm_field_object
	object 'RhAhb5MstConfig','config'
	task 'virtual','mainProcess' do
		code <<-CODE.gsub(/\s+-/,'')
			-fork
			-	startSeqProcess();
			-	startAddressPhaseThread();
			-	startDataPhaseThread();
			-join
		CODE
	end
	# extra build information
	build do
	end
end
