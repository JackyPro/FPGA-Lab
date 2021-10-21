module lab1_4 (clk, reset, shift_red,shift_green, ctl_bit);
input clk; // pin 55 (10MHz)
input reset; // pin 47
output[7:0]shift_red; //  pin  98,  99, 100, 101, 102, 109, 110, 111
output[7:0]shift_green;// pin 112, 113, 114, 116, 117, 118, 119, 120
output ctl_bit; // pin 88
assign ctl_bit= 1'b1;
freq_div#(20)M1 (clk, reset, clk_work); 
lab01_4 M2 (clk_work, reset, shift_red,shift_green);
endmodule
//------------------------------------------------
module lab01_4 (clk, reset, shift_red,shift_green);
input clk, reset;
output [7:0]shift_red,shift_green;
wire[7:0]shift_red,shift_green;
reg[8:0]pattern;
assign shift_red=pattern[8]?{8'b00000000}:(pattern[7:0]); 
assign shift_green=pattern[8]?(pattern[7:0]):{8'b00000000}; 
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
//---------------------------------------------------------
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
