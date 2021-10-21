module	lab7_1(clk, reset, day_night, light_led, led_com, seg7, seg7_sel);

input	clk;
input	reset;
input	day_night;
output	[5:0]light_led;
output	led_com;
output	[6:0]seg7;
output	[2:0]seg7_sel;
wire	clk_cnt_dn, clk_yellow, clk_sel;
wire	[7:0]g1_cnt;
wire	[3:0]segg;

assign	led_com= 1'b1;
assign	segg=(seg7_sel == 3'b100 )? g1_cnt[7:4] : 
					(seg7_sel == 3'b101 )? g1_cnt[3:0] :4'b0;
					
freq_div#(23)(clk, reset, clk_cnt_dn);
freq_div#(25)(clk, reset, clk_yellow);
freq_div#(15)(clk, reset, clk_sel);
traffic	(clk_cnt_dn, clk_yellow, reset, day_night, light_led, g1_cnt);
seg7_select#(2)(clk_sel, reset, seg7_sel);
bcd_to_seg7_1(segg, seg7);
endmodule
//-----------------------------------------------------
module	traffic (clk_1, clk_2, reset, day_night, light_led, g1_cnt);

input 	clk_1, clk_2, reset, day_night;
output	[5:0]light_led;
wire	g1_en;
wire	[7:0]g1_cnt;
output	[7:0]g1_cnt;

ryg_ctl (clk_1, clk_2, reset, day_night, g1_cnt, g1_en, light_led);
light_cnt_dn_25 (clk_1, reset, g1_en, g1_cnt);

endmodule
//-----------------------------------------------------
module 	light_cnt_dn_25 (clk, reset, enable, cnt);

input	clk, reset, enable;
output	[7:0]cnt;
reg		[7:0]cnt;

always@(posedge clk or posedge reset) 
begin
	if(reset)
		cnt= 8'b0; // initial state
	else if(enable)  // 0 -> 25 -> 24 -> ... -> 1 -> 0 -> 25
		if(cnt== 8'b0)
			cnt=8'b0010_0101;  // 25
		else if(cnt[3:0] == 4'd0)
			begin  // 20 -> 19, 10 -> 09
			cnt[7:4]=cnt[7:4]-4'b1; 
			cnt[3:0]=4'd9;	  
			end
		else
			cnt[3:0]=cnt[3:0]-4'd1;  // 19 -> 18, 18 -> 17, 17 -> 16, …	
end
endmodule
//------------------------------------------------------
module 	ryg_ctl(clk_1, clk_2, reset, day_night, g1_cnt, g1_en, light_led);

input	clk_1, clk_2, reset, day_night;
input	[7:0]g1_cnt;
output	g1_en;
output	[5:0]light_led;
reg 	g1_en;
reg		[5:0]light_led;
reg		[2:0]mode;

always@(posedge clk_1 or posedge reset) 
begin
	if (reset)
		begin
		light_led	= 6'b001_100; // g1 : r2
		mode 		= 3'b0;
		g1_en 		= 1'b0;
		end
	else if(day_night == 1'b1) // day time
		case(mode)
		3'd0: 
			begin
			light_led	= 6'b001_100; // g1 : r2
			g1_en 		= 1'b1; // g1 count down
			if(g1_cnt == 8'b0001_0010) //  13 seconds
				mode 	= mode + 3'b1; 
			end
		3'd1:
			begin// y1 : r2
			light_led	= 6'b010_100; // y1 : r2
			if (g1_cnt == 8'b0000_0110) //  7 seconds
				//after 7 seconds
				mode 	= mode + 3'b1; 
			end	
			/*
			else
				light_led[3] = clk_cnt_dn; // g1 flashes
			end
			*/
		3'd2:
			begin// r1 : r2
			light_led	= 6'b100_100;  
			if(g1_cnt == 8'b0000_0000) 
				begin// after 4 seconds
				g1_en 	= 1'b0;
				mode 	= mode + 3'b1; 
				end

		end
		3'd3: 
			begin// r1 : g2
			light_led	= 6'b100_001;
			g1_en = 1'b1;
			if(g1_cnt == 8'b0001_0010) //  13 seconds
				mode 	= mode+ 3'b1; 
			end

		3'd4:
			begin// r1 : y2
			light_led	= 6'b100_010;
			if (g1_cnt == 8'b0000_0110) //  7 seconds
				begin // after 5 seconds
				mode 	= mode + 3'b1; 
				//g2_en 	= 1'b0;
				end
			/*
			else
				light_led[0] = clk_cnt_dn; // g2 flashes
			end
			*/
			end
		3'd5:
			begin// r1 : r2
			light_led	= 6'b100_100;  
			if(g1_cnt == 8'b0000_0000) 
				begin// after 4 seconds
				g1_en 	= 1'b0;
				mode 	= 3'b0; 
				end
			end
		default:
			begin
			light_led	= 6'b001_100; // g1 : r2
			g1_en 		= 1'b1; // g1 count down
			if(g1_cnt == 8'b0001_0010) //  13 seconds
				mode 	= mode + 3'b1; 
			end
		endcase

	else if(day_night == 1'b0)begin // night time
		light_led= {{1'b0, clk_2, 1'b0}, {1'b0, clk_2, 1'b0}}; // y1 flashes : y2 flashes
		g1_en=1'b0;
		//light_led[5]=3'b0;light_led[3]=3'b0;light_led[2]=3'b0;light_led[0]=3'b0;
		//light_led[4]=~light_led[4];
		//light_led[1]=~light_led[1];
		end
end
endmodule
//-------------------------------------------------
module 		freq_div(clk_in,reset,clk_out);

parameter	exp = 20;   
input		clk_in, reset;
output		clk_out;
reg			[exp-1:0] divider;
integer 	i;

assign 	clk_out= divider[exp-1];

always@ (posedge clk_in or posedge reset)
begin
	if(reset)
		for(i=0; i < exp; i=i+1)
		divider[i] = 1'b0;
	else
		divider = divider+ 1'b1;
end
endmodule
//-------------------------------------------------
module bcd_to_seg7_1(bcd_in,seg7);

input	[3:0]bcd_in;
output	[6:0]seg7;
reg		[6:0]seg7;

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
//--------------------------------------------
module 		seg7_select(clk,reset,seg7_sel);

parameter	num_use= 6;
input		clk,reset;
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