/*
*
*	Creator : Ahmad Hegazy <github.com/ahegazy> <ahegazipro@gmail.com>
*
*	Date: October 2018
* 
* Description: ShiftRows step in AES encryption/Decryption.
* Language: Verilog
*
*/
module Shift_Rows 
 #(parameter word_size =8 ,array_size =16)(
  input en,clk,rst,
  input  wire  [0:word_size*array_size-1] Data,
	output reg  [0:word_size*array_size-1] Shifted_Data,
	output reg done );
	

always @(posedge clk)
  begin
    if (rst)
		begin
	       Shifted_Data = 128'b0;
				 done = 0;
		end
  else if (en) begin
			/*      
							 0    8    16     24 
							 32		40   48     56
							 64   72   80     88
							 96   104  112    120

							 0    40    80     120
							 32		72    112    24 
							 64   104   16     56
							 96   8    48    88
*/
		/* in the DATA .. the arranging is columns filled 1st  ._. */
		/* column 0 no change */
		Shifted_Data[0+:8] <= Data[0+:8];
		Shifted_Data[32+:8] <= Data[32+:8];
		Shifted_Data[64+:8] <= Data[64+:8];
		Shifted_Data[96+:8] <= Data[96+:8];

		/*2nd column , column 1 , 1 shift down */
		Shifted_Data [8+:8] <= Data[40+:8];
		Shifted_Data [40+:8] <= Data[72+:8];
		Shifted_Data [72+:8] <= Data[104+:8];
		Shifted_Data [104+:8] <= Data[8+:8];
		
		/*3rd column , column 2 , 2 shifts down */
		Shifted_Data [16+:8] <= Data[80+:8];
		Shifted_Data [48+:8] <= Data[112+:8];
		Shifted_Data [80+:8] <= Data[16+:8];
		Shifted_Data [112+:8] <= Data[48+:8];


		/*4th column , column 3 , 3 shifts down */
		Shifted_Data [24+:8] <= Data[120+:8];
		Shifted_Data [56+:8] <= Data[24+:8];
		Shifted_Data [88+:8] <= Data[56+:8];
		Shifted_Data [120+:8] <= Data[88+:8];

		/*
		//	row 0 no change 
		Shifted_Data[0+:32] <= Data[0+:32];
		//	2nd row , row 1 , 1 shift left 
		Shifted_Data [32+:24] <= Data[40+:24];
		Shifted_Data [56+:8] <= Data[32+:8];
		//3rd row , row 2 , 2 shifts left 
		Shifted_Data [64+:16] <= Data[80+:16];
		Shifted_Data [80+:16] <= Data[64+:16];
		//*4th row , row 3 , 3 shifts left 
		Shifted_Data [96+:8] <= Data[120+:8];
		Shifted_Data [104+:24] <= Data[96+:24];
	*/
		done = 1;
	end		
	else done <= 0;
end
endmodule

