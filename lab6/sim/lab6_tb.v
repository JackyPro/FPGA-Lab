`timescale 1 ns/1 ns

module 	testbench;
reg		clk, reset;
reg		[2:0]column;
wire	[2:0]sel;		
wire	[6:0]seg7;		
wire 	clk_sel;
wire	[3:0] key_code;

lab6 lab6_instance(
		.clk(clk),
		.reset(reset),
		.column(column),
		.sel(sel),
		.seg7(seg7));

parameter	exp = 1; 
parameter clkper = 2;
initial clk=1;

always 
begin
	#(clkper / 2)  clk = ~clk;
end

initial
begin
 reset = 1'b1;		
 #20;			
 reset = 1'b0;
 #32;
 column= 3'b011;
 #100;
 column= 3'b101;
 #100;
 column= 3'b110;
 #100;
 column= 3'b011;
 #100;
 column= 3'b101;
 #100;
 column= 3'b110;
 #100;
 #500;
 $finish;
end


initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0,testbench);
end

endmodule
//--------------------------------------