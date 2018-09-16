module AES_encryption
(
input [7:0] key_byte, state_byte,
input reg clk,rst,enable, 
output reg [7:0] state_out_byte,
output reg load,ready
);

	integer i,j;
	reg [127:0] key, state; /* input */
	
	/* To generate */
	wire [127:0] state_stages [39:0];
	wire [127:0] key_stages [10:1];
	wire [40:1] en;
	reg en0;
//	reg done;
//	reg [127:0] state_final;
	wire [3:0] keyNum;
	
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

		end 
	end 

/***************************************************/
	
		/* Rounds */
  genvar itr;
	genvar jtr;

	AddRoundKey S0(.key(key),.state(state),.clk(clk),.rst(rst),.enable(en0),.state_out(state_stages[0]),.load(load),.done(en[1]));

	/* 1st round */

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


		/* 10th round */
  
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub10 (.state(state_stages[36][itr +:32]) , .state_out(state_stages[37][itr +:32]));
	endgenerate


	Shift_Rows Sft10 (.en(en[37]),.clk(clk),.rst(rst),.Data(state_stages[37]),.Shifted_Data(state_stages[38]),.done(en[38]) );	
	singleKeyExpansion key10 ( .keyInput(key_stages[9]),.clk (clk),.enable(en[38]),.reset (rst),.keyNum (4'ha),.keyOutput(key_stages[10]),.done(en[39]));
	AddRoundKey S10(.key(key_stages[10]),.state(state_stages[38]),.clk(clk),.rst(rst),.enable(en[39]),.state_out(state_stages[39]),.load(load),.done(en[40]));	

	
	
	/* state_stages[39] to bytes to out  + ready signal  @ en[40] = 1 ..  */

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
		
		
endmodule

	
	
