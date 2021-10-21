module lab1_3 (clk, reset, shift_out, ctl_bit);
input clk; // pin 55
input reset; // pin 47
output[7:0]shift_out; 
// pin 98, 99, 100, 101, 102, 109, 110, 111
output ctl_bit; // pin 88
assign ctl_bit= 1'b1;
freq_div#(20)M1 (clk, reset, clk_work); 
lab02_2 M2 (clk_work, reset, shift_out);
endmodule
//----------------------------------------------------
module lab02_2 (clk, reset, shift_out);
input clk, reset;
output [7:0]shift_out;
wire[7:0]shift_out;
reg[8:0]pattern;
assign  shift_out= pattern[7:0];
always@ (posedge clk or posedge reset)
begin
if(reset)
pattern = 9'b0_1110_0000;
else 
case(pattern)
  9'b0_11100000:pattern = 9'b0_01110000;
  9'b0_01110000:pattern = 9'b0_00111000;  
  9'b0_00111000:pattern = 9'b0_00011100;  
  9'b0_00011100:pattern = 9'b0_00001110;
  9'b0_00001110:pattern = 9'b0_00000111;  
  9'b0_00000111:pattern = 9'b1_00001110;  
  9'b1_00001110:pattern = 9'b1_00011100;
  9'b1_00011100:pattern = 9'b1_00111000;  
  9'b1_00111000:pattern = 9'b1_01110000;
  9'b1_01110000:pattern = 9'b1_11100000;
  9'b1_11100000:pattern = 9'b0_01110000;
default:pattern = 9'b0_11100000;endcase
end
endmodule
//----------------------------------------------------
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
