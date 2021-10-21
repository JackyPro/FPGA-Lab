`timescale 1 ns/1 ns

module 	testbench;
reg [3:0] bcd_in; // pin47-49,51
wire [2:0] seg7_sel; //pin 37,36,33 
wire [6:0] seg7_out; // pin23,26-31 
wire dpt_out; // pin32

bcd_to_seg7 bcd_to_seg7_instance(bcd_in, seg7_sel, seg7_out, dpt_out);

// set up clk with 50 ns period 20 MHz


initial
begin
 bcd_in=4'b0000;
 #20;		 
 bcd_in=4'b0001;
 #20; 
 bcd_in=4'b0010;
 #20; 
 bcd_in=4'b0011;
 #20;
 bcd_in=4'b0100;
 #20;
 bcd_in=4'b0101;
 #20;
 bcd_in=4'b0110;
 #20;
 bcd_in=4'b0111;
 #20; 
end
endmodule
