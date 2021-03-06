module lab2_3(clk, reset, seg7_sel, enable,seg7_out, dpt_out, carry_out, led_com);
input		clk, reset,enable; 	//pin 55,124,47
output[2:0]	seg7_sel; 	//pin 37,36,33
output[6:0] seg7_out; 		// pin23,26,27,28,29,30,31
output		dpt_out, carry_out, led_com;
wire		clk_count, clk_sel;
wire[3:0] 	count_out, count_out1, count_out0;
assign		dpt_out= 1'b0;
assign		led_com= 1'b1;
assign  	count_out= seg7_sel[0] ? count_out0 : count_out1; //MUX
freq_div #(21) (clk,reset,clk_count); // slow
freq_div #(17) (clk,reset,clk_sel); // high
count_00_99	 (clk_count, reset, enable, count_out1, count_out0, carry_out);
bcd_to_seg7_1 (count_out,seg7_out);
seg7_select #(2) (clk_sel,reset,seg7_sel);
endmodule
//----------------------------------------------------
module count_00_99(clk, reset, enable, count1_out, count0_out, carry_out);
input	clk, reset, enable;
output[3:0] count1_out, count0_out;
output	carry_out = carry1 & carry0;
wire	carry0,carry1;
count_0_9 (clk,reset,enable,carry0,count0_out);
count_0_9 (clk,reset,carry0,carry1,count1_out);
endmodule
//---------------------------------------------------
module	count_0_9(clk,reset,enable,carry1,count_out);
input	clk,reset,enable;
output	reg[3:0]count_out;
output	carry1;

assign	carry1=(count_out==4'd9)?1'b1:1'b0;
always@ (posedge clk or posedge reset) 
begin
if(reset)
	begin
	count_out<=4'd0;
	//carry1<=1'b0;
	end
else if(enable)
		if(count_out==4'd9)
			begin
			count_out<=4'd0;
			//carry1<=1'b1;
			end
		else	
			begin
			count_out<=count_out+4'd1;
			//carry1<=1'b0;
			end
end
endmodule
//-------------------------------------------
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
//-------------------------------------
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
module seg7_select(clk, reset, seg7_sel);
parameter	num_use= 6;
input		clk, reset;
output[2:0]	seg7_sel;
reg	[2:0]	seg7_sel;
always@ (posedge clk or posedge reset) begin
if(reset == 1)
	seg7_sel = 3'b101; // the rightmost one
else
	if(seg7_sel == 6 -num_use)
		seg7_sel = 3'b101;
	else
		seg7_sel = seg7_sel-3'b001; // shift left
end
endmodule