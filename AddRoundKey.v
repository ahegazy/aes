module AddRoundKey
	#(parameter word_size =8 ,array_size =16)(
	input reg [word_size*array_size-1:0] key ,
	input reg [word_size*array_size-1:0] state,
	input  clk,enable, rst, load,
	output reg  [word_size*array_size-1:0]state_out);
integer i;

`include "mod.v"


always@(posedge clk)
 begin
 if (rst)
 state_out=128'd0;
 else if (enable) begin 
 
	if (load==0)
for ( i=0; i<=15; i=i+1)
		Mod(key[i*word_size  +:  word_size] ^ state[i*word_size  +:  word_size],state_out[i*word_size  +:  word_size]);
////////////////////////////////////////////////
//$display ("%h", state_out);
end
end
endmodule

