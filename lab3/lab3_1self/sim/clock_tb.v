`timescale 1 ns/1 ns

module 	testbench;

reg 	clk,reset,enable;

wire	[3:0]count5,count4,count3,count2,count1,count0;
wire	[3:0]count1reg,count0reg;

wire 	carry,carry2,carry1,carry0,carry4;

clock clock_instance
				(.clk(clk),.reset(reset),.enable(enable),
					.count5(count5),.count4(count4),.count3(count3),
					.count2(count2),.count1(count1),.count0(count0),.carry(carry));

// set up clk with 50 ns period 20 MHz
parameter clkper = 5;

initial
begin
	clk = 1;	// Time = 0
end

always 
begin
	#(clkper / 2)  clk = ~clk;
end

initial
begin
 reset	=1'b1;
 enable =1'b0;
 #20;			
 reset  =1'b0;
 #80;
 enable =1'b1; 
 #712000;			
end
endmodule
