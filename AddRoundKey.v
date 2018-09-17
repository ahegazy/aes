module AddRoundKey
	#(parameter word_size =8 ,array_size =16)(
	input wire [word_size*array_size-1:0] key ,
	input wire [word_size*array_size-1:0] state,
	input  clk,enable, rst, load,
	output reg  [word_size*array_size-1:0]state_out,
	output reg done);
integer i,j,k,add;

`include "mod.v"

always@(posedge clk)
 begin
 if (rst) begin
 state_out=128'd0;
 done <= 0;
 end 
 else if (enable) begin 
	for ( i=0; i<=15; i=i+1)
		Mod(key[i*word_size  +:  word_size] ^ state[i*word_size  +:  word_size],state_out[i*word_size  +:  word_size]);
////////////////////////////////////////////////
	done = 1;
end
end
endmodule

