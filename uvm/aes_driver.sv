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

		integer cycle = 0,FSMstate = 0,i=128;
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
				FSMstate = 0;
				// `uvm_info("aes_driver", aes_tx.sprint(), UVM_LOW);
			end

			@(posedge vif.sig_clock)
			begin

				case(FSMstate)
					0: begin 
						/* state 0 reset then go to state 1*/
						vif.sig_rst = 1'b1;
						vif.sig_enable = 1'b0;
						FSMstate = 1;
						cycle = 2;
					end 
					1: begin 
						/* state 1 send the enable signal */
						vif.sig_rst = 1'b0;
						vif.sig_enable = 1'b1;
						FSMstate = 2;
						i = 128;
					end
				/* state 2 send the 1st byte */
					2: begin
						vif.in_state_byte = aes_tx.state[i-1 -:8]; // send  the 1st element of the array to the DUT
						vif.in_key_byte = aes_tx.key[i-1 -:8];

						i = i-8;
						if(i<=0) FSMstate = 3; /* after sending the whole 128 bit*/
					end
					3: begin
							/* wait for the ready signal */
							if (vif.sig_ready == 1) 
							begin
								i = 0;
								FSMstate = 4;
							end 
					end
					4: begin
							/*wait for the state_out to be received in the monitor then get a new random value */	
								i = i + 8;
								if(i>127)
								begin
									FSMstate = 5;
								end
							end 
					5 : begin
								FSMstate = 0;
								vif.sig_enable = 1'b0;
								cycle = 0;
								seq_item_port.item_done();
					end
				endcase
			end
		end
	
	endtask: drive
endclass: aes_driver
