module AES_encryption
(
input [7:0] key_byte, state_byte,
input reg clk,rst,enable, 
output reg [7:0] state_out_byte,
output reg load,ready
);

	integer i,j;
	reg [127:0] key, state; /* input */
	reg en0;

/*
	
//	 To generate 
	wire [127:0] state_stages [39:0];
	wire [127:0] key_stages [10:1];
	wire [40:1] en;
	wire [3:0] keyNum;
*/	
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
			en0<= 0;
		end 
		else if (enable) 
		begin
			
//Bytes to vector// 
/////////////////////////
			if (i>0) begin
				load<=1'd1;
				key[i-1 -: 8]<=key_byte;
				state[i-1 -: 8]<=state_byte;
				$display ("%b", key);
				i<=i-8;
			end 
			else  
				begin 
				load<=1'd0;
				en0 <= 1;
				end

		end 
	end 

	wire [127:0] key_1,key_2,key_3,key_4,key_5,key_6,key_7,key_8,key_9,key_10; /* key stages */
	/* states */
	wire [127:0]state_0,state_1,state_2,state_3,state_4,state_5,state_6,state_7,state_8,state_9;
	wire [127:0]state_10,state_11,state_12,state_13,state_14,state_15,state_16,state_17,state_18,state_19;
	wire [127:0]state_20,state_21,state_22,state_23,state_24,state_25,state_26,state_27,state_28,state_29;
	wire [127:0]state_30,state_31,state_32,state_33,state_34,state_35,state_36,state_37,state_38,state_39;

	/* enable wires */
	// reg en0;
	wire en1,en2,en3,en4,en5,en6,en7,en8,en9,en10,en11,en12,en13,en14,en15,en16,en17,en18,en19,en20; 
	wire en21,en22,en23,en24,en25,en26,en27,en28,en29,en30,en31,en32,en33,en34,en35,en36,en37,en38,en39,en40; 
	/****************************************************/

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
	AddRoundKey S3(.key(key_3),.state(state_11),.clk(clk),.rst(rst),.enable(en12),.state_out(state_12),.load(load),.done(en13));
	
	
	/* 4th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub4 (.state(state_12[itr +:32]) , .state_out(state_13[itr +:32]));
	endgenerate

	Shift_Rows Sft4 (.en(en13),.clk(clk),.rst(rst),.Data(state_13),.Shifted_Data(state_14),.done(en14) );	
	MixColumns M4 (.state(state_14),.clk (clk),.enable(en14), .rst(rst),.state_out(state_15),.done(en15));
	singleKeyExpansion key4 ( .keyInput(key_3),.clk (clk),.enable(en15),.reset (rst),.keyNum (4'h4),.keyOutput(key_4),.done(en16));
	AddRoundKey S4(.key(key_4),.state(state_15),.clk(clk),.rst(rst),.enable(en16),.state_out(state_16),.load(load),.done(en17));
	
	/* 5th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub5 (.state(state_16[itr +:32]) , .state_out(state_17[itr +:32]));
	endgenerate

	Shift_Rows Sft5 (.en(en17),.clk(clk),.rst(rst),.Data(state_17),.Shifted_Data(state_18),.done(en18) );	
	MixColumns M5 (.state(state_18),.clk (clk),.enable(en18), .rst(rst),.state_out(state_19),.done(en19));
	singleKeyExpansion key5 ( .keyInput(key_4),.clk (clk),.enable(en19),.reset (rst),.keyNum (4'h5),.keyOutput(key_5),.done(en20));
	AddRoundKey S5(.key(key_5),.state(state_19),.clk(clk),.rst(rst),.enable(en20),.state_out(state_20),.load(load),.done(en21));
	
	/* 6th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub6 (.state(state_20[itr +:32]) , .state_out(state_21[itr +:32]));
	endgenerate

	Shift_Rows Sft6 (.en(en21),.clk(clk),.rst(rst),.Data(state_21),.Shifted_Data(state_22),.done(en22) );	
	MixColumns M6 (.state(state_22),.clk (clk),.enable(en22), .rst(rst),.state_out(state_23),.done(en23));
	singleKeyExpansion key6 ( .keyInput(key_5),.clk (clk),.enable(en23),.reset (rst),.keyNum (4'h6),.keyOutput(key_6),.done(en24));
	AddRoundKey S6(.key(key_6),.state(state_23),.clk(clk),.rst(rst),.enable(en24),.state_out(state_24),.load(load),.done(en25));
	
	/* 7th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub7 (.state(state_24[itr +:32]) , .state_out(state_25[itr +:32]));
	endgenerate

	Shift_Rows Sft7 (.en(en25),.clk(clk),.rst(rst),.Data(state_25),.Shifted_Data(state_26),.done(en26) );	
	MixColumns M7 (.state(state_26),.clk (clk),.enable(en26), .rst(rst),.state_out(state_27),.done(en27));
	singleKeyExpansion key7 ( .keyInput(key_6),.clk (clk),.enable(en27),.reset (rst),.keyNum (4'h7),.keyOutput(key_7),.done(en28));
	AddRoundKey S7(.key(key_7),.state(state_27),.clk(clk),.rst(rst),.enable(en28),.state_out(state_28),.load(load),.done(en29));
	
	/* 8th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub8 (.state(state_28[itr +:32]) , .state_out(state_29[itr +:32]));
	endgenerate

	Shift_Rows Sft8 (.en(en29),.clk(clk),.rst(rst),.Data(state_29),.Shifted_Data(state_30),.done(en30) );	
	MixColumns M8 (.state(state_30),.clk (clk),.enable(en30), .rst(rst),.state_out(state_31),.done(en31));
	singleKeyExpansion key8 ( .keyInput(key_7),.clk (clk),.enable(en31),.reset (rst),.keyNum (4'h8),.keyOutput(key_8),.done(en32));
	AddRoundKey S8(.key(key_8),.state(state_31),.clk(clk),.rst(rst),.enable(en32),.state_out(state_32),.load(load),.done(en33));
	
	/* 9th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub9 (.state(state_32[itr +:32]) , .state_out(state_33[itr +:32]));
	endgenerate

	Shift_Rows Sft9 (.en(en33),.clk(clk),.rst(rst),.Data(state_33),.Shifted_Data(state_34),.done(en34) );	
	MixColumns M9 (.state(state_34),.clk (clk),.enable(en34), .rst(rst),.state_out(state_35),.done(en35));
	singleKeyExpansion key9 ( .keyInput(key_8),.clk (clk),.enable(en35),.reset (rst),.keyNum (4'h9),.keyOutput(key_9),.done(en36));
	AddRoundKey S9(.key(key_9),.state(state_35),.clk(clk),.rst(rst),.enable(en36),.state_out(state_36),.load(load),.done(en37));
	
	/* 10th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub10 (.state(state_36[itr +:32]) , .state_out(state_37[itr +:32]));
	endgenerate

	Shift_Rows Sft10 (.en(en37),.clk(clk),.rst(rst),.Data(state_37),.Shifted_Data(state_38),.done(en38) );	
	singleKeyExpansion key10 ( .keyInput(key_9),.clk (clk),.enable(en38),.reset (rst),.keyNum (4'ha),.keyOutput(key_10),.done(en39));
	AddRoundKey S10(.key(key_10),.state(state_38),.clk(clk),.rst(rst),.enable(en39),.state_out(state_39),.load(load),.done(en40));	

		// state_39 to bytes to out  + ready signal  @ en40 = 1 ..  

		always @(posedge clk)
		begin 
			if (rst) 
			begin
				state_out_byte <= 8'h00;
				j <= 0; 
			end 
			else if (enable) 
			begin
				if(en40)
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


/***************************************************/
	/*	
		// Rounds 
  genvar itr;
	genvar jtr;

	AddRoundKey S0(.key(key),.state(state),.clk(clk),.rst(rst),.enable(en0),.state_out(state_stages[0]),.load(load),.done(en[1]));

	// 1st round 

	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub1 (.state(state_stages[0][itr +:32]) , .state_out(state_stages[1][itr +:32]));
	endgenerate
	
	Shift_Rows Sft1 (.en(en[1]),.clk(clk),.rst(rst),.Data(state_stages[1]),.Shifted_Data(state_stages[2]),.done(en[2]) );
	MixColumns M1 (.state(state_stages[2]),.clk (clk),.enable(en[2]), .rst(rst),.state_out(state_stages[3]),.done(en[3]));
	singleKeyExpansion key1 ( .keyInput(key),.clk (clk),.enable(en[3]),.reset (rst),.keyNum (4'h1),.keyOutput(key_stages[1]),.done(en[4]));
	AddRoundKey S1(.key(key_stages[1]),.state(state_stages[3]),.clk(clk),.rst(rst),.enable(en[4]),.state_out(state_stages[4]),.load(load),.done(en[5]));
  //////  rest .. 
	
	generate

	for (jtr = 1 ; jtr <= 8; jtr = jtr+32)
	begin 
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSubr (.state(state_stages[(jtr * 4)][itr +:32]) , .state_out(state_stages[(jtr * 4) + 1 ][itr +:32]));

	Shift_Rows Sftr (.en(en[(jtr * 4) + 1 ]),.clk(clk),.rst(rst),.Data(state_stages[(jtr * 4) +1 ]),.Shifted_Data(state_stages[(jtr * 4) + 2 ]),.done(en[(jtr * 4) + 2]) );
	MixColumns Mr (.state(state_stages[(jtr * 4) + 2 ]),.clk (clk),.enable(en[(jtr * 4)+2]), .rst(rst),.state_out(state_stages[(jtr * 4)  + 3 ]),.done(en[(jtr * 4)+3]));
	assign keyNum = jtr + 1;
	singleKeyExpansion keyr ( .keyInput(key_stages[jtr]),.clk (clk),.enable(en[(jtr * 4)+3]),.reset (rst),.keyNum (keyNum),.keyOutput(key_stages[jtr+1]),.done(en[(jtr * 4)+4]));
	AddRoundKey Sr(.key(key_stages[jtr+1]),.state(state_stages[(jtr * 4) + 3]),.clk(clk),.rst(rst),.enable(en[(jtr * 4)+4]),.state_out(state_stages[(jtr * 4) + 4]),.load(load),.done(en[(jtr * 4)+5]));

	end 
	endgenerate


		// 10th round 
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub10 (.state(state_stages[36][itr +:32]) , .state_out(state_stages[37][itr +:32]));
	endgenerate


	Shift_Rows Sft10 (.en(en[37]),.clk(clk),.rst(rst),.Data(state_stages[37]),.Shifted_Data(state_stages[38]),.done(en[38]) );	
	singleKeyExpansion key10 ( .keyInput(key_stages[9]),.clk (clk),.enable(en[38]),.reset (rst),.keyNum (4'ha),.keyOutput(key_stages[10]),.done(en[39]));
	AddRoundKey S10(.key(key_stages[10]),.state(state_stages[38]),.clk(clk),.rst(rst),.enable(en[39]),.state_out(state_stages[39]),.load(load),.done(en[40]));	

	
	
	// state_stages[39] to bytes to out  + ready signal  @ en[40] = 1 ..  

		always @(posedge clk)
		begin 
			if (rst) 
			begin
				state_out_byte <= 8'h00;
				j <= 0; 
			end 
			else if (enable) 
			begin
				if(en[40])
				begin
					if ( j < 128)
					begin 
						ready <= 1; 
						state_out_byte <= state_stages[39] [j +: 8]; 
						j <= j + 8;
					end
					else 
						ready <= 0;
				end 
			end 
		end 
		*/
		
endmodule

	
	
