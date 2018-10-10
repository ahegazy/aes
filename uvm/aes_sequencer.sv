class aes_transaction extends uvm_sequence_item;

	rand bit[127:0] state;
	rand bit[127:0] key;
	bit[127:0] state_out;

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(aes_transaction)
	
		`uvm_field_int(state, UVM_ALL_ON)
		`uvm_field_int(key, UVM_ALL_ON)
		`uvm_field_int(state_out, UVM_ALL_ON)
	
	`uvm_object_utils_end
endclass: aes_transaction

class aes_sequence extends uvm_sequence#(aes_transaction);
	`uvm_object_utils(aes_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		aes_transaction aes_tx;
		
		repeat(15) begin
		aes_tx = aes_transaction::type_id::create(.name("aes_tx"), .contxt(get_full_name()));

		start_item(aes_tx);
		assert(aes_tx.randomize());
		//`uvm_info("aes_sequence", aes_tx.sprint(), UVM_LOW);
		finish_item(aes_tx);
		end
		
	endtask: body
endclass: aes_sequence

typedef uvm_sequencer#(aes_transaction) aes_sequencer;
