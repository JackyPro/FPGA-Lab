module bcd_to_seg7(bcd_in, seg7_sel, seg7_out, dpt_out);
input [3:0] bcd_in; // pin47-49,51
output [2:0] seg7_sel; //pin 37,36,33 
output [6:0] seg7_out; // pin23,26-31 
output dpt_out; // pin32
bcd_to_seg7_1 m1(bcd_in, seg7_out);
assign seg7_sel = 3'b101; // Use the rightmost segment
assign dpt_out= 1'b0; 
endmodule
//------------------------------
module bcd_to_seg7_1(bcd_in, seg7);
input[3:0] bcd_in;
output[6:0] seg7;
reg[6:0] seg7;
always@ (bcd_in)
case(bcd_in) // abcdefg
4'b0000: seg7 = 7'b1111110; // 0
4'b0001: seg7 = 7'b0110000; // 1
4'b0010: seg7 = 7'b1101101;
4'b0011: seg7 = 7'b1111001;
4'b0100: seg7 = 7'b0110011;
4'b0101: seg7 = 7'b1011011;
4'b0110: seg7 = 7'b1011111;
4'b0111: seg7 = 7'b1110000;
4'b1000: seg7 = 7'b1111111;
4'b1001: seg7 = 7'b1111011;
default: seg7 = 7'b0000001; 
endcase
endmodule
