module AES_encryption
(
input [7:0] key_byte, state_byte,
input reg clk,rst,enable, 
output [7:0] state_out_byte,
output reg load,ready
);

integer i;
reg [127:0] key, state; /* input */
initial i=128;

	wire [127:0] key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10; /* key stages */
	/* states */
	wire [127:0]state_0,state_1,state_2,state_3,state_4,state_5,state_6,state_7,state_8,state_9;
	wire [127:0]state_10,state_11,state_12,state_13,state_14,state_15,state_16,state_17,state_18,state_19;
	wire [127:0]state_20,state_21,state_22,state_23,state_24,state_25,state_26,state_27,state_28,state_29;
	wire [127:0]state_30,state_31,state_32,state_33,state_34,state_35,state_36,state_37,state_38,state_39;

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
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub2 (.state(state_4[itr +:32]) , .state_out(state_5[itr +:32]));
	endgenerate

	Shift_Rows Sft2 (.en(enable),.clk(clk),.rst(rst),.Data(state_5),.Shifted_Data(state_6) );	
	MixColumns M2 (.state(state_6),.clk (clk),.enable(enable), .rst(rst),.state_out(state_7));
	singleKeyExpansion key2 ( .key_0(key_1),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h02),.key_Out (key_2));
	AddRoundKey S2(.key(key_2),.state(state_7),.clk(clk),.rst(rst),.enable(enable),.state_out(state_8),.load(load));
	
	/* 3rd round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub3 (.state(state_8[itr +:32]) , .state_out(state_9[itr +:32]));
	endgenerate

	Shift_Rows Sft3 (.en(enable),.clk(clk),.rst(rst),.Data(state_9),.Shifted_Data(state_10) );	
	MixColumns M3 (.state(state_10),.clk (clk),.enable(enable), .rst(rst),.state_out(state_11));
	singleKeyExpansion key3 ( .key_0(key_2),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h03),.key_Out (key_3));
	AddRoundKey S3(.key(key_2),.state(state_11),.clk(clk),.rst(rst),.enable(enable),.state_out(state_12),.load(load));
	
	
	/* 4th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub4 (.state(state_12[itr +:32]) , .state_out(state_13[itr +:32]));
	endgenerate

	Shift_Rows Sft4 (.en(enable),.clk(clk),.rst(rst),.Data(state_13),.Shifted_Data(state_14) );	
	MixColumns M4 (.state(state_14),.clk (clk),.enable(enable), .rst(rst),.state_out(state_15));
	singleKeyExpansion key4 ( .key_0(key_3),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h04),.key_Out (key_4));
	AddRoundKey S4(.key(key_4),.state(state_15),.clk(clk),.rst(rst),.enable(enable),.state_out(state_16),.load(load));
	
	/* 5th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub5 (.state(state_16[itr +:32]) , .state_out(state_17[itr +:32]));
	endgenerate

	Shift_Rows Sft5 (.en(enable),.clk(clk),.rst(rst),.Data(state_17),.Shifted_Data(state_18) );	
	MixColumns M5 (.state(state_18),.clk (clk),.enable(enable), .rst(rst),.state_out(state_19));
	singleKeyExpansion key5 ( .key_0(key_4),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h05),.key_Out (key_5));
	AddRoundKey S5(.key(key_5),.state(state_19),.clk(clk),.rst(rst),.enable(enable),.state_out(state_20),.load(load));
	
	/* 6th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub6 (.state(state_20[itr +:32]) , .state_out(state_21[itr +:32]));
	endgenerate

	Shift_Rows Sft6 (.en(enable),.clk(clk),.rst(rst),.Data(state_21),.Shifted_Data(state_22) );	
	MixColumns M6 (.state(state_22),.clk (clk),.enable(enable), .rst(rst),.state_out(state_23));
	singleKeyExpansion key6 ( .key_0(key_5),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h06),.key_Out (key_6));
	AddRoundKey S6(.key(key_6),.state(state_23),.clk(clk),.rst(rst),.enable(enable),.state_out(state_24),.load(load));
	
	/* 7th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub7 (.state(state_24[itr +:32]) , .state_out(state_25[itr +:32]));
	endgenerate

	Shift_Rows Sft7 (.en(enable),.clk(clk),.rst(rst),.Data(state_25),.Shifted_Data(state_26) );	
	MixColumns M7 (.state(state_26),.clk (clk),.enable(enable), .rst(rst),.state_out(state_27));
	singleKeyExpansion key7 ( .key_0(key_6),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h07),.key_Out (key_7));
	AddRoundKey S7(.key(key_7),.state(state_27),.clk(clk),.rst(rst),.enable(enable),.state_out(state_28),.load(load));
	
	/* 8th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub8 (.state(state_28[itr +:32]) , .state_out(state_29[itr +:32]));
	endgenerate

	Shift_Rows Sft8 (.en(enable),.clk(clk),.rst(rst),.Data(state_29),.Shifted_Data(state_30) );	
	MixColumns M8 (.state(state_30),.clk (clk),.enable(enable), .rst(rst),.state_out(state_31));
	singleKeyExpansion key8 ( .key_0(key_7),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h08),.key_Out (key_8));
	AddRoundKey S8(.key(key_8),.state(state_31),.clk(clk),.rst(rst),.enable(enable),.state_out(state_32),.load(load));
	
	/* 9th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub9 (.state(state_32[itr +:32]) , .state_out(state_33[itr +:32]));
	endgenerate

	Shift_Rows Sft9 (.en(enable),.clk(clk),.rst(rst),.Data(state_33),.Shifted_Data(state_34) );	
	MixColumns M9 (.state(state_34),.clk (clk),.enable(enable), .rst(rst),.state_out(state_35));
	singleKeyExpansion key9 ( .key_0(key_8),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h09),.key_Out (key_9));
	AddRoundKey S9(.key(key_9),.state(state_35),.clk(clk),.rst(rst),.enable(enable),.state_out(state_36),.load(load));
	
	/* 10th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub10 (.state(state_36[itr +:32]) , .state_out(state_37[itr +:32]));
	endgenerate

	Shift_Rows Sft10 (.en(enable),.clk(clk),.rst(rst),.Data(state_37),.Shifted_Data(state_38) );	
	singleKeyExpansion key10 ( .key_0(key_9),.clk (clk),.enable(enable),.reset (rst),.keyNum (4'h0a),.key_Out (key_10));
	AddRoundKey S10(.key(key_10),.state(state_38),.clk(clk),.rst(rst),.enable(enable),.state_out(state_39),.load(load));	
	
	
	
	/* state_39 to bytes to out  + ready signal  ..  */
endmodule

	
	