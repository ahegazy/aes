`timescale 10ns/1ns
module encryption_TB;


/*INPUTS*/

reg [7:0] key_byte, state_byte;
reg clk,rst,enable;

/* OUTPUTS */
wire [7:0] state_out_byte;
wire load,ready;

/* instance */
AES_encryption AES_TB(key_byte, state_byte,clk,rst,enable,state_out_byte,load,ready);

/*Initializing inputs*/
initial 
begin 
 //initialize here 
	clk = 0;
	rst = 0;
  key_byte = 0;
  state_byte =0;
	
end 


/*Monitor values*/
initial 
begin 
  $display ("\t\ttime,\tkey_Byte,\tdata_Byte,\tload,\tready,\tdata_out_byte");
  $monitor ("%d,\t%b,\t%b,\t%b,\t%b,\t%b",$time,key_byte,state_byte,load,ready,state_out_byte);
end

//Generate clock 
always 
#1 clk = ~clk;

event reset_done;
/*Generating input values */
task reset();
  begin
  @(negedge clk);
    rst = 1;
	#5
  @(negedge clk);
		begin 
		rst = 0;
		->reset_done;
		end
	
	

end 
endtask



initial 
begin 
  #1 reset();
end


task send_DataKey();
begin 

		/* 16 cycle  key = 0 ;data = 0 */
	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;
		
	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;
		
	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;

	  key_byte = 8'h00;
		state_byte = 8'h00;
		#1; // wait clock;
 end
endtask 

initial
begin 
  @(reset_done)
  begin
		enable = 1;
		send_DataKey;
		#10;
		@(ready) 
			begin 
				#1000;
				$stop;
			end 
  end
end 
endmodule