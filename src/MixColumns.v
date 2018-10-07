/*
*
*	Creator : Ahmad Hegazy <github.com/ahegazy> <ahegazipro@gmail.com>
*
*	Date: October 2018
* 
* Description: Mix columns step in AES encryption/Decryption.
* Language: Verilog
*
*/

module MixColumns
	#(parameter word_size =8 ,array_size =16)
	(
	input wire [word_size*array_size-1:0] state,
	input  clk,enable, rst,
	output reg  [word_size*array_size-1:0]state_out,
	output reg done);

function reg [7:0] MultiplyByTwo;
	input [7:0] x;
	//output [7:0] y;
	begin 
			/* multiplication by 2 is shifting on bit to the left, and if the original 8 bits had a 1 @ MSB, xor the result with 0001 1011*/
			if(x[7] == 1) MultiplyByTwo = (x << 1) ^ 8'h1b;
			else MultiplyByTwo = x << 1; 
	end 	
endfunction

function reg [7:0] MultiplyByThree;
	input [7:0] x;
	//output [7:0] y;
	begin 
			/* multiplication by 3 ,= 01 ^ 10 = (NUM * 01) XOR (NUM * 10) = (NUM) XOR (NUM Muliplication by 2) */
			MultiplyByThree = MultiplyByTwo(x) ^ x;
	end 
endfunction
 
integer i; 
	always@(posedge clk) 
begin
	if (rst)
	begin
		state_out<=128'd0;
		done <= 0;
	end 
	else if (enable)
	begin 
	/*      		 0     1    2     3 
	
							 0    8    16     24 
							 32		40   48     56
							 64   72   80     88
							 96   104  112    120
	*/
			for(i=0;i<=3;i=i+1)
			begin 
				state_out[i*8+:8] <= MultiplyByTwo(state[(i*8)+:8]) ^ MultiplyByThree(state[(i*8 + 32)+:8]) ^ (state[(i*8 + 64)+:8] )^(state[(i*8 + 96)+:8]);
				state_out[(i*8 + 32)+:8] <= state[(i*8)+:8] ^ MultiplyByTwo(state[(i*8 + 32)+:8]) ^ MultiplyByThree(state[(i*8 + 64)+:8] ) ^(state[(i*8 + 96)+:8]);
				state_out[(i*8 + 64)+:8] <= (state[(i*8)+:8]) ^ (state[(i*8 + 32)+:8]) ^ MultiplyByTwo(state[(i*8 + 64)+:8] )^ MultiplyByThree(state[(i*8 + 96)+:8]);
				state_out[(i*8 + 96)+:8] <= MultiplyByThree(state[(i*8)+:8]) ^ (state[(i*8 + 32)+:8]) ^ (state[(i*8 + 64)+:8] )^MultiplyByTwo(state[(i*8 + 96)+:8]);
			end 

			end
end

endmodule
