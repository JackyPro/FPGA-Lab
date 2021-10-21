`timescale 1 ns/1 ns

module 	testbench;
reg		clk, reset, enable, day_night;
wire	[5:0]light_led;
wire	led_com;
wire	[6:0]seg7;
wire	[2:0]seg7_sel;
wire	[7:0]g1_cnt;
wire	clk_cnt, clk_sel;
wire	[3:0]count_out;
wire	[1:0]light_mode;


lab7_1 lab7_1_instance(
		.clk(clk),
		.reset(reset),
		.day_night(day_night),
		.light_led(light_led),
		.led_com(led_com),
		.seg7(seg7),
		.seg7_sel(seg7_sel));
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
 day_night=1'b1;
 #20;			// Time = 500
 reset = 1'b0;
 #32
 #3110;
 #3110;
 #3110;
end
endmodule
//--------------------------------------