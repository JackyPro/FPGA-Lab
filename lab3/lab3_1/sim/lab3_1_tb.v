`timescale 1 ns/1 ns

module 	testbench;

reg		clk,reset,enable;
wire	[2:0]seg7_sel;
wire	[6:0]seg7_out;
wire 	dpt,carry,led_com;
wire	clk_count,clk_sel;
wire	[3:0]count_out,count5,count4,count3,count2,count1,count0;

lab3_1 lab3_1_instance(.clk(clk),.reset(reset),.enable(enable),.seg7_sel(seg7_sel),
						.seg7_out(seg7_out),.dpt(dpt),.carry(carry),.led_com(led_com));

// set up clk with 50 ns period 20 MHz
parameter	clkper = 5;
parameter	exp = 1;
parameter	num_use= 6;

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
 #692000000;			
end
endmodule
