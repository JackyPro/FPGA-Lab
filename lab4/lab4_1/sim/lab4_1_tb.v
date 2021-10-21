`timescale 1 ns/1 ns

module 	lab4_1_tb;

reg 	clk,reset;
reg		[1:0]sel;
wire	[7:0]row, column_green, column_red;
wire 	clk_shift, clk_scan;
wire	[7:0]idx, idx_cnt;
wire	[7:0]column_out;

lab4_1 lab4_1(
						.clk(clk),
						.reset(reset),
						.row(row),
						.sel(sel),
						.column_green(column_green),
						.column_red(column_red)			);

// set up clk with 50 ns period 20 MHz
parameter	clkper = 5;
parameter	exp = 1;

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
 #20;		
 reset  =1'b0;
 sel	= 2'b01;
 #1000;	
 $finish;		
end

initial begin
	$dumpfile("lab4_1.vcd");
	$dumpvars;
end

endmodule
