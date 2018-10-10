`include "aes_pkg.sv"
`include "dut/AES_Encrypt_top.v"
`include "aes_if.sv"

module aes_tb_top;
	import uvm_pkg::*;
    import aes_pkg::*;
	
	//Interface declaration
	aes_if vif();

	/*
input [7:0] key_byte, state_byte,
input clk,rst,enable, 
output reg [7:0] state_out_byte,
output reg load,ready
*/
	//Connects the Interface to the DUT
	AES_Encrypt aes(
			.key_byte(vif.in_key_byte),
			.state_byte(vif.in_state_byte),
			.clk(vif.sig_clock),
			.rst(vif.sig_rst),
			.enable(vif.sig_enable),
			.state_out_byte(vif.out_state_byte),
			.load(vif.sig_load),
			.ready(vif.sig_ready)
			);

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual aes_if)::set
			(.scope("ifs"), .name("aes_if"), .val(vif));

		//Executes the test
		run_test();
	end

	//Variable initialization
	initial begin
		vif.sig_clock <= 1'b1;
	end

	//Clock generation
	always
		#5 vif.sig_clock = ~vif.sig_clock;
endmodule
