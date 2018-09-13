module key_expansionH( 
  input  [127:0] key_0 ,
	input clk,
  output  reg [127:0] key_1 , 
  output  reg [127:0] key_2 ,
  output  reg [127:0] key_3 ,
  output  reg [127:0] key_4 ,
  output  reg [127:0] key_5 ,
  output  reg [127:0] key_6 ,
  output  reg [127:0] key_7 ,
  output  reg [127:0] key_8 ,
  output  reg [127:0] key_9 ,
  output  reg [127:0] key_10);
  
	reg [31:0] stp1 ;
  wire [31:0] stp2 ;
  wire [31:0]Rcon ;
	reg [3:0] m,n; 
	
    //  integer n;
    //   a,b,c,d;
  // array to store all keys in it
   reg [127:0] k [10:0];

  //1D to 2D for input key
  initial
  begin
  m <= 0;
	n <= 1;
	k[0] <= key_0;
	k[1] <= 128'b0;
	k[2] <= 128'b0;
	k[3] <= 128'b0;
	k[4] <= 128'b0;
	k[5] <= 128'b0;
	k[6] <= 128'b0;
	k[7] <= 128'b0;
	k[8] <= 128'b0;
	k[9] <= 128'b0;
	k[10] <= 128'b0;
		end

 	 rcon uut1 (.r(m),.rcon(Rcon));
   subByte uut2 (.state(stp1) , .state_out(stp2));
	 
	 always @(negedge clk)
	 begin 
  $display("key %d : %h, %h",m,k[m],{ k[m][25:0] , k[m][31:24] });
 	  stp1 	<= { k[n-1][25:0] , k[n-1][31:24] }; 
	   m <= m + 1;        // m= 0 1 2 3 4 5 6 7 8 9 
	   n <= n+1; /*m 0 n 1*/ //n=  1 2 3 4 5 6 7  8 9 10 
	   end 

always @(posedge clk) 
 begin

		k[m][127:96] = k[m-1][127:96] ^ stp2 ^ Rcon; 	
		k[m][95:64] = k[m-1][95:64] ^ k[m][127:96];
		k[m] [63:32] = k[m-1][63:32] ^ k[m][95:64];
		k[m][31:0] = k[m-1][31:0] ^ k[m][63:32];
end
 endmodule

