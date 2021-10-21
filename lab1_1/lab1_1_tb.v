`timescale 1 ns/1 ns

module 	testbench();
reg clk;	 	    
reg reset;	    
wire [7:0]shift_out; 
// pin 98, 99, 100, 101, 102, 109, 110, 111
wire ctl_bit; 	   // pin 88

lab1_1 instance(
				.clk(clk),
				.reset(reset),
				.shift_out(shift_out), 
				.ctl_bit(ctl_bit)
				);

// set up clk with 50 ns period 20 MHz
parameter	clkper = 5;

initial
begin
	clk = 1;	// Time = 0
end

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,testbench);
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
 #1980000;		
end
endmodule