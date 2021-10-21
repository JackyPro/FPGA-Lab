`timescale 1 ns/1 ns

module 	testbench;
reg		clk, reset, enable, nightcomes;
wire	[5:0]light_led;
wire	led_com;
wire	[6:0]seg7;
wire	[2:0]seg7_sel;
wire	[3:0]segg;
wire	[3:0]timer0,timer2;
wire	timer1,timer3;


lab7_1self4 lab7_1self4_instance(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.nightcomes(nightcomes),
		.light_led(light_led),
		.led_com(led_com),
		.seg7(seg7),
		.seg7_sel(seg7_sel),
		.EW_lights(EW_lights),
		.NS_lights(NS_lights));
parameter	exp = 1; 
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
 reset = 1'b1;		// Time = 0
 enable=1'b0;
 nightcomes=1'b0;
 #20;			// Time = 500
 reset = 1'b0;
 #32
 enable=1'b1;
 #3110;
 nightcomes=1'b1;
 #3110;
 nightcomes=1'b0;
 #3110;
end
endmodule
//--------------------------------------