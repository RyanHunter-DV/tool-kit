`ifndef exampleDriver__svh
`define exampleDriver__svh

class exampleDriver#(type REQ=uvm_sequence_item,RSP=REQ) extends uvm_driver#(REQ,RSP);
	`uvm_component_utils_begin(<classname>)
	`uvm_component_utils_end
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask
endclass

`endif
