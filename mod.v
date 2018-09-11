

task Mod;
input  [14:0]x;
output [7:0] y;

reg    [8:0] con;
reg    [14:0] z;
integer i;
 
begin
  con = 9'd283;
  z = x;
  for (i=14; i>=0; i =i-1)
	 if (z > 8'd255)
	   begin
			if(z[i] == 1)
				z[i -: 9] = z[i -: 9] ^ con[8:0];
				//$display("z = %b",z[14:0]);
				end
	 else begin
		y =z;
		end
		y = z;
end

endtask



