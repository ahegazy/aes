module Shift_Rows 
 #(parameter word_size =1 ,array_size =16)(
  input  reg  [0:word_size*array_size-1] Data,
	output reg  [0:word_size*array_size-1] Shifted_Data );
  
  reg [word_size-1:0] data [0:3] [0:3];
  reg [word_size-1:0] shifted_data[0:3] [0:3];
 
 integer i,j,ij;	 
  
initial
  begin
    for ( i=0; i<=3; i=i+1)
	   for ( j=0; j<=3; j=j+1)
	      begin 
	        ij =((4*i)+j);
		      data[j][i]=Data[ij*word_size  +:  word_size];
		    end	
		    
		 for ( i=0; i<=3; i=i+1)
	    for ( j=0; j<=3; j=j+1)
	     begin
	      if (i ==0)
	         shifted_data[i][j] = data[i][j];
	      else if (i ==1)
	        begin
	         shifted_data[1][0] = data[1][1];
           shifted_data[1][1] = data[1][2];
           shifted_data[1][2] = data[1][3];
           shifted_data[1][3] = data[1][0];
          end
         else if (i ==2)
           begin
	          shifted_data[2][0] = data[2][2];
	          shifted_data[2][1] = data[2][3];
            shifted_data[2][2] = data[2][0];
            shifted_data[2][3] = data[2][1];
           end
          else if (i ==3) 
           begin
		        shifted_data[3][0] = data[3][3];
            shifted_data[3][1] = data[3][0];
            shifted_data[3][2] = data[3][1];
            shifted_data[3][3] = data[3][2];
           end
        end 
 
    for ( i=0; i<=3; i=i+1)
	    for ( j=0; j<=3; j=j+1)
	      begin 
	        ij =((4*i)+j);
	       	Shifted_Data[ij*word_size  +:  word_size]=shifted_data[j][i];
		    end	
	 end
		   
  
endmodule
