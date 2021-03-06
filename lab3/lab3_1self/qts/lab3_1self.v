module	lab3_1self(clk,reset,enable,seg7_sel,seg7_out,dpt,carry,led_com);

input	clk,reset,enable;
output	[2:0]seg7_sel;
output	[6:0]seg7_out;
output 	dpt,carry,led_com;
wire	clk_count,clk_sel,carryyy;
wire	[3:0]count_out,count5,count4,count3,count2,count1,count0;

assign	led_com	= 1'b1;
assign	count_out=	(seg7_sel == 3'b101 )? count0 : (seg7_sel == 3'b100 )? count1 :
					(seg7_sel == 3'b011 )? count2 : 
					(seg7_sel == 3'b010 )? count3 : 
					(seg7_sel == 3'b001 )? count4 : count5;
assign	dpt		=	(seg7_sel == 3'b101 )? 1'b1 : (seg7_sel == 3'b100 )? 1'b0 :
					(seg7_sel == 3'b011 )? 1'b1 : 
					(seg7_sel == 3'b010 )? 1'b0 : 
					(seg7_sel == 3'b001 )? 1'b1 :1'b0;

freq_div #(13)m1(.clk_in(clk), .reset(reset), .clk_out(clk_count));

freq_div #(10)m2(.clk_in(clk), .reset(reset), .clk_out(clk_sel));

//clock m3(.clk(clk_count), .reset(reset), .enable(enable),
//			.count5(count5), .count4(count4), .count3(count3),
//		.count2(count2), .count1(count1), .count0(count0), .carry(carry));
clocknew m3(.clk(clk_count), .reset(reset), .enable(enable),
			.count5(count5), .count4(count4), .count3(count3),
			.count2(count2), .count1(count1), .count0(count0), .carry(carry));
bcd_to_seg7_1 m4(.bcd_in(count_out),.seg7(seg7_out));

seg7_select#(6) m5(.clk(clk_sel),.reset(reset),.seg7_sel(seg7_sel));

endmodule 
//---------------------------------
