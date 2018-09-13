module key_expansion ( 
  input  [127:0] key_0 ,
  input en ,
  output reg [127:0] key_1 , 
  output reg [127:0] key_2 ,
  output reg [127:0] key_3 ,
  output reg [127:0] key_4 ,
  output reg [127:0] key_5 ,
  output reg [127:0] key_6 ,
  output reg [127:0] key_7 ,
  output reg [127:0] key_8 ,
  output reg [127:0] key_9 ,
  output reg [127:0] key_10);

  reg [31:0] stp1 ;
  wire [31:0] stp2 ;
  wire [31:0]Rcon ;
  integer n,m;
  
  // array to store all keys in it
  reg [31:0] k [0:43];
  
    rcon uut1 (.r(m),.rcon(Rcon));
   subByte uut2 (.state(stp1) , .state_out(stp2));
   
  
  always@( en)
    begin
		k[0][31:0] = key_0 [127:96];
		k[1][31:0] = key_0 [95:64];
		k[2][31:0] = key_0 [63:32];
		k[3][31:0] = key_0 [31:0];
        stp1= {key_0[25:0],key_0[31:24]};
        $display("%b",stp1);
        $display("%t",$time,);
		if (en==0)
		  begin
		    key_1 =0; 
        key_2 =0; 
        key_3 =0;
        key_4 =0;
        key_5 =0;
        key_6 =0;
        key_7 =0;
        key_8 =0;
        key_9 =0;
        key_10=0 ;
      end
		else
		begin
		  //stp1= {key_0[25:0],key_0[31:24]};
    for (n=4 ; n<=43 ; n=n+1)
    begin
      m=n/4;
      if ((n%4)==0)
      begin
        stp1= {k[n-1][25:0],k[n-1][31:24]} ;
        //#10;
        k[n] = k[n-4] ^ stp2 ^ Rcon ;
      end
    else
      begin
        k[n] = k[n-1] ^ k[n-4] ;
      end
      $display("%b",n);
      
      // 2D to 1D for output keys
      key_1 ={k[4],k[5],k[6],k[7]} ; 
      key_2 ={k[8],k[9],k[10],k[11]} ;
      key_3 ={k[12],k[13],k[14],k[15]} ;
      key_4 ={k[16],k[17],k[18],k[19]} ;
      key_5 ={k[20],k[21],k[22],k[23]} ;
      key_6 ={k[24],k[25],k[26],k[27]} ;
      key_7 ={k[28],k[29],k[30],k[31]} ;
      key_8 ={k[32],k[33],k[34],k[35]} ;
      key_9 ={k[36],k[37],k[38],k[39]} ;
      key_10 ={k[40],k[41],k[42],k[43]} ;
    
    end
  end
  end
  
  endmodule



