module AES_encryption
(
input [7:0] key_byte, state_byte,
input reg clk,rst,enable, 
output [7:0] state_out_byte,
output reg load,ready
);

integer i;
reg [127:0] key, state; /* input */
reg [127:0] key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10; /* key stages */
initial i=128;
reg [127:0]state_0,state_1,state_2,state_3,state_4,state_5,state_6,state_7,state_8,state_9,state_10; /* states */

always @(posedge clk)
	begin 
		if (rst) 
		begin
			key<=128'd0;
			state<=128'd0;
			load<=1'd0;
			ready<=1'd0;
		end 
		else if (enable) 
		begin

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

	/* 1st round */
  genvar itr;
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub1 (.state(state_0[itr +:32]) , .state_out(state_1[itr +:32]));
	endgenerate
	
	Shift_Rows Sft1 (.en(enable),.clk(clk),.rst(rst),.Data(state_1),.Shifted_Data(state_2) );
	MixColumns M1 (.state(state_2),.clk (clk),.enable(enable), .rst(rst),.state_out(state_3));
	singleKeyExpansion key1 ( .key_0(key),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h01),.key_Out (key_1));
	AddRoundKey S1(.key(key_1),.state(state_3),.clk(clk),.rst(rst),.enable(enable),.state_out(state_4),.load(load));
	
	/* 2nd round */
  genvar itr;
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub2 (.state(state_4[itr +:32]) , .state_out(state_5[itr +:32]));
	endgenerate

	Shift_Rows Sft2 (.en(enable),.clk(clk),.rst(rst),.Data(state_5),.Shifted_Data(state_6) );	
	MixColumns M2 (.state(state_7),.clk (clk),.enable(enable), .rst(rst),.state_out(state_8));
	singleKeyExpansion key2 ( .key_0(key_1),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h02),.key_Out (key_2));
	AddRoundKey S2(.key(key_2),.state(state_9),.clk(clk),.rst(rst),.enable(enable),.state_out(state_10),.load(load));

/* And so on .... */	
	
	
endmodule

	
	