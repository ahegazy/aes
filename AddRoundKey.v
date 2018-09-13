module AddRoundKey
	#(parameter word_size =8 ,array_size =16)(
	input reg [word_size*array_size-1:0] key ,
	input reg [word_size*array_size-1:0] state,
	input  clk,enable, rst, load,
	output reg  [word_size*array_size-1:0]state_out);
integer i,j,k,add;

`include "mod.v"
reg [word_size*array_size-1:0]key_modified;

always@(posedge clk)
 begin
 if (rst) begin
 state_out=128'd0;
 key_modified=128'd0;
 end 
 else if (enable) begin 
 
	if (load==0)
	begin
	for (j=0; j<=15; j=j+1)
		if 		(j>=0  & j<=3 )
			begin
			k=0;
			add=k+j*3;
			key_modified[j*word_size  +:  word_size]=key[(j+add)*word_size  +:  word_size];
			$display("%d , %d ,%d, %h", add, (j+add), j, key[(j+add)*word_size  +:  word_size]); end 
		else if (j>=4  & j<=7 ) 
			begin
			k=-3;
			add=k+(j-4)*3;
			key_modified[j*word_size  +:  word_size]=key[(j+add)*word_size  +:  word_size];
			$display("%d , %d,%d, %h", add, (j+add),j, key[(j+add)*word_size  +:  word_size]);  end
		else if (j>=8  & j<=11) 
			begin
			k=-6;
			add=k+(j-8)*3;
			key_modified[j*word_size  +:  word_size]=key[(j+add)*word_size  +:  word_size];	
			$display("%d , %d, %d, %h", add, (j+add),j, key[(j+add)*word_size  +:  word_size]); end 
		else if (j>=12 & j<=15)
			begin
			k=-9;
			add=k+(j-12)*3;
			key_modified[j*word_size  +:  word_size]=key[(j+add)*word_size  +:  word_size];
			$display("%d ,%d,%d, %h", add, (j+add),j, key[(j+add)*word_size  +:  word_size]); end 
		else $display("CASE ERROR");		
for ( i=0; i<=15; i=i+1)
		Mod(key_modified[i*word_size  +:  word_size] ^ state[i*word_size  +:  word_size],state_out[i*word_size  +:  word_size]);
////////////////////////////////////////////////
$display ("%h", key_modified);
end
end
end
endmodule

