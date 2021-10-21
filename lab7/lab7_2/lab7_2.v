module	lab7_2(clk, reset, day_night, light_led, led_com, seg7, seg7_sel, row, column_green, column_red);

input	clk;
input	reset;
input	day_night;
output	[5:0]light_led;
output	led_com;
output	[6:0]seg7;
output	[2:0]seg7_sel;
output	[7:0]column_green, column_red;
output	[7:0]row;
wire	clk_cnt, clk_sel;
wire	[7:0]g1_cnt;
wire	[3:0]count_out;
wire	[1:0]light_mode;

assign	led_com= 1'b1;
assign	count_out = (seg7_sel == 3'b101)&&(light_mode!= 2'b11) ? g1_cnt[3:0] :
					(seg7_sel == 3'b100)&&(light_mode!= 2'b11) ? g1_cnt[7:4] :
					(seg7_sel == 3'b011)&&(light_mode== 2'b11) ? g1_cnt[3:0] :
					(seg7_sel == 3'b010)&&(light_mode== 2'b11) ? g1_cnt[7:4] : 4'd0;
					
freq_div	#(23)(clk, reset, clk_cnt);
freq_div	#(15)(clk, reset, clk_sel);
traffic			(clk_cnt, reset, day_night, light_led, g1_cnt, light_mode);
greenredman		(clk, reset, light_mode, row, column_green, column_red);
seg7_select	#(4)(clk_sel, reset, seg7_sel);
bcd_to_seg7_1 (count_out, seg7);
endmodule
//-----------------------------------------------------
module	traffic (clk_cnt, reset, day_night, light_led, g1_cnt, light_mode);

input 	clk_cnt, reset, day_night;
output	[5:0]light_led;
wire	g1_en;
output	wire[7:0]g1_cnt;
output	wire[1:0]light_mode;

ryg_ctl (clk_cnt, reset, day_night, g1_cnt, g1_en, light_led, light_mode);
light_cnt_dn_29 (clk_cnt, reset, g1_en, g1_cnt);

endmodule
//-----------------------------------------------------
module 	light_cnt_dn_29(clk, reset, enable, cnt);

input	clk, reset, enable;
output	[7:0]cnt;
reg		[7:0]cnt;

always@(posedge clk or posedge reset) 
begin
	if(reset)
		cnt= 8'b0; // initial state
	else if(enable)  
		if(cnt== 8'b0)
			cnt=8'b0010_1001;  // 29
		else if(cnt[3:0] == 4'd0)
			begin  // 20 -> 19, 10 -> 09
			cnt[7:4]=cnt[7:4]-4'b1; 
			cnt[3:0]=4'd9;	  
			end
			else
				cnt[3:0]=cnt[3:0]-4'd1;  // 19 -> 18, 18 -> 17, 17 -> 16, …	
		else
			cnt=8'd0;
end
endmodule
//------------------------------------------------------
module 	ryg_ctl(clk_cnt, reset, day_night, g1_cnt, g1_en, light_led, light_mode);

input	clk_cnt, reset, day_night;
input	[7:0]g1_cnt;
output	g1_en;
output	[5:0]light_led;
reg 	g1_en;
reg		[5:0]light_led;
reg		[2:0]mode;
output reg [1:0]light_mode;

always@(posedge clk_cnt or posedge reset) 
begin
	if (reset)
		begin
		light_led	= 6'b001_100; // g1 : r2
		mode 		= 3'b0;
		g1_en 		= 1'b0;
		light_mode	= 2'b00;
		end
	else if(day_night == 1'b1) // day time
		case(mode)
		3'd0: 
			begin
			light_led	= 6'b001_100; 		// g1 : r2
			g1_en 		= 1'b1; 			// g1 count down
			light_mode	= 2'b00;
			if(g1_cnt 	== 8'b0001_0010) 	//10+2s
				mode 	= mode + 3'b1; 
			end
		3'd1:
			begin
			{light_led[5],light_led[4],light_led[2],light_led[1],light_led[0]}=5'b00100;
			light_led[3]=~light_led[3]; 	// g1 flashes : r2
			g1_en 		= 1'b1;
			light_mode	= 2'b01;
			if (g1_cnt 	== 8'b0000_1000)	//6+2s
				mode 	= mode + 3'b1; 
			end	
		3'd2:
			begin
			light_led	= 6'b010_100;  		// y1 : r2
			g1_en 		= 1'b1;
			light_mode	= 2'b10;
			if(g1_cnt 	== 8'b0000_0010) 	//0+2s
				begin
				g1_en 	= 1'b0;
				mode 	= mode + 3'b1;
				light_mode	= 2'b10;				
				end

			end
		3'd3: 
			begin
			light_led	= 6'b100_001;		// r1 : g2
			g1_en 		= 1'b1;
			light_mode	= 2'b11;
			if(g1_cnt 	== 8'b0001_0010) 	//10+2s
				mode 	= mode+ 3'b1; 
			end

		3'd4:
			begin
			{light_led[5],light_led[4],light_led[3],light_led[2],light_led[1]}=5'b10000;
			light_led[0]= ~light_led[0];	// r1 : g2 flash
			g1_en 		= 1'b1;
			light_mode	= 2'b11;
			if (g1_cnt 	== 8'b0000_1000) 	//6+2s
				begin 
				mode 	= mode + 3'b1; 
				end

			end
		3'd5:
			begin// r1 : y2
			light_led	= 6'b100_010; 
			g1_en 		= 1'b1;
			light_mode	= 2'b11;
			if(g1_cnt 	== 8'b0000_0010) //0+2s
				begin
				g1_en 	= 1'b0;
				mode 	= 3'b0;
				light_mode	= 2'b11;				
				end
			end
		default:
			begin
			light_led	= 6'b001_100; // g1 : r2
			g1_en 		= 1'b1; // g1 count down
			light_mode	= 2'b00;
			if(g1_cnt 	== 8'b0000_1001) //10+2s
				mode 	= mode + 3'b1; 
			end
		endcase

	else if(day_night == 1'b0)
		begin // night time
									// y1 flashes : y2 flashes
		{light_led[0],light_led[2],light_led[3],light_led[5]}=4'b0000;
		{light_led[1],light_led[4]}=~{light_led[1],light_led[4]};
		g1_en			=	1'b0;
		light_mode		= 	2'b11;
		mode			=	3'd0;
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
//-------------------------------------------------
module	greenredman(clk, reset, sel_mode, row, column_green, column_red);

input 	clk, reset;
input	[1:0]sel_mode;
output	[7:0]row, column_green, column_red;
wire 	clk_shift, clk_scan;
wire	[7:0]idx, idx_cnt;
wire	[7:0]column_out;

assign	column_green	=((sel_mode==2'b00)||(sel_mode==2'b01)||(sel_mode==2'b10))?column_out:8'b0;
assign	column_red		=((sel_mode==2'b10)||(sel_mode==2'b11))?column_out:8'b0;

//freq_div#(22) M1(clk, reset, clock_shift);
//freq_div#(12) M2(clk, reset, clock_scan);
freq_div#(18) M1(clk, reset, clk_shift);
freq_div#(11) M2(clk, reset, clk_scan);
idx_gen 	M3(clk_shift, reset, sel_mode, idx); 
row_gen 	M4(clk_scan, reset, idx, row, idx_cnt);
rom_char1	M5(idx_cnt, column_out);
//rom_char2 M9 (idx_cnt, column_out2, column_green2, column_red2);

endmodule

//-------------------------------------------------------
module	rom_char1(addr, data);

input	[6:0]addr;
output	[7:0]data;
reg		[7:0]data;
always@(addr) 
begin
	case(addr)
		//----1------------------
		7'd0	: 	data =8'b01100000;		
		7'd1	: 	data =8'b01100000;	
		7'd2	: 	data =8'b00110000; 	
		7'd3	: 	data =8'b01111000;
		7'd4	: 	data =8'b00011000;		
		7'd5	: 	data =8'b00110100;	
		7'd6	: 	data =8'b00100010;		
		7'd7	: 	data =8'b01100110;
		//----2------------------
		7'd8	: 	data =8'b01100000;		
		7'd9	: 	data =8'b01100000;	
		7'd10	: 	data =8'b00110000; 	
		7'd11	: 	data =8'b01111100;
		7'd12	: 	data =8'b01011010;	
		7'd13	: 	data =8'b00110100;
		7'd14	: 	data =8'b01100010;	
		7'd15	: 	data =8'b01000010;
		//----3------------------
		7'd16	: 	data =8'b01100000;	
		7'd17	: 	data =8'b01100000;	
		7'd18	: 	data =8'b00110000;		
		7'd19	: 	data =8'b01111100;	
		7'd20	: 	data =8'b10110010;		
		7'd21	: 	data =8'b00011000;	
		7'd22	: 	data =8'b01100110;		
		7'd23	: 	data =8'b00000010;
		//----4------------------
		7'd24	: 	data =8'b11000000;	
		7'd25	: 	data =8'b11000000;	
		7'd26	: 	data =8'b01111000;		
		7'd27	: 	data =8'b01100100;	
		7'd28	: 	data =8'b10110000;		
		7'd29	: 	data =8'b00101000;	
		7'd30	: 	data =8'b11000110;		
		7'd31	: 	data =8'b00000010;
		//----5------------------
		7'd32	: 	data =8'b11000000;	
		7'd33	: 	data =8'b11000000;	
		7'd34	: 	data =8'b01100000;		
		7'd35	: 	data =8'b01111000;	
		7'd36	: 	data =8'b10110100;		
		7'd37	: 	data =8'b00111010;	
		7'd38	: 	data =8'b00100110;		
		7'd39	: 	data =8'b11100010;
		//----6------------------
		7'd40	: 	data =8'b11000000;	
		7'd41	: 	data =8'b11000000;	
		7'd42	: 	data =8'b01100000;		
		7'd43	: 	data =8'b01111000;	
		7'd44	: 	data =8'b10110100;		
		7'd45	: 	data =8'b00110010;	
		7'd46	: 	data =8'b01001100;		
		7'd47	: 	data =8'b11000100;
		//----7------------------
		7'd48	: 	data =8'b11000000;	
		7'd49	: 	data =8'b11000000;	
		7'd50	: 	data =8'b01100000;		
		7'd51	: 	data =8'b01111000;	
		7'd52	: 	data =8'b01110100;		
		7'd53	: 	data =8'b00110000;	
		7'd54	: 	data =8'b01011000;		
		7'd55	: 	data =8'b00101000;
		//----8-----------------
		7'd56	: 	data =8'b01100000;	
		7'd57	: 	data =8'b01100000;	
		7'd58	: 	data =8'b00110000;		
		7'd59	: 	data =8'b00111000;	
		7'd60	: 	data =8'b00011000;		
		7'd61	: 	data =8'b00010100;	
		7'd62	: 	data =8'b00011100;		
		7'd63	: 	data =8'b00000100;
		//----yellow & red------
		7'd64 	: 	data =8'b00011000;
 		7'd65 	: 	data =8'b00011000;
		7'd66	: 	data =8'b00111100;
 		7'd67	: 	data =8'b01011010;
		7'd68	: 	data =8'b01011010; 		
		7'd69	: 	data =8'b00011000;
		7'd70	: 	data =8'b00100100;
 		7'd71	: 	data =8'b01100110;
		default	:	data =8'b00000000;
	endcase
end
endmodule

//-----------------------------------------------------------

module	idx_gen(clk, reset, sel_mode, idx);

input 	clk, reset;
input	[1:0]sel_mode;
output	[6:0]idx;
reg		[6:0]idx, delay;

always@(posedge clk or posedge reset) 
begin
	if(reset)
		idx= 7'd0;
	else
		if(sel_mode==2'b00)//green
			begin
			if(idx==7'd56)
				if(delay==7'd2)
					begin
					idx = 7'd0;
					delay= 7'd0;
					end
				else
					delay= delay+7'd1;
			else
				if(delay==7'd2)
					begin
					idx = idx +7'd8;
					delay= 7'd0;
					end
				else
					delay= delay+7'd1;
			end
			
		else if(sel_mode==2'b01)//green flash
			begin
			if(idx==7'd56)
				idx = 7'd0;
			else
				idx = idx + 7'd8;			
			end
			
		else if((sel_mode==2'b10)||(sel_mode==2'b11))//yellow
			begin
			idx = 7'd64; 
			end	
			
		//else idx=7'd0;
end
endmodule

//----------------------------------------------

module	row_gen(clk, reset, idx, row, idx_cnt);

input 	clk, reset;
input	[6:0]idx;
output	[7:0]row;
output	[6:0]idx_cnt;
reg		[7:0]row;
reg		[6:0]idx_cnt;
reg		[2:0]cnt;

always@(posedge clk or posedge reset) 
begin
	if(reset) 
		begin
		row = 8'b1000_0000;
		cnt = 3'd0;
		idx_cnt = 7'd0;
		end
	else 
		begin
		row = {row[0],row[7:1]};	//(輪流將每一列LED致能)
		if(cnt==3'd7) 
			begin
			cnt = 3'd0;
			idx_cnt = idx; 
			end
		else 
			begin
			cnt = cnt+3'd1;				//(從0數到7) 
			idx_cnt = idx+cnt;		//(將初始位置加0到7)
			end
		end
end
endmodule
