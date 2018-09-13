module AES_encryption
(
input [7:0] key_byte, state_byte,
input reg clk,rst,enable, 
output [7:0] state_out_byte,
output reg load,ready
);

integer i;
reg [127:0] key, state;
reg [127:0] key_stage;
initial i=128;
wire [127:0]state_0;

always @(posedge clk)
	begin 
if (rst) begin
	key<=128'd0;
	state<=128'd0;
	load<=1'd0;
	ready<=1'd0;
	end 
else if (enable) begin

//Bytes to vector// 
/////////////////////////
	if (i>0) begin
	load=1'd1;
	key[i-1 -: 8]=key_byte;
	state[i-1 -: 8]=state_byte;
	$display ("%b", key);
	i=i-8;
	end 
else  
	load=1'd0;
	/////////////////
//Add Round key//


	end 
end 

AddRoundKey S0(.key(key),.state(state),.clk(clk),.rst(rst),.enable(enable),.state_out(state_0),.load(load));


endmodule

	
	