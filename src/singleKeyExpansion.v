/*
*
*
*	Date: September 2018
*
* Description: Expand only a single key in AES encryption/Decryption.
* Language: Verilog
*
*/
module singleKeyExpansion( 
  input  [127:0] keyInput ,
	input clk,
	input enable,
	input reset,
	input [3:0] keyNum,
  output  reg [127:0] keyOutput
  );
    wire [31:0] stp1 ;
  wire [31:0] stp2 ;
  wire [31:0]Rcon ;
    

 	 rcon uut1 (.r(keyNum),.rcon(Rcon));
   subByte uut2 (.state(stp1) , .state_out(stp2));
	 
    assign stp1 = { keyInput[23:0] , keyInput[31:24] }; 
	
    initial keyOutput = 0;
    always @(posedge clk) 
     begin
        if ( reset == 1 )
        begin 
        keyOutput = 0;
            /* donothing */
        end 
        else 
        begin 
            if(enable)
                begin 
                    keyOutput[127:96] = keyInput[127:96] ^ stp2 ^ Rcon; 	
                    keyOutput[95:64] = keyInput[95:64] ^ keyOutput[127:96];
                    keyOutput[63:32] = keyInput[63:32] ^ keyOutput[95:64];
                    keyOutput[31:0] = keyInput[31:0] ^ keyOutput[63:32];
                end
        end 
    end

/* 
// This requires two cycles for the output to be settled 

    wire [127:0] keyOutComb;
    assign keyOutComb[127:96] = keyInput[127:96] ^ stp2 ^ Rcon; 	
    assign keyOutComb[95:64] = keyInput[95:64] ^ keyOutput[127:96];
    assign keyOutComb[63:32] = keyInput[63:32] ^ keyOutput[95:64];
    assign keyOutComb[31:0] = keyInput[31:0] ^ keyOutput[63:32];

    initial keyOutput = 0;
    
    always @(posedge clk) 
     begin
        if ( reset == 1 )
        begin 
        keyOutput= 0;
            // donothing 
        end 
        else 
            if(enable)
                keyOutput <= keyOutComb;
    end
*/


endmodule

