`timescale 1 ns/1 ns

module 	testbench();

parameter	exp = 8;   
reg			clk_in, reset;
wire		clk_out;

freq_div freq_div_instance(.clk_in(clk_in),.reset(reset),.clk_out(clk_out));

// set up clk with 50 ns period 20 MHz
parameter	clkper = 10;

initial
begin
	clk_in = 1;	// Time = 0
end

always 
begin
	#(clkper / 2)  clk_in = ~clk_in;
end

initial
begin
 reset	=1'b1;
 #20;		
 reset  =1'b0;
 #1980;		
end

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,testbench);
end
endmodule
