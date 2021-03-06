/*
18.	請利用LED燈做出十字路口之紅綠燈
請讓紅燈亮10秒後，綠燈亮8秒，黃燈亮2秒，以此循環
紅燈時顯示靜止小紅人、綠燈時顯示靜止小綠人、黃燈時顯示跑動小綠人
*/
module	m18(clk, rst, day_night, light_led, led_com, seg7_sel, seg7_out,row, column_green, column_red);
					
input	clk,rst;
input	day_night;
output	[2:0]seg7_sel;
output	[6:0]seg7_out;
output	[5:0]light_led;
output	[7:0]row,column_green,column_red;
output	led_com;
wire	[5:0]light_led;
wire	[3:0]count_out;
wire	clk_yellow, clk_cnt_dn,clk_sel,clk_shift,clk_scan;
wire	enable;
wire	[7:0]row1, row2,row3;
wire	[7:0]cnt;
wire	[7:0]idx, idx_cnt,column_out_red,column_out_green,column_out_yellow;

assign row 			=	(light_led[3])?row1:row2;

assign column_green	= 	(light_led[0])? column_out_green: 
						(light_led[1])? column_out_yellow: 8'b0;
						
assign column_red	= 	(light_led[2])? column_out_red: 8'b0;

assign	led_com		= 	1'b1;

assign	count_out	= 	day_night?(seg7_sel == 3'b101)? cnt[3:0] :cnt[7:4]	:4'b0;

freq_div	#(21)	M1(clk, rst, clk_yellow);
freq_div	#(23)	M2(clk, rst, clk_cnt_dn);
freq_div	#(6)	M3(clk, rst, clk_sel);
freq_div	#(23)	M4(clk, rst, clk_shift);
freq_div	#(5)	M5(clk, rst, clk_scan);
bcd_to_seg7 	M6 (count_out, seg7_out);
seg7_select #(2) 	M7(clk_sel, rst, seg7_sel);
traffic			M8 (clk_cnt_dn, clk_yellow, rst, day_night, light_led, enable, cnt);
lab1016_red 	M9 (clk_shift,clk_scan, rst, row2, column_out_red);
lab1016_green 	M16(clk_shift,clk_scan, rst, row1, column_out_green);
lab1016_yellow 	M20(clk_shift,clk_scan, rst, row3, column_out_yellow);
endmodule

//----------------------------------------------------------------------

module	lab1016_red(clk_shift,clk_scan, rst, row, column_out_red);

input	clk_shift,clk_scan,rst;
output	[7:0]row, column_out_red;
wire	[7:0]idx, idx_cnt;

idx_gen 		M10(clk_shift, rst, idx); 
row_gen  		M11(clk_scan, rst, idx, row, idx_cnt);
rom_char_red 	M12(idx_cnt, column_out_red);

endmodule

//-----------------------------------------------------------------------

module	lab1016_yellow(clk_shift,clk_scan, rst, row, column_out_yellow);

input	clk_shift,clk_scan,rst;
output	[7:0]row, column_out_yellow;
wire	[7:0]idx, idx_cnt;

idx_gen  		M19(clk_shift, rst, idx); 
row_gen  		M17(clk_scan, rst, idx, row, idx_cnt);
rom_char_yellow M18(idx_cnt, column_out_yellow);

endmodule

//-----------------------------------------------------------------------

module lab1016_green(clk_shift,clk_scan, rst, row, column_out_green);

input clk_shift,clk_scan,rst;
output[7:0] row, column_out_green;
wire[7:0] idx, idx_cnt;

idx_gen  		M13(clk_shift, rst, idx); 
row_gen  		M14(clk_scan, rst, idx, row, idx_cnt);
rom_char_green  M15(idx_cnt, column_out_green);

endmodule

//-------------------------------------------------------------

module	rom_char_yellow(addr, data, column_green);
input	[6:0]addr;
output	[7:0]data;
output	[7:0]column_green;
wire	[7:0]column_green;
reg		[7:0]data;

assign column_green=data[7:0];

always@(addr) 
begin
	case(addr)
		7'd0: data = 8'h30; 		7'd1: data = 8'h78; 		//run1
		7'd2: data = 8'h30; 		7'd3: data = 8'h3C;
		7'd4: data = 8'h5A; 		7'd5: data = 8'h98;
		7'd6: data = 8'h24; 		7'd7: data = 8'h6C;

		7'd8: data = 8'h30; 		7'd9: data = 8'h78; 		//run2
		7'd10: data = 8'h30; 		7'd11: data = 8'h3E;
		7'd12: data = 8'hD8;		7'd13: data = 8'h18;
		7'd14: data = 8'h26;		7'd15: data = 8'h62;
		default:data=8'h00;
	endcase
end
endmodule

//-----------------------------------------

module	rom_char_red(addr, column_red);

input	[6:0]addr;
reg 	[7:0]data;
output	[7:0]column_red;
wire	[7:0]column_red;

assign	column_red = data[7:0];

always@(addr) 
begin
	case(addr)
		7'd0: data = 8'h18; 		7'd1: data = 8'h3C; 		//stop
		7'd2: data = 8'h18; 		7'd3: data = 8'h3C;
		7'd4: data = 8'h5A; 		7'd5: data = 8'h18;
		7'd6: data = 8'h24; 		7'd7: data = 8'h66;

		7'd8: data = 8'h18; 		7'd9: data = 8'h3C; 		//stop
		7'd10: data = 8'h18; 		7'd11: data = 8'h3C;
		7'd12: data = 8'h5A;		7'd13: data = 8'h18;
		7'd14: data = 8'h24;		7'd15: data = 8'h66;
		default:data=8'h00;
	endcase
end
endmodule

//------------------------------------------

module	rom_char_green(addr, column_green);

input	[6:0]addr;
reg 	[7:0]data;
output	[7:0]column_green;
wire	[7:0]column_green;

assign	column_green = data[7:0];

always@(addr) 
begin
	case(addr)
		7'd0: data = 8'h18; 		7'd1: data = 8'h3C; 		//stop
		7'd2: data = 8'h18; 		7'd3: data = 8'h3C;
		7'd4: data = 8'h5A; 		7'd5: data = 8'h18;
		7'd6: data = 8'h24; 		7'd7: data = 8'h66;

		7'd8: data = 8'h18; 		7'd9: data = 8'h3C; 		//stop
		7'd10: data = 8'h18; 		7'd11: data = 8'h3C;
		7'd12: data = 8'h5A;		7'd13: data = 8'h18;
		7'd14: data = 8'h24;		7'd15: data = 8'h66;
		default:data=8'h00;
	endcase
end
endmodule

//-------------------------------------------------------

module	traffic(clk_cnt_dn, clk_yellow, rst, day_night, light_led, enable, cnt);

input 	clk_cnt_dn, clk_yellow, rst, day_night;
output	[5:0]light_led;
output	enable;
output	[7:0]cnt;
wire	enable;
wire	[7:0]cnt;

ryg_ctl 		M13(clk_cnt_dn, clk_yellow, rst, day_night, cnt, enable, light_led);
light_cnt_dn_20 M14(clk_cnt_dn, rst, enable, cnt);

endmodule

//------------------------------------------------------

module light_cnt_dn_20(clk, rst, enable, cnt);

input			clk, rst, enable;
output	[7:0] 	cnt;
reg	[7:0]	cnt;

always@(posedge clk or posedge rst) 
begin
	if(rst)
		cnt = 8'b0; // initial state
	else if(enable)  // 0 -> 20 -> ... -> 1 -> 0 -> 20
		if(cnt== 8'b0)
			cnt = 8'b0010_0000;  // 20
		else if(cnt[3:0] == 4'd0)
			begin  // 20 -> 19, 10 -> 09
			cnt[7:4] = cnt[7:4]-4'b1; 
			cnt[3:0] = 4'b1001;	  
			end
		else
			cnt[3:0] = cnt[3:0]-4'b1;  // 19 -> 18, 18 -> 17, 17 -> 16, …	
end
endmodule

//----------------------------------------------

module	ryg_ctl(clk_cnt_dn, clk_yellow, rst, day_night, cnt, enable, light_led);

input	clk_cnt_dn,clk_yellow,rst,day_night;
input	[7:0]cnt;
output	enable;
output	[5:0]light_led;
reg 	enable;
reg		[5:0]light_led;
reg		[2:0]mode;
//reg[3:0]	yellow_cnt;

always@(posedge clk_cnt_dn or posedge rst) 
begin
if (rst)begin
	light_led<= 6'b001_100; // g1 : r2
	mode <= 3'b0;
	enable <= 1'b0;
	end
else if(day_night == 1'b1) // day time
	case(mode)
		3'd0: begin
			light_led<= 6'b001_100; // g1 : r2
			enable <= 1'b1; // g1 count down
			if(cnt == 8'b0001_0100) // after 8 seconds
			mode <= mode + 3'b1; 
			end
		3'd1:begin
			light_led<= 6'b010_100; // y1 : r2
			enable <= 1'b1;
			if (cnt == 8'b0001_0010) //after 2 seconds
			mode <= mode + 3'b1;
			end
		3'd2:begin// r1 : g2
			light_led<= 6'b100_001;
			enable <= 1'b1;  
			if (cnt == 8'b0000_0100)// after 8 seconds
			mode <= mode + 3'd1; 
			end
		3'd3:begin
			// r1 : y2
			light_led<= 6'b100_010;
			enable <= 1'b1;  
			if (cnt == 8'b0000_0010)// after 2 seconds
			mode <= 3'd0;
			end
	endcase

	else if(day_night == 1'b0) // night time
		light_led<= {{1'b0, clk_cnt_dn, 1'b0}, {1'b0, clk_cnt_dn, 1'b0}}; // y1 flashes : y2 flashes
end
endmodule

//-----------------------------------------------------

module		freq_div(clk_in, reset, clk_out);

parameter	exp = 20;   
input		clk_in, reset;
output		clk_out;
reg			[exp-1:0]divider;
integer 	i;

assign		clk_out = divider[exp-1];

always@ (posedge clk_in or posedge reset)
begin
	if(reset)
		for(i=0; i < exp; i=i+1)
		divider[i] = 1'b0;
	else
		divider = divider+ 1'b1;
end
endmodule

//--------------------------------------------

module	bcd_to_seg7(bcd_in, seg7);

input	[3:0]bcd_in;
output	[6:0]seg7;
reg		[6:0]seg7;

always@ (bcd_in)
begin
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
		default: seg7 = 7'b0000000; 
	endcase
end
endmodule

//--------------------------------------------

module		seg7_select(clk, reset, seg7_sel);

parameter	num_use= 6;
input		clk, reset;
output		[2:0]seg7_sel;
reg			[2:0]seg7_sel;

always@ (posedge clk or posedge reset) 
begin
	if(reset == 1)
		seg7_sel = 3'b101; // the rightmost one
	else
		if(seg7_sel == 6 -num_use)
			seg7_sel = 3'b101;
		else
			seg7_sel = seg7_sel-3'b001; // shift left
end
endmodule

//-----------------------------------------------------

module	idx_gen(clk, rst, idx);

input	clk, rst;
output	[6:0]idx;
reg		[6:0]idx;

always@(posedge clk or posedge rst) 
begin
	if(rst)
		idx= 7'd0;
	else if(idx==7'd8)
			idx= 7'd0;
		else
			idx=idx+7'd08;
end
endmodule

//-------------------------------------------

module	row_gen(clk, rst, idx, row, idx_cnt);

input	clk, rst;
input	[6:0]idx;	//0~80
output	[7:0]row;
output	[6:0]idx_cnt;
reg		[7:0]row;
reg		[6:0]idx_cnt;
reg		[2:0]cnt;

always@(posedge clk or posedge rst) 
begin
	if(rst) 
		begin
		row = 8'b1000_0000;
		cnt = 3'b000;
		idx_cnt = 7'd0;
		end
	else 
		begin
		row = {row[0],row[7:1]}; 	//(輪流將每一列LED致能)
		cnt = cnt+1'b1;      	//(從0數到7) 
		idx_cnt = idx+cnt; 	//(將初始位置加0到7)
		end
end
endmodule