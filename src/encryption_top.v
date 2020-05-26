/*
*
*   Author: Ahmad Hegazy <https://github.com/ahegazy>
*	Date: September 2018
*   FORMAL: MAY 2020
*
* Description: AES Encryption Top module using FSM to move around the processes' steps.
* Language: Verilog
*
*/
module AES_encryption
(
input [7:0] key_byte, state_byte,
input clk,rst,enable,
output reg [7:0] state_out_byte,
output reg load,ready
);

	integer i,j;
	reg [1:0] fsmCount;
	reg [1:0] fsmState;
	reg [127:0] key, state; /* input */
	reg enRound,enShft,enMx,enKy;
	wire fRound,fshft,fMx;
	reg  finish;
	reg [127:0] state_transI,state_transO;
	reg [127:0] key_transI;
	wire [127:0] key_transO,state_RoundO,state_subByteO,state_ShiftO,state_MixO;
	reg [3:0] keyNum;
	reg loadFinish;

	AddRoundKey S(.key(key_transI),.state(state_transI),.clk(clk),.rst(rst),.enable(enRound),.state_out(state_RoundO),.done(fRound));

  genvar itr;
	generate
		for (itr = 0 ; itr <= 127; itr = itr+32)
			subByte statSub (.state(state_RoundO[itr +:32]) , .state_out(state_subByteO[itr +:32]));
	endgenerate
	
	Shift_Rows Sft (.en(enShft),.clk(clk),.rst(rst),.Data(state_subByteO),.Shifted_Data(state_ShiftO),.done(fshft) );
	MixColumns M (.state(state_transI),.clk (clk),.enable(enMx), .rst(rst),.state_out(state_MixO),.done(fMx));

	singleKeyExpansion k ( .keyInput(key_transI),.clk (clk),.enable(enKy),.reset (rst),.keyNum (keyNum),.keyOutput(key_transO));


    initial load <= 1'b0;
    initial ready <= 1'b0;
    initial state_out_byte <= 8'h00;


    // 1st FSM (fsmState) for 
    // state 0 : wait for the enable signal 
    // state 1 : recieving the data,key byte by byte and store them in a 128 bit registers 
    // state 2 : send the ready signal when finish
    // state 3 : send the data out byte by byte
always @(posedge clk)
	begin 
		if (rst) 
		begin
			loadFinish <= 0;
			key<=128'd0;
			state<=128'd0;
			load<=1'd0;
			ready<=1'd0;
			i <= 128;
			state_out_byte <= 8'h00;
			j <= 128; 
			fsmState <= 0 ;
		end 
		else if (enable) 
		begin

		case(fsmState)
			0:
			begin 
				/* state zero, the enable signal arrived, begin recieving data */
				fsmState <= 1;
				i <= 128;
                loadFinish <= 0;
			end 
			1:
			begin 
				/* receivng data 1 byte at a cycle */
				if (i>0) begin				
					load<=1'd1; /* send the load signal then begin loading next cycle*/
					loadFinish <= 0;
					key[i-1 -: 8]<=key_byte;
					state[i-1 -: 8]<=state_byte;
					i<=i-8;				
				end 
				else  
					begin 
					/* loading data finished go to state 2, processing */
					load<=1'd0;
					loadFinish <= 1;
					fsmState <= 2; 
					end
			end
			2: begin 
				/* processing data, wait for finish signal */
					if(finish)
					begin
					/* send ready signal, then go to state three sending output bytes */
						ready <= 1;
						fsmState <= 3;
						j <= 128;
					end else 
                        begin
                            ready <= 0;
                            fsmState <= 2; 
                        end
			end 
			3: begin
						/* state 3 send encrypted data byte by byte .. */
						if ( j > 0)
						begin 
							ready <= 1; 
							state_out_byte <= state_transO [j-1 -: 8]; 
							j <= j - 8;
						end 
						else begin 
								/* encryption finished, go to state 0 */
								ready <= 0;
								fsmState <= 0;
						end 
			end 
			
			endcase
		end else fsmState <= 0; /* end if enable */
end 



    // 2nd FSM (fsmCount) for running the encryption 10 cycles (provide inputs and enable signals to the modules )  
    // state 0 : wait for the load finish signal to come then run the 1st AddroundKey key 0 
    // state 1 : run shift rows 
    // state 2 : run mix columns 
    // state 3 : run AddRoundKey for the rest of the steps

    // I store a counter of the key number calculated in keyNum register
    // When it reaches 11, then we finished all the steps
    // produce the output

    initial 
    begin 
		keyNum <= 0;
		fsmCount <= 0;
		enMx <= 0;
		enKy <= 0;
		enRound <= 0;
		enShft <= 0;
		state_transO <= 0;
		finish <= 0;
	end
always @(posedge clk)
	begin 
	if (rst)
	begin 
		keyNum <= 0;
		fsmCount <= 0;
		enMx <= 0;
		enKy <= 0;
		enRound <= 0;
		enShft <= 0;
		state_transO <= 0;
		finish <= 0;
	end
	else if( (enable == 1 ) && (loadFinish == 1))
	begin 
			if ( keyNum <= 11 )
			begin 
		/* get here only if the device is enabled and not loading */
			/* FSM */
			case (fsmCount)
				2'b00:
					begin 
					/* round 0 AddroundKey only .. */
							key_transI <= key;
							state_transI <= state;
							keyNum <= 4'h1;
							enRound <= 1;
                            enMx <= 0; // disable mix column 
                            enShft <= 0; // disalbe shift rows
							enKy <= 1; // enable key expansion to do the 1st key expansion 
							fsmCount <= 2'b01;
							finish <= 0;
					end 
				2'b01:
					begin 
					/* round 1 shiftrows */
						if (fRound == 1)
						begin
							state_transI <= state_RoundO;
							key_transI <= key_transO;
							enKy <= 0;
							enRound <= 0;
							enShft <= 1;
							if ( keyNum < 10)  fsmCount <= 2'b10; // if we reached the last cycle don't mix columns
							else fsmCount <= 2'b11; // go to addRoundKey directly 
						end 			
						finish <= 0;
					end 
				2'b10:
				begin
					/* round 1 MixColumns */
						if (fshft == 1)
						begin
							state_transI <= state_ShiftO;
							enShft <= 0;
							enMx <= 1;
							fsmCount <= 2'b11;
						end 
						finish <= 0;
				end 
				2'b11:
				begin 
					/* round AddroundKey */
						if (fMx == 1 || (fshft == 1 && keyNum >= 10))
						begin
						  if(keyNum < 10) state_transI <= state_MixO;
							else 	state_transI <= state_ShiftO;
							enMx <= 0;
							enShft <= 0;
							enKy <= 1;
							enRound <= 1;
							fsmCount <= 2'b00; // return to state 0 wait for the load signal
							keyNum <= keyNum + 1;
						end 
						finish <= 0;
				end 
//				default: 
				endcase 		
				end 
				else 
				begin 
					/* keyNum > 10 */
					state_transO <= state_RoundO;
					finish <= 1;
					keyNum <= 0;
					fsmCount <= 0;
					enMx <= 0;
					enKy <= 0;
					enRound <= 0;
					enShft <= 0;
				end 
		end else 
		begin
			keyNum <= 0;
			fsmCount <= 0;
			enMx <= 0;
			enKy <= 0;
			enRound <= 0;
			enShft <= 0;
			state_transO <= 0;
			finish <= 0;
		end
		

		end 


`ifdef FORMAL

    reg f_past_valid; // to know if the $past value is valid to process
    initial f_past_valid = 0;

    initial assume(rst);


    always @(posedge clk)
        f_past_valid = 1;

    // sync reset
    // the design starts at reset state so if no f_past_valid it should be on reset
    // if the past cycle had reset then it should be in reset state
    always @(posedge clk)
        if(!f_past_valid || $past(rst))
        begin
            assert(state_out_byte == 8'd0);
            assert(load == 1'b0);
            assert(ready == 1'b0);
        end


    // sync enable

    // enable signal should be up for the circuit to work  
    always @(posedge clk)
        assume(enable);
 
    // assume never reset 
//    always @(posedge clk)
//        assume(!rst);

    // check that not all modules enabled at the same time 
    always @(*)
        if(enRound)
        begin
            assert(!enShft);
            assert(!enMx);
        end
    
    always @(*)
        if(enMx)
        begin
            assert(!enRound);
            assert(!enShft);
        end
    
    always @(*)
        if(enShft)
        begin
            assert(!enRound);
            assert(!enMx);
        end
    
    // when finish check if the ready flag is raised for the out to receive the data
    always @(posedge clk)
        if(f_past_valid && $past(finish) == 1'b1 && !$past(rst))
            assert(ready);


/*
    // assume an intermediate state after getting the inputs
    (* anyconst *) wire [127:0] keyInt;
    (* anyconst *) wire [127:0] stateInt;

    reg stateAssumed;
    initial stateAssumed = 0;

    always @(posedge clk)
        if(f_past_valid)
        begin
            assume(key == keyInt);
            assume(state == stateInt);
        end
    always @(posedge clk)
        if(f_past_valid && !stateAssumed)
        begin
            //assume(load==1'b0);
            assume(loadFinish == 1'b1);
            assume(fsmState == 2'd2);
            stateAssumed <= 1'b1;
        end
*/
    // maximum generated keys 10
    always @(*)
        assert(keyNum <= 12);


    //key num should be increased by 1
    // each time single key expansion module is enabled (enKy) the keyNum must be increased by one
    always @(posedge clk)
        if(f_past_valid && keyNum > 0 && $rose(enKy) && !$past(rst))
            assert(keyNum == $past(keyNum)+1);
`endif


endmodule
