module	clocknew(clk,reset,enable,count5,count4,count3,count2,count1,count0,carry);

input	clk,reset,enable;
output	[3:0]count5,count4,count3,count2,count1,count0;

wire	[3:0]count5,count4,count3,count2,count1,count0;
reg		[3:0]count5reg,count4reg,count3reg,count2reg,count1reg,count0reg;
reg		carryreg;
output 	carry;

assign 	count5=count5reg;
assign	count4=count4reg;
assign 	count3=count3reg;
assign	count2=count2reg;
assign 	count1=count1reg;
assign	count0=count0reg;
assign	carry=carryreg;

always@ (posedge clk or posedge reset)
begin
	if(reset) 
		begin
		carryreg<=1'd0;
		count5reg<=4'd0;
		count4reg<=4'd0;
		count3reg<=4'd0;
		count2reg<=4'd0;
		count1reg<=4'd0;
		count0reg<=4'd0;
		end
	else 	
		if(enable == 1'b1)
				if(count0reg==4'd9)begin
					count0reg<=4'd0;
					count1reg<=count1reg+4'd1;
					carryreg<=1'd0;
					if(count1reg==4'd5)begin
						count1reg<=4'd0;
						count2reg<=count2reg+4'd1;
						if(count2reg==4'd9)begin
							count2reg<=4'd0;
							count3reg<=count3reg+4'd1;
								if(count3reg==4'd5)begin
									count3reg<=4'd0;
									count4reg<=count4reg+4'd1;
									if({count5reg,count4reg}==8'h23)begin
										count0reg<=4'd0;
										count1reg<=4'd0;
										count2reg<=4'd0;
										count3reg<=4'd0;
										count4reg<=4'd0;
										count5reg<=4'd0;
										carryreg<=1'd1;
										end
									else begin
										if(count4reg==4'd9)begin
											count4reg<=4'd0;
											count5reg<=count5reg+4'd1;
											end
										else
											count4reg<=count4reg+4'd1;
										end
										
									end
								else
									count3reg<=count3reg+4'd1;
							end
						else
							count2reg<=count2reg+4'd1;
						end
					else
						count1reg<=count1reg+4'd1;
					end
				else
					count0reg<=count0reg+4'd1;					
		
end
endmodule
