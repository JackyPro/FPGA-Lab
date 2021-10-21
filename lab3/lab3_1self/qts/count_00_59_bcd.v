module 	count_00_59_bcd(clk,reset,enable,count1,count0,carry);

input 	clk,reset,enable;
output	[3:0]count1,count0;
wire	[3:0]count1,count0;
reg		[3:0]count1reg,count0reg;
reg		carryreg;
output 	carry;

assign 	count1=count1reg;
assign	count0=count0reg;
assign	carry=carryreg;

always@ (posedge clk or posedge reset)
begin
	if(reset) 
		begin
		carryreg<=1'd0;
		count1reg<=4'd0;
		count0reg<=4'd0;
		end
	else 	
		if(enable == 1'b1)
				if({count1reg,count0reg}<8'd59)
					if(count0reg<9)
						count0reg<=count0reg+4'd1;
						//carryreg<=1'd0;
					else begin
						count0reg=4'd0;
						count1reg=count1reg+4'd1;
						//carryreg=1'd1;
						end
				else begin
					carryreg<=1'd1;
					count0reg<=4'd0;
					count1reg<=4'd0;
					end
					
		
end
endmodule