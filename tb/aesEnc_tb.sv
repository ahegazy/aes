/*
*
*	Creator : Ahmad Hegazy <github.com/ahegazy> <ahegazipro@gmail.com>
*
*	Date: October 2018
* 
* Description: AES Encryption SystemVerilog TestBench Class.
* Language: SystemVerilog
*
*/

class AES_ENC;

	reg [127:0] state,key;
	reg [127:0] state_out;
	protected bit [7:0] state_2d [3:0] [3:0]; 
	protected bit [7:0] key_2d [3:0] [3:0];
	
	protected bit [7:0] polymat [3:0] [3:0];
	
	
	function new();
		$display("A new begining ._. ");
	endfunction

	function void init();
			int i,j,ij;
		/* convert 1Dimension to 2 Dimension*/
		for (i=0;i<=3;i=i+1)
			for(j=0;j<=3;j=j+1)
				begin 
					ij = (i*4+j)*8;
					this.state_2d[i][j] = this.state[ij+: 8];
					this.key_2d[i][j] = this.key[ij+: 8];
				end
		/* polynomial matrix */
		this.polymat = {{ 8'h02,8'h03,8'h01,8'h01} , {8'h01,8'h02,8'h03,8'h01} , {8'h01,8'h01,8'h02,8'h03} , {8'h03,8'h01,8'h01,8'h02}};
		/**/
	endfunction
	
	
	
	function void finish();
			int i,j,ij;
		/* convert 2 Dimensions to 1 Dimension*/
		for (i=0;i<=3;i=i+1)
			for(j=0;j<=3;j=j+1)
				begin 
					ij = (i*4+j)*8;
					this.state_out[ij+: 8] = this.state_2d[i][j];
				end
	endfunction
	
		protected function bit [14:0] finite_multiplication(bit [7:0] A,bit [7:0] B);			
			bit [14:0] temp [7:0] ;
			int i;
			for(i=0; i<=7; i=i+1)
				begin
					if (A[i]==1)
					temp[i]=B*(2**i);
					else 
					temp[i]=8'd0;
				end
				
				return (temp[0]^temp[1]^temp[2]^temp[3]^temp[4]^temp[5]^temp[6]^temp[7]);
		endfunction
		
		protected function bit [7:0] mod (bit [14:0] x);
			bit [7:0] y;
			bit    [8:0] con;
			bit    [14:0] z;
			int i;
			con = 9'd283;
			z = x;
			for (i=14; i>=8; i =i-1)
				if (z > 8'd255)
					begin
						if(z[i] == 1)
							z[i -: 9] = z[i -: 9] ^ con[8:0];
					end	
			
			y = z;
			return y;
		endfunction
			
	function void mix_columns ();//	bit [7:0] state_2d [3:0] [3:0]
		int i,j,k;
		automatic bit [7:0] mix_out_2d [3:0] [3:0];
		automatic bit [14:0] tmp_mult,tmp_mod;
		tmp_mod = 15'h0;
		mix_out_2d = {{8'h0,8'h0,8'h0,8'h0},{8'h0,8'h0,8'h0,8'h0},{8'h0,8'h0,8'h0,8'h0},{8'h0,8'h0,8'h0,8'h0}};/* init zero */
 		for (i=0;i<=3;i++)
			for(j=0;j<=3;j++)
			begin 
					/* scalar multiplication of two matrices */
					for (k=0;k<=3;k++)
					begin 
							tmp_mult = this.finite_multiplication(this.polymat[i][k], this.state_2d[k][j]);
							tmp_mod = tmp_mod ^ tmp_mult;
							mix_out_2d[i][j] = this.mod(tmp_mod);
					end
							$display("ij:%d,%d ,state: %x ",i,j,mix_out_2d[i][j]);
			end 
	endfunction


	function void ShiftRows ();//	bit [7:0] state_2d [3:0] [3:0]
		int i,j;
		automatic bit [7:0] shift_out_2d [3:0] [3:0];

		for ( i=0; i<=3; i=i+1)
	    for ( j=0; j<=3; j=j+1)
	     begin
	      if (i ==0)
	         shift_out_2d[i][j] = this.state_2d[i][j];
	      else if (i ==1)
	        begin
	         shift_out_2d[1][0] = this.state_2d[1][1];
           shift_out_2d[1][1] = this.state_2d[1][2];
           shift_out_2d[1][2] = this.state_2d[1][3];
           shift_out_2d[1][3] = this.state_2d[1][0];
          end
         else if (i ==2)
           begin
	          shift_out_2d[2][0] = this.state_2d[2][2];
	          shift_out_2d[2][1] = this.state_2d[2][3];
            shift_out_2d[2][2] = this.state_2d[2][0];
            shift_out_2d[2][3] = this.state_2d[2][1];
           end
          else if (i ==3) 
           begin
		        shift_out_2d[3][0] = this.state_2d[3][3];
            shift_out_2d[3][1] = this.state_2d[3][0];
            shift_out_2d[3][2] = this.state_2d[3][1];
            shift_out_2d[3][3] = this.state_2d[3][2];
           end
//        $display("sft: %x",shift_out_2d[i][j]);
				end 

	endfunction
	
	function void AddRoundKey ();//	bit [7:0] state_2d [3:0] [3:0], bit [7:0] key_2d [3:0] [3:0]
		int i,j,k;
		automatic bit [7:0] state_out_2d [3:0] [3:0];
 		for (i=0;i<=3;i++)
			for(j=0;j<=3;j++)
			begin 
				state_out_2d[i][j] = this.key_2d[i][j] ^ this.state_2d[i][j];
			end 
	endfunction

	
endclass: AES_ENC


module aes_tst;

initial 
begin 
	AES_ENC encTst; 
	
	encTst = new; 
	encTst.state = 128'h54776F204F6E65204E696E652054776F;
	encTst.key = 128'h5468617473206D79204B756E67204675;
	
	encTst.init();
	encTst.mix_columns();
	encTst.ShiftRows();
	encTst.AddRoundKey();
end 
endmodule