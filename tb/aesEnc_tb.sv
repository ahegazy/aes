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

	bit [127:0] key;
	bit [127:0] state;
	bit [127:0] state_out;
	
	protected bit [7:0] polymat [0:3] [0:3];
	protected bit [7:0] sbox [ bit [7:0] ];	
	protected bit [7:0] rcon [ bit [3:0] ];
	
	function new();
		$display("A new begining ._. ");
		/* initialize the needed values */
		this.init();
	endfunction

	function void init();

	/* polynomial matrix */
		this.polymat = {{ 8'h02,8'h03,8'h01,8'h01} , {8'h01,8'h02,8'h03,8'h01} , {8'h01,8'h01,8'h02,8'h03} , {8'h03,8'h01,8'h01,8'h02}};
	/* Generate S_box */
		this.generate_SBOX();
		/* Generate Rcon*/
		this.generate_RCON();
	endfunction
	
		protected function bit [7:0] ROTL8( bit [7:0] x , bit [3:0] shift );
				ROTL8 = ( ((x) << (shift)) | ((x) >> (8 - (shift))) );
		endfunction
	
	protected function void generate_SBOX();
			bit [7:0] p = 1;
			bit [7:0]	q = 1;
			bit [7:0] xformed;
					/* loop invariant: p * q == 1 in the Galois field */
					do 
					begin
						/* multiply p by 3 */
						p = p ^ (p << 1) ^ ((p & 8'h80) ? 8'h1B : 0);

						/* divide q by 3 (equals multiplication by 0xf6) */
						q ^= q << 1;
						q ^= q << 2;
						q ^= q << 4;
						q ^= ((q & 8'h80) ? 8'h09 : 0);

						
						/* compute the affine transformation */
						xformed = q ^ this.ROTL8(q, 1) ^ this.ROTL8(q, 2) ^ this.ROTL8(q, 3) ^ this.ROTL8(q, 4);
						this.sbox[p] = xformed^8'h63;
					end 
					while (p != 8'h01);
				
					/* 0 is a special case since it has no inverse */
					this.sbox[8'h00] = 8'h63;
		endfunction
		
		protected function void generate_RCON();		
			bit [7:0] rcon;
			rcon = 0'h8d;
			//this.rcon = {32'h0};
			for (int i=0;i<10;i++)
			begin 
				rcon = ((rcon << 1) ^ (16'h11b & - (rcon >> 7))) & 8'hff;
				this.rcon[i+1] = rcon;
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
				
				finite_multiplication = (temp[0]^temp[1]^temp[2]^temp[3]^temp[4]^temp[5]^temp[6]^temp[7]);
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
				 else begin
					y =z;
					end
					y = z;

			mod = y;
		endfunction
		
		function bit [0:127] ExpandKey (bit [0:127] key,bit [3:0] num);// bit [7:0] key_2d [3:0] [3:0]
			int i,j,ij;
		automatic bit [7:0] key_2d [3:0] [3:0];
		automatic bit [7:0] key_out_2d [3:0] [3:0];
		automatic bit [0:127] key_out;
		
		/* convert 1Dimension to 2 Dimension*/
		for (i=0;i<=3;i=i+1)
			for(j=0;j<=3;j=j+1)
				begin 
					ij = (i*4+j)*8; /* if input is [0:127]*/
					key_2d[i][j] = key[ij+: 8];
				end
		
 		for (i=0;i<=3;i++)
			for(j=0;j<=3;j++)
			begin 
				if(i == 0)
				begin 
						key_out_2d[i][j] = 	key_2d[i][j] ^ this.SubByte(key_2d[3][(j == 3) ? 0 : j+1]) ^ ((j == 0) ? this.rcon[num] : 8'h00);
				end 
				else key_out_2d[i][j] = key_2d[i][j] ^ key_out_2d[i-1][j];
			end 
			
		for (i=0;i<=3;i=i+1)
			for(j=0;j<=3;j=j+1)
				begin 
					ij = (i*4+j)*8;
					key_out[ij+: 8] = key_out_2d[i][j];
				end

			ExpandKey = key_out;				
		endfunction
		
		function bit [7:0] SubByte (	bit [7:0] subitem );//, bit [7:0] key_2d [3:0] [3:0]
				SubByte = this.sbox[subitem];
		endfunction

		function bit [127:0] SubByte_128 (	bit [127:0] subitem );//, bit [7:0] key_2d [3:0] [3:0]
			bit [127:0] subitem_out ; 
			for(int i=0;i<=15;i++)
					subitem_out[i*8+:8] = this.SubByte(subitem[i*8+:8]);
					
			SubByte_128 = subitem_out;
		endfunction

		function bit [127:0] mix_columns (bit [127:0] state);//	bit [7:0] state_2d [3:0] [3:0]
			int i,j,ij,k;
			automatic bit [7:0] state_2d [0:3] [0:3];
			automatic bit [7:0] mix_out_2d [0:3] [0:3];
			automatic bit [14:0] tmp_mult,tmp_mod;
			automatic bit [127:0] state_out;

			
			tmp_mod = 15'h0;
			mix_out_2d = {{8'h0,8'h0,8'h0,8'h0},{8'h0,8'h0,8'h0,8'h0},{8'h0,8'h0,8'h0,8'h0},{8'h0,8'h0,8'h0,8'h0}};/* init zero */
			
			for ( i=0; i<=3; i=i+1)
				for ( j=0; j<=3; j=j+1)
					begin
					ij=15-(i*4+j);
					state_2d[j][i]=state[ij*8  +: 8];
				end	

			for (i=0;i<=3;i++)
				for(j=0;j<=3;j++)
				begin 
						tmp_mod=15'd0;
						/* scalar multiplication of two matrices */
						for (k=0;k<=3;k++)
						begin 
								tmp_mult = this.finite_multiplication(state_2d[k][j],this.polymat[i][k] );
								tmp_mod = tmp_mod ^ tmp_mult;
								mix_out_2d[i][j] = this.mod(tmp_mod);
						end
							//	$display("ij:%d,%d ,state: %x ",i,j,mix_out_2d[i][j]);
				end
		/*	$display("Mixed data",);				
			for ( i=0; i<=3; i=i+1)
				$display("%x %x %x %x ",mix_out_2d[i][0],mix_out_2d[i][1],mix_out_2d[i][2],mix_out_2d[i][3]);			
*/
				//2D to 1D

			for ( i=0; i<=3; i=i+1) 
				for ( j=0; j<=3; j=j+1)
					begin
						ij=15-(i*4+j);
						state_out[ij*8  +:  8]=mix_out_2d[j][i];
						end	
			
			mix_columns = state_out;
	endfunction


	function bit [0:127] ShiftRows (bit [0:127] state);//	bit [7:0] state_2d [3:0] [3:0]
		int i,j,ij;
		automatic bit [7:0] shift_out_2d [3:0] [3:0];
		automatic bit [7:0] state_2d [0:3] [0:3];
		automatic bit [0:127] state_out;
		
		/* 1d to 2d */
		for ( i=0; i<=3; i=i+1)
	   for ( j=0; j<=3; j=j+1)
	      begin 
	        ij =((4*i)+j);
		      state_2d[j][i]=state[ij*8  +:  8];
		    end	

		for ( i=0; i<=3; i=i+1)
	    for ( j=0; j<=3; j=j+1)
	     begin
	      if (i ==0)
	         shift_out_2d[i][j] = state_2d[i][j];
	      else if (i ==1)
	        begin
	         shift_out_2d[1][0] = state_2d[1][1];
           shift_out_2d[1][1] = state_2d[1][2];
           shift_out_2d[1][2] = state_2d[1][3];
           shift_out_2d[1][3] = state_2d[1][0];
          end
         else if (i ==2)
           begin
	          shift_out_2d[2][0] = state_2d[2][2];
	          shift_out_2d[2][1] = state_2d[2][3];
            shift_out_2d[2][2] = state_2d[2][0];
            shift_out_2d[2][3] = state_2d[2][1];
           end
          else if (i ==3) 
           begin
		        shift_out_2d[3][0] = state_2d[3][3];
            shift_out_2d[3][1] = state_2d[3][0];
            shift_out_2d[3][2] = state_2d[3][1];
            shift_out_2d[3][3] = state_2d[3][2];
           end
//        $display("sft: %x",shift_out_2d[i][j]);
				end 
	/*	$display("shifted data",);				
		for ( i=0; i<=3; i=i+1)
			$display("%x %x %x %x ",shift_out_2d[i][0],shift_out_2d[i][1],shift_out_2d[i][2],shift_out_2d[i][3]);*/
    /* 2d to 1d */
						for ( i=0; i<=3; i=i+1)
							for ( j=0; j<=3; j=j+1)
								begin 
									ij =((4*i)+j);
									state_out[ij*8  +:  8]=shift_out_2d[j][i];
								end
			ShiftRows = state_out;
	endfunction
	
	function bit [127:0] AddRoundKey (bit [127:0] state,bit [127:0] key);//	bit [7:0] state_2d [3:0] [3:0], bit [7:0] key_2d [3:0] [3:0]
		int i;
		automatic bit [127:0] state_out;
 		for (i=0;i<=15;i++)
				state_out[i*8+:8] = key[i*8+:8] ^ state[i*8+:8];

		AddRoundKey = state_out;
	endfunction

	function bit [127:0] encrypt();
		bit [127:0] state_trans;
		bit [127:0] key_trans;

		state_trans = this.state;
		key_trans = this.key;
		$display("initial values: key: %x,state: %x",key_trans,state_trans);
		$display("-------------------------------------------------------");
		state_trans = this.AddRoundKey(state_trans,key_trans);
		$display("after AddRoundKey0: %x",state_trans);
		$display("-------------------------------------------------------");

		for (int i =1;i<=9;i++)
		begin 
			$display("iteration: # %d",i);
			state_trans = this.SubByte_128(state_trans);
			$display("after subbyte: %x",state_trans);
			state_trans = this.ShiftRows(state_trans);
			$display("after ShiftRows: %x",state_trans);
			state_trans = this.mix_columns(state_trans);
			$display("after mix_columns: %x",state_trans);
			key_trans = this.ExpandKey(key_trans,i);
			$display("after ExpandKey: %x",key_trans);
			state_trans = this.AddRoundKey(state_trans,key_trans);
			$display("after AddRoundKey: %x",state_trans);
			$display("-------------------------------------------------------");
		end 
		
			state_trans = this.SubByte_128(state_trans);
			state_trans = this.ShiftRows(state_trans);
			key_trans = this.ExpandKey(key_trans,10);
			state_trans = this.AddRoundKey(state_trans,key_trans);
			
			this.state_out = state_trans;
	endfunction
	
endclass: AES_ENC


module aes_tst;

initial 
begin 
	AES_ENC encTst; 
	
	encTst = new; 
	encTst.state = 128'h54776F204F6E65204E696E652054776F;
	encTst.key = 128'h5468617473206D79204B756E67204675;

	encTst.encrypt();
	$display("after encryption: %x",encTst.state_out);

end 
endmodule