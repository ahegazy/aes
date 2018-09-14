module AES_encryption
(
input [7:0] key_byte, state_byte,
input reg clk,rst,enable, 
output reg [7:0] state_out_byte,
output reg load,ready
);

	integer i,j;
	reg [127:0] key, state; /* input */

	wire [127:0] key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10; /* key stages */
	/* states */
	wire [127:0]state_0,state_1,state_2,state_3,state_4,state_5,state_6,state_7,state_8,state_9;
	wire [127:0]state_10,state_11,state_12,state_13,state_14,state_15,state_16,state_17,state_18,state_19;
	wire [127:0]state_20,state_21,state_22,state_23,state_24,state_25,state_26,state_27,state_28,state_29;
	wire [127:0]state_30,state_31,state_32,state_33,state_34,state_35,state_36,state_37,state_38,state_39;

	/* enable wires */
	reg en0;
	wire en1,en2,en3,en4,en5,en6,en7,en8,en9,en10,en11,en12,en13,en14,en15,en16,en17,en18,en19,en20; 
	wire en21,en22,en23,en24,en25,en26,en27,en28,en29,en30,en31,en32,en33,en34,en35,en36,en37,en38; 
	
initial 
begin 
	i=128;
	j = 0;
end 
	
always @(posedge clk)
	begin 
		if (rst) 
		begin
			key<=128'd0;
			state<=128'd0;
			load<=1'd0;
			ready<=1'd0;
			i <= 128;
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
				begin 
				load=1'd0;
				en0 = 1;
				end 
	/////////////////
//Add Round key//


		end 
	end 


	AddRoundKey S0(.key(key),.state(state),.clk(clk),.rst(rst),.enable(en0),.state_out(state_0),.load(load),.done(en1));

	/* 1st round */
  genvar itr;
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub1 (.state(state_0[itr +:32]) , .state_out(state_1[itr +:32]));
	endgenerate
	
	Shift_Rows Sft1 (.en(en1),.clk(clk),.rst(rst),.Data(state_1),.Shifted_Data(state_2),.done(en2) );
	MixColumns M1 (.state(state_2),.clk (clk),.enable(en2), .rst(rst),.state_out(state_3),.done(en3));

	singleKeyExpansion key1 ( .keyInput(key),.clk (clk),.enable(en3),.reset (rst),.keyNum (4'h1),.keyOutput(key_1),.done(en4));

	AddRoundKey S1(.key(key_1),.state(state_3),.clk(clk),.rst(rst),.enable(en4),.state_out(state_4),.load(load),.done(en5));
	
	/* 2nd round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub2 (.state(state_4[itr +:32]) , .state_out(state_5[itr +:32]));
	endgenerate

	Shift_Rows Sft2 (.en(en5),.clk(clk),.rst(rst),.Data(state_5),.Shifted_Data(state_6),.done(en6) );	
	MixColumns M2 (.state(state_6),.clk (clk),.enable(en6), .rst(rst),.state_out(state_7),.done(en7));
	
	singleKeyExpansion key2 ( .keyInput(key_1),.clk (clk),.enable(en7),.reset (rst),.keyNum (4'h2),.keyOutput(key_2),.done(en8));
	
	AddRoundKey S2(.key(key_2),.state(state_7),.clk(clk),.rst(rst),.enable(en8),.state_out(state_8),.load(load),.done(en9));
	
	/* 3rd round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub3 (.state(state_8[itr +:32]) , .state_out(state_9[itr +:32]));
	endgenerate

	Shift_Rows Sft3 (.en(en9),.clk(clk),.rst(rst),.Data(state_9),.Shifted_Data(state_10),.done(en10) );	
	MixColumns M3 (.state(state_10),.clk (clk),.enable(en10), .rst(rst),.state_out(state_11),.done(en11));
	singleKeyExpansion key3 ( .keyInput(key_2),.clk (clk),.enable(en11),.reset (rst),.keyNum (4'h3),.keyOutput(key_3),.done(en12));
	AddRoundKey S3(.key(key_2),.state(state_11),.clk(clk),.rst(rst),.enable(en12),.state_out(state_12),.load(load),.done(en13));
	
	
	/* 4th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub4 (.state(state_12[itr +:32]) , .state_out(state_13[itr +:32]));
	endgenerate

	Shift_Rows Sft4 (.en(en12),.clk(clk),.rst(rst),.Data(state_13),.Shifted_Data(state_14),.done(en13) );	
	MixColumns M4 (.state(state_14),.clk (clk),.enable(en13), .rst(rst),.state_out(state_15),.done(en14));
	singleKeyExpansion key4 ( .keyInput(key_3),.clk (clk),.enable(en14),.reset (rst),.keyNum (4'h4),.keyOutput(key_4),.done(en15));
	AddRoundKey S4(.key(key_4),.state(state_15),.clk(clk),.rst(rst),.enable(en15),.state_out(state_16),.load(load),.done(en16));
	
	/* 5th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub5 (.state(state_16[itr +:32]) , .state_out(state_17[itr +:32]));
	endgenerate

	Shift_Rows Sft5 (.en(en16),.clk(clk),.rst(rst),.Data(state_17),.Shifted_Data(state_18),.done(en17) );	
	MixColumns M5 (.state(state_18),.clk (clk),.enable(en17), .rst(rst),.state_out(state_19),.done(en18));
	singleKeyExpansion key5 ( .keyInput(key_4),.clk (clk),.enable(en18),.reset (rst),.keyNum (4'h5),.keyOutput(key_5),.done(en19));
	AddRoundKey S5(.key(key_5),.state(state_19),.clk(clk),.rst(rst),.enable(en19),.state_out(state_20),.load(load),.done(en20));
	
	/* 6th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub6 (.state(state_20[itr +:32]) , .state_out(state_21[itr +:32]));
	endgenerate

	Shift_Rows Sft6 (.en(en20),.clk(clk),.rst(rst),.Data(state_21),.Shifted_Data(state_22),.done(en21) );	
	MixColumns M6 (.state(state_22),.clk (clk),.enable(en21), .rst(rst),.state_out(state_23),.done(en22));
	singleKeyExpansion key6 ( .keyInput(key_5),.clk (clk),.enable(en22),.reset (rst),.keyNum (4'h6),.keyOutput(key_6),.done(en23));
	AddRoundKey S6(.key(key_6),.state(state_23),.clk(clk),.rst(rst),.enable(en23),.state_out(state_24),.load(load),.done(en24));
	
	/* 7th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub7 (.state(state_24[itr +:32]) , .state_out(state_25[itr +:32]));
	endgenerate

	Shift_Rows Sft7 (.en(en24),.clk(clk),.rst(rst),.Data(state_25),.Shifted_Data(state_26),.done(en25) );	
	MixColumns M7 (.state(state_26),.clk (clk),.enable(en25), .rst(rst),.state_out(state_27),.done(en26));
	singleKeyExpansion key7 ( .keyInput(key_6),.clk (clk),.enable(en26),.reset (rst),.keyNum (4'h7),.keyOutput(key_7),.done(en27));
	AddRoundKey S7(.key(key_7),.state(state_27),.clk(clk),.rst(rst),.enable(en27),.state_out(state_28),.load(load),.done(en28));
	
	/* 8th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub8 (.state(state_28[itr +:32]) , .state_out(state_29[itr +:32]));
	endgenerate

	Shift_Rows Sft8 (.en(en28),.clk(clk),.rst(rst),.Data(state_29),.Shifted_Data(state_30),.done(en29) );	
	MixColumns M8 (.state(state_30),.clk (clk),.enable(en29), .rst(rst),.state_out(state_31),.done(en30));
	singleKeyExpansion key8 ( .keyInput(key_7),.clk (clk),.enable(en30),.reset (rst),.keyNum (4'h8),.keyOutput(key_8),.done(en31));
	AddRoundKey S8(.key(key_8),.state(state_31),.clk(clk),.rst(rst),.enable(en31),.state_out(state_32),.load(load),.done(en32));
	
	/* 9th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub9 (.state(state_32[itr +:32]) , .state_out(state_33[itr +:32]));
	endgenerate

	Shift_Rows Sft9 (.en(en32),.clk(clk),.rst(rst),.Data(state_33),.Shifted_Data(state_34),.done(en33) );	
	MixColumns M9 (.state(state_34),.clk (clk),.enable(en33), .rst(rst),.state_out(state_35),.done(en34));
	singleKeyExpansion key9 ( .keyInput(key_8),.clk (clk),.enable(en34),.reset (rst),.keyNum (4'h9),.keyOutput(key_9),.done(en35));
	AddRoundKey S9(.key(key_9),.state(state_35),.clk(clk),.rst(rst),.enable(en35),.state_out(state_36),.load(load),.done(en36));
	
	/* 10th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub10 (.state(state_36[itr +:32]) , .state_out(state_37[itr +:32]));
	endgenerate

	Shift_Rows Sft10 (.en(en36),.clk(clk),.rst(rst),.Data(state_37),.Shifted_Data(state_38),.done(en37) );	
	singleKeyExpansion key10 ( .keyInput(key_9),.clk (clk),.enable(en37),.reset (rst),.keyNum (4'ha),.keyOutput(key_10),.done(en38));
	AddRoundKey S10(.key(key_10),.state(state_38),.clk(clk),.rst(rst),.enable(en38),.state_out(state_39),.load(load),.done(en39));	
	
	
	
	/* state_39 to bytes to out  + ready signal  @ en39 = 1 ..  */

		always @(posedge clk)
		begin 
			if (rst) 
			begin
				state_out_byte <= 8'h00;
				j <= 0; 
			end 
			else if (enable) 
			begin
				if(en39)
				begin
					if ( j < 128)
					begin 
						ready <= 1; 
						state_out_byte <= state_39 [j +: 8]; 
						j <= j + 8;
					end
					else 
						ready <= 0;
				end 
			end 
		end 
endmodule

	
	
