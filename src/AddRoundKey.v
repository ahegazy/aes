/*
*
*
* Date: September 2018
* Modified : October 2018
* Description: AddRoundKey step in AES encryption/Decryption.
* Language: Verilog
*
*/

module AddRoundKey(
	input wire [127:0] key ,
	input wire [127:0] state,
	input  clk,enable, rst,
	output reg  [127:0]state_out,
	output reg done);

//	integer i;

    // separating the combinational from the sequential 
    wire [127:0] state_out_comb; 
    genvar ii;
    for (ii=0 ;ii<=15; ii=ii+1)
        assign state_out_comb[ii*8 +: 8] = key[ii*8  +:  8] ^ state[ii*8  +:  8];

    initial state_out <= 0;
    initial done <= 0;

    always@(posedge clk)
    begin
        if (rst) begin
            state_out<=128'd0;
            done <= 0;
        end 
        else if (enable) begin 
            //	for ( i=0; i<=15; i=i+1)
            //		state_out[i*8  +:  8] <= key[i*8  +:  8] ^ state[i*8  +:  8];
            state_out <= state_out_comb;
            done <= 1;
        end 
        else done <= 0;
    end

endmodule

