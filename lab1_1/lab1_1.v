module lab1_1 (clk, reset, shift_out, ctl_bit);
input clk;	 	    // pin 55
input reset;	    // pin 47
output[7:0]shift_out; 
// pin 98, 99, 100, 101, 102, 109, 110, 111
output ctl_bit; 	   // pin 88
assign ctl_bit= 1'b1;
freq_div#(20) M1 (clk, reset, clk_work); 
lab01_1 M2 (clk_work, reset, shift_out);
endmodule
//---------------------------------------------------------
module lab01_1 (clk, reset, shift_out);
input clk, reset;
output	[7:0]shift_out;
reg	[7:0]	shift_out;
always@ (posedge clk or posedge reset)
begin
if(reset)
shift_out= 8'b1100_0000;
else
shift_out= {shift_out[0], shift_out[7:1]};
end
endmodule
//--------------------------------------------------------
module freq_div(clk_in, reset, clk_out);
parameter exp = 20;   
input clk_in, reset;
output clk_out;
reg[exp-1:0] divider;
integer i;
assign clk_out= divider[exp-1];
always@ (posedge clk_in or posedge reset)
begin
if(reset)
for(i=0; i < exp; i=i+1)
divider[i] = 1'b0;
else
divider = divider+ 1'b1;
end
endmodule
