module	count_00_23_bcd(clk,reset,enable,count1,count0,carry);

input	clk,reset,enable;
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
	if(enable == 1'b1)begin
			if(((count1reg!=4'd2)&&(count0reg!=4'd9))|
					((count1reg==4'd2)&&(count0reg!=4'd3)))begin
					count0reg<=count0reg+4'd1;
					carryreg<=1'd0;
					end
			else
				if((count1reg==4'd2)&&(count0reg==4'd3))begin// 
					count1reg<=4'd0;
					count0reg<=4'd0;
					carryreg<=1'b1;
					end
				else begin//if((count1reg!=4'd2)&&(count0reg==4'd9))begin
					count0reg<=4'd0;
					count1reg<=count1reg+4'd1;
					carryreg<=1'd0;
					end
			end
end
endmodule