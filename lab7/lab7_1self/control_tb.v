`timescale 1 ns/1 ns
module 	testbench;

reg		clk, reset, enable, nightcomes;
wire	[3:0]cnt_d0;
wire	[2:0]NS_lights, EW_lights;


wire		[2:0]next_NS_lights, next_EW_lights;
wire		[1:0]traffic_state, next_state;
wire		timer_clr, EW_side, next_timer_clr, next_EW_side;
wire		[3:0]timer;

control control_instance(
		.clk(clk),
		.reset(reset),
		.enable(enable),
//		.day_night(day_night),
		.nightcomes(nightcomes),
		.cnt_d0(cnt_d0),
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
 reset = 1'b0;		// Time = 0
 enable=1'b0;
 nightcomes=1'b0;
 #20;			// Time = 500
 reset = 1'b1;
 #32
 enable=1'b1;
 #388
 nightcomes=1'b1;
 #60;
 nightcomes=1'b0;
 #500;
end
endmodule