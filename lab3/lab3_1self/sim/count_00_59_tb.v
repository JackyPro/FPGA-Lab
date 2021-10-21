`timescale 1 ns/1 ns

module 	testbench;

reg 	clk,reset,enable;

wire	[3:0]count1,count0;
wire	[3:0]count1reg,count0reg;
wire	carry;

count_00_59_bcd count_00_59_bcd_instance
				(.clk(clk),.reset(reset),.enable(enable),
					.count1(count1),.count0(count0),.carry(carry));

// set up clk with 50 ns period 20 MHz
parameter clkper = 20;

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
 #2000;			
end
endmodule
