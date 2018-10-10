`include "AES_Encrypt.sv"

class aes_monitor_before extends uvm_monitor;
	`uvm_component_utils(aes_monitor_before)

	uvm_analysis_port#(aes_transaction) mon_ap_before;

	virtual aes_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual aes_if)::read_by_name
			(.scope("ifs"), .name("aes_if"), .val(vif)));
		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		integer i = 128,state = 0;

		aes_transaction aes_tx;
		aes_tx = aes_transaction::type_id::create
			(.name("aes_tx"), .contxt(get_full_name()));
	

		forever begin
			@(posedge vif.sig_clock)
			begin
			/* wait for the ready signal, then receive the data*/

				case(state)
				
				0: begin 
					if(vif.sig_ready==1'b1)
					begin 
											/* receiving data state */
								//$display("i: %d, mon state vif rcvd byte: %x",i,vif.out_state_byte);
											
							aes_tx.state_out[i-1 -:8] = vif.out_state_byte;
							i = i - 8;
							if(i<=0)
							begin
								state = 1;
								i = 128;
								//$display("DUT output: %x",aes_tx.state_out);

								//Send the transaction to the analysis port
								mon_ap_before.write(aes_tx);
							end 
					end
				end 
			1:
					begin 
						i = 128;
						if(vif.sig_ready==1'b0)	state = 0;
					end 
				endcase
					
				end
				
			end
		
	endtask: run_phase
endclass: aes_monitor_before

class aes_monitor_after extends uvm_monitor;
	`uvm_component_utils(aes_monitor_after)

	uvm_analysis_port#(aes_transaction) mon_ap_after;

	virtual aes_if vif;

	aes_transaction aes_tx;
	
	//For coverage
	aes_transaction aes_tx_cg;

	//Define coverpoints
	covergroup aes_cg;	
      		state_cp:     coverpoint aes_tx_cg.state;
      		key_cp:     coverpoint aes_tx_cg.key;
		cross state_cp, key_cp;

	endgroup: aes_cg

	function new(string name, uvm_component parent);
		super.new(name, parent);
		aes_cg = new;
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual aes_if)::read_by_name
			(.scope("ifs"), .name("aes_if"), .val(vif)));
		mon_ap_after= new(.name("mon_ap_after"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		integer state=0,i=128;
		aes_tx = aes_transaction::type_id::create
			(.name("aes_tx"), .contxt(get_full_name()));

		forever begin
			@(negedge vif.sig_clock)
			begin
			
				case(state)
				0:
					begin 
						aes_tx.state[i-1 -: 8] = vif.in_state_byte;
						aes_tx.key[i-1 -:8] = vif.in_key_byte;					
					if(vif.sig_enable == 1'b1)
					begin
							i = i - 8;
						 if( vif.sig_load == 1'b1)
						 begin 
							i = 112;
							state = 1;
						end 
						if(i<=0)
						begin
						 i = 128;
						end 
					end else i = 128; 
					end
				1:
				begin 
					aes_tx.state[i-1 -: 8] = vif.in_state_byte;
					aes_tx.key[i-1 -:8] = vif.in_key_byte;
					i = i - 8;
					if(i<=0)
					begin
						state = 2;
						i = 128;

						//Predict the result
						predictor();
						aes_tx_cg = aes_tx;

						//Coverage
						aes_cg.sample();
						

						//Send the transaction to the analysis port
						mon_ap_after.write(aes_tx);
					end
					
				end 
				2: begin 
					if ( vif.sig_load == 1'b0) state = 0;
				end 
				endcase
			end

		end
			

		endtask: run_phase

	virtual function void predictor();
	/* call encrypt function from the SV class .-. */

		AES_ENC PredictEnc; 
		PredictEnc = new; 
		PredictEnc.state = aes_tx.state;
		PredictEnc.key =  aes_tx.key;

		PredictEnc.encrypt();

		aes_tx.state_out = PredictEnc.state_out;

	endfunction: predictor
endclass: aes_monitor_after
