class aes_driver extends uvm_driver#(aes_transaction);
	`uvm_component_utils(aes_driver)

	virtual aes_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual aes_if)::read_by_name
			(.scope("ifs"), .name("aes_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		drive();
	endtask: run_phase

	virtual task drive();
		aes_transaction aes_tx;

		integer cycle = 0,FSMstate = 0,i=127;
		vif.in_key_byte = 8'b0;
		vif.in_state_byte = 8'b0;
		vif.sig_enable = 1'b0;
		vif.sig_rst = 1'b0;
		
		forever begin
		/* 0: send reset & get next item >> 1: send enable signal and get into FSM */
			if(cycle==0)
			begin
				// get sequencer next random item  ..  
				seq_item_port.get_next_item(aes_tx);
				// `uvm_info("aes_driver", aes_tx.sprint(), UVM_LOW);
			end

			@(posedge vif.sig_clock)
			begin
				if(cycle==0)
				begin
					/* cycle 0 send reset signal */
					vif.sig_rst = 1'b1;
					vif.sig_enable = 1'b0;
					FSMstate = 3;
					
				end

				if(cycle == 1)
				begin 
					vif.sig_rst = 1'b0;
					vif.sig_enable = 1'b1;
					FSMstate = 1;
					i = 128;
				end 
				
				case(FSMstate)
					/* state 1 send the 1st byte */
					1: begin
						cycle = 2;
						vif.in_state_byte = aes_tx.state[i-1 -:8]; // send  the 1st element of the array to the DUT
						vif.in_key_byte = aes_tx.key[i-1 -:8];
						i = i-8;
						if(i<=0) FSMstate = 2; /* after sending the whole 128 bit*/
					end

					2: begin
							if (vif.sig_ready == 1)
							begin 
							/*wait for the received signal to be received in the monitor then get a new random value */	
								i = i + 8;
								if(i>127)
								begin
									FSMstate = 4;
								end
							end else i = 0; /* data isn't ready yet */
					end
					3: begin 
							cycle = 1;
					end 
					4: begin
								FSMstate = 0;
									cycle = 0;
									seq_item_port.item_done();
					end
				endcase
			end
		end
	
	endtask: drive
endclass: aes_driver
