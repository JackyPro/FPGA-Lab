module	clock(clk,reset,enable,count5,count4,count3,count2,count1,count0,carry);

input	clk,reset,enable;
output	[3:0]count5,count4,count3,count2,count1,count0;
output 	carry;
wire	[3:0]count5,count4,count3,count2,count1,count0;
wire 	carry,carry2,carry1,carry0,carry4;

assign 	carry = carry2 & carry1 & carry0;
assign	carry4=	carry0 & carry1;

count_00_23_bcd m6(.clk(clk), .reset(reset),  .enable(carry4), 
					.count1(count5), .count0(count4), .carry(carry2));
					
count_00_59_bcd m7(.clk(clk), .reset(reset),  .enable(carry0), 
					.count1(count3), .count0(count2), .carry(carry1));
					
count_00_59_bcd m8(.clk(clk), .reset(reset),  .enable(enable), 
					.count1(count1), .count0(count0), .carry(carry0));

endmodule