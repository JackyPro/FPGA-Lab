`timescale 1 ns/1 ns
module	lab7_2self(clk, reset, enable, nightcomes, light_led, led_com, ggled,
					seg7, seg7_sel,NS_lights, EW_lights,
					row, column_green, column_red,greenredman_work,cnt,addr,column_out);

input	clk, reset, enable, nightcomes;
output	[5:0]light_led;
output	led_com,ggled;
output	[6:0]seg7;
output	[2:0]seg7_sel,NS_lights, EW_lights;
output wire [6:0]cnt;
output wire	[7:0]column_out;
output wire	[8:0]addr;
wire	[3:0]segg;
wire	[3:0]timer0,timer2;
wire	[1:0]timer1,timer3;
wire	clk_cnt_dn,clk_sel,clk_row;

output wire	[1:0]greenredman_work;

output	[7:0]row, column_green, column_red;
wire 	[7:0]row, column_green, column_red;

assign	light_led={EW_lights,NS_lights};
assign	led_com= 1'b1;
assign	segg=	(seg7_sel == 3'b101 )? timer0 :
				(seg7_sel == 3'b100 )? timer1 :
				(seg7_sel == 3'b011 )? timer2 :
				(seg7_sel == 3'b010 )? timer3 :4'b0;
assign  ggled= 1'b0;

/*				
freq_div	#(4)	u1(.clk_in(clk), .reset(reset), .clk_out(clk_cnt_dn));
freq_div	#(1)	u2(.clk_in(clk),.reset(reset),.clk_out(clk_sel));
freq_div	#(1)	u3(.clk_in(clk),.reset(reset),.clk_out(clk_row));
*/
freq_div	#(23)	u1(.clk_in(clk), .reset(reset), .clk_out(clk_cnt_dn));
freq_div	#(15)	u2(.clk_in(clk),.reset(reset),.clk_out(clk_sel));
freq_div	#(17)	u3(.clk_in(clk),.reset(reset),.clk_out(clk_row));

control 			u4(.clk(clk_cnt_dn), .reset(reset), .enable(enable), .nightcomes(nightcomes),
						.timer3(timer3), .timer2(timer2), .timer1(timer1), .timer0(timer0),
						.greenredman_work(greenredman_work),
						.NS_lights(NS_lights), .EW_lights(EW_lights));
seg7_select	#(4) 	u5(.clk(clk_sel),.reset(reset),.seg7_sel(seg7_sel));
bcd_to_seg7_1 		u6(.bcd_in(segg),.seg7(seg7));

greenredman			u7(.clk(clk_row), .reset(reset), .row(row),
						.column_green(column_green), .column_red(column_red),
						.greenredman_work(greenredman_work),.cnt(cnt),
						.addr(addr), .column_out(column_out));

endmodule
//-----------------------------------------------------
`timescale 1 ns/1 ns
module 	control(clk, reset, enable, nightcomes, timer3, timer2,	timer1, timer0,
				greenredman_work, NS_lights, EW_lights);
input	clk, reset, enable, nightcomes;
//output	[4:0]cnt_d0;
output	[2:0]NS_lights, EW_lights;
//wire	[4:0]cnt_d0;

parameter 	GREEN_LIGHT = 2'b00,
			YELLOW_LIGHT= 2'b01,
			RED_LIGHT   = 2'b10,
			NIGHT		= 2'b11;

// timer starts to count from 0 and
// timer_clr also holds one cycle
parameter 	GREEN_COUNT = 6'h22,//5'd20+2,31-22=9
			YELLOW_COUNT= 6'h05,//5'd03+2,
			RED_COUNT  	= 6'h25,//5'd23+2,
			NIGHT_COUNT	= 6'h06;//5'd04+2;

reg		[2:0]NS_lights, EW_lights, next_NS_lights, next_EW_lights;
reg		[1:0]traffic_state, next_state;
reg		timer_clr, EW_side, next_timer_clr, next_EW_side;
reg		timer_clr2,next_timer_clr2;
//reg		[4:0]timer;
output	[3:0]timer0,timer2;
output	[1:0]timer1,timer3;
wire	[3:0]timer0,timer2;
wire	[1:0]timer1,timer3;

reg		[3:0]timer0reg,timer2reg;
reg		[1:0]timer1reg,timer3reg;

//reg		[4:0]a;
assign 	timer0 = timer0reg;
assign	timer1 = timer1reg;
assign 	timer2 = timer2reg;
assign	timer3 = timer3reg;

reg		[1:0]greenredman_work_reg, next_greenredman_work;

output	wire [1:0]greenredman_work;

assign	greenredman_work=greenredman_work_reg;


always @(posedge clk or posedge reset)
begin
  if (reset) begin
	traffic_state <= #1 GREEN_LIGHT;
    timer_clr     <= #1 1'b1;
	timer_clr2    <= #1 1'b1;
    EW_side       <= #1 1'b1;
    EW_lights     <= #1 3'b100;
    NS_lights     <= #1 3'b001;
	greenredman_work_reg<= #1 2'b00;
	end
  else
	//if(enable==1'b1) 
	begin
	  traffic_state <= #1 next_state;
	  timer_clr     <= #1 next_timer_clr;
	  timer_clr2    <= #1 next_timer_clr2;
	  EW_side       <= #1 next_EW_side;
	  EW_lights     <= #1 next_EW_lights;
	  NS_lights     <= #1 next_NS_lights;

	  greenredman_work_reg	<= #1 next_greenredman_work;
	end
end

always @(traffic_state  or EW_side  or EW_lights or NS_lights  or nightcomes
			or timer_clr or timer_clr2
			or timer1reg or timer0reg or timer3reg or timer2reg
			or greenredman_work_reg)
begin
    next_state     = traffic_state;
    next_timer_clr = timer_clr;
	next_timer_clr2= timer_clr2;
    next_EW_side   = EW_side;
    next_EW_lights = EW_lights;
    next_NS_lights = NS_lights;
	next_greenredman_work	= greenredman_work_reg;
    case (traffic_state)
      GREEN_LIGHT : begin
				next_timer_clr = 1'b0;
				//next_green_or_red=1'b0;
				next_greenredman_work=2'b00;
				if (EW_side==1'b1) begin
					next_EW_lights = 3'b100; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
					end
				else begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b100; //{g,y,r}
					
					end
				if ({timer1reg,timer0reg}==6'h10) begin
					//next_timer_clr = 1'b1;
					next_state     = YELLOW_LIGHT;
					end
				if (nightcomes==1'b1) begin
					next_timer_clr = 1'b1;
					next_state     = NIGHT;
					next_greenredman_work=2'b10;
					end				
		    end

      YELLOW_LIGHT : begin
				
				//next_timer_clr = 1'b0;
				
				if (EW_side==1'b1) begin
					next_EW_lights = 3'b010; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
					end
				else begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b010; //{g,y,r}
					end
				if ({timer1reg,timer0reg}==6'h04) begin
					//next_timer_clr = 1'b1;
					next_state     = RED_LIGHT;
					end
				if (nightcomes==1'b1) begin
					next_timer_clr2 = 1'b1;
					next_state     = NIGHT;
					next_greenredman_work=2'b10;
					end	
		    end

      RED_LIGHT : begin
				//next_timer_clr = 1'b0;
				
				next_greenredman_work=2'b01;
				if(EW_side==1'b1) begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
				end
				else begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
				end
				if({timer1reg,timer0reg}==6'h01) begin
					next_timer_clr = 1'b1;
					next_state     = GREEN_LIGHT;
					next_EW_side   = ~EW_side;
					
				end
				if (nightcomes==1'b1) begin
					next_timer_clr = 1'b1;
					next_state     = NIGHT;
					next_greenredman_work=2'b10;
				end
					
		    end
	  NIGHT:  begin
				next_timer_clr2 = 1'b0;
				next_EW_lights = 3'b010; //{g,y,r}
				next_NS_lights = 3'b010; //{g,y,r}
				if({timer3reg,timer2reg}==6'h01) begin
					next_timer_clr2	= 1'b1;
					if(nightcomes==1'b0)
					next_state		= GREEN_LIGHT;
					else
					next_state		=NIGHT;
				end
			end
      default	: begin
		    next_state     = GREEN_LIGHT;
			next_timer_clr = 1'b0;
		    next_EW_side   = 1'b1;
		    next_EW_lights = 3'b100; //{g,y,r}
		    next_NS_lights = 3'b001; //{g,y,r}
			next_greenredman_work=2'b00;
			
		  end
    endcase
end

always @(posedge clk or posedge reset)
begin
	if(reset) 
		begin
		timer1reg<=2'd3;
		timer0reg<=4'd1;
		end
	else 	
		//if(enable == 1'b1)
			if (timer_clr==1'b1)begin
				timer1reg<=2'd2;
				timer0reg<=4'd0;
				end
			else
				if({timer1reg,timer0reg}>6'd0)
					if(timer0reg>4'd0)
							timer0reg<=timer0reg-4'd1;				
					else begin
						timer0reg<=4'd9;
						timer1reg<=timer1reg-2'd1;
						end
				else begin
					timer1reg<=2'd2;
					timer0reg<=4'd0;
					end
end

always @(posedge clk or posedge reset)
begin
	if(reset) 
		begin
		timer3reg<=2'd3;
		timer2reg<=4'd1;
		end
	else 	
		//if(enable == 1'b1)
			if (timer_clr2==1'b1)begin
				timer3reg<=2'd0;
				timer2reg<=4'd6;
				end
			else
				if({timer3reg,timer2reg}>6'd0)
					if(timer2reg>4'd0)
							timer2reg<=timer2reg-4'd1;				
					else begin
						timer2reg<=4'd9;
						timer3reg<=timer3reg-2'd1;
						end
				else begin
					timer3reg<=2'd0;
					timer2reg<=4'd6;
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
//---------------------------------------------
module	greenredman(clk, reset, row, column_green, column_red
					, greenredman_work, cnt, addr, column_out);
input 	clk,reset;
//input	[1:0]sel;
output	[7:0]row, column_green, column_red;
wire	[7:0]row, column_green, column_red;

output 	[6:0]cnt;
wire	[6:0]cnt;
output wire	[7:0]column_out;
output wire	[8:0]addr;
input	[1:0]greenredman_work;

assign 	column_green= (greenredman_work== 2'b00 || greenredman_work== 2'b10)? column_out: 8'b01111111;
assign 	column_red	= (greenredman_work== 2'b01 || greenredman_work== 2'b10)? column_out: 8'b11111110;

assign	addr={greenredman_work,cnt};
//assign	addr={greenredman_work,cnt};

//freq_div#(22) M1 (clk,reset,clk_idx);
//freq_div#(6) M1 (clk,reset,clk_idx);

//freq_div#(1) M2 (clk,reset,clk_row);
//idx_gen M3 (clk_idx,reset,idx); 
row_gen 	M4(clk, reset, row, cnt);
rom_char	M5(addr, column_out);

endmodule
//---------------------------------------------------------------------
module 	rom_char(addr, data);

input	[8:0]addr;
output	[7:0]data;

reg		[7:0]data;

always@(addr) 
begin
		case(addr)
		//----1------------------
		9'b00_0000_000: 	data=8'b01100000;		
		9'b00_0000_001: 	data=8'b01100000;	
		9'b00_0000_010: 	data=8'b00110000; 	
		9'b00_0000_011: 	data=8'b01111000;
		9'b00_0000_100: 	data=8'b00011000;		
		9'b00_0000_101: 	data=8'b00110100;	
		9'b00_0000_110: 	data=8'b00100010;		
		9'b00_0000_111: 	data=8'b01100110;
		//----2------------------
		9'b00_0001_000: 	data=8'b01100000;		
		9'b00_0001_001: 	data=8'b01100000;	
		9'b00_0001_010: 	data=8'b00110000; 	
		9'b00_0001_011: 	data=8'b01111100;
		9'b00_0001_100: 	data=8'b01011010;	
		9'b00_0001_101: 	data=8'b00110100;
		9'b00_0001_110: 	data=8'b01100010;	
		9'b00_0001_111: 	data=8'b01000010;
		//----3------------------
		9'b00_0010_000: 	data=8'b01100000;	
		9'b00_0010_001: 	data=8'b01100000;	
		9'b00_0010_010: 	data=8'b00110000;		
		9'b00_0010_011: 	data=8'b01111100;	
		9'b00_0010_100: 	data=8'b10110010;		
		9'b00_0010_101: 	data=8'b00011000;	
		9'b00_0010_110: 	data=8'b01100110;		
		9'b00_0010_111: 	data=8'b00000010;
		//----4------------------
		9'b00_0011_000: 	data=8'b11000000;	
		9'b00_0011_001: 	data=8'b11000000;	
		9'b00_0011_010: 	data=8'b01111000;		
		9'b00_0011_011: 	data=8'b01100100;	
		9'b00_0011_100: 	data=8'b10110000;		
		9'b00_0011_101: 	data=8'b00101000;	
		9'b00_0011_110: 	data=8'b11000110;		
		9'b00_0011_111: 	data=8'b00000010;
		//----5------------------
		9'b00_0100_000: 	data=8'b11000000;	
		9'b00_0100_001: 	data=8'b11000000;	
		9'b00_0100_010: 	data=8'b01100000;		
		9'b00_0100_011: 	data=8'b01111000;	
		9'b00_0100_100: 	data=8'b10110100;		
		9'b00_0100_101: 	data=8'b00111010;	
		9'b00_0100_110: 	data=8'b00100110;		
		9'b00_0100_111: 	data=8'b11100010;
		//----6------------------
		9'b00_0101_000: 	data=8'b11000000;	
		9'b00_0101_001: 	data=8'b11000000;	
		9'b00_0101_010: 	data=8'b01100000;		
		9'b00_0101_011: 	data=8'b01111000;	
		9'b00_0101_100: 	data=8'b10110100;		
		9'b00_0101_101: 	data=8'b00110010;	
		9'b00_0101_110: 	data=8'b01001100;		
		9'b00_0101_111: 	data=8'b11000100;
		//----7------------------
		9'b00_0110_000: 	data=8'b11000000;	
		9'b00_0110_001: 	data=8'b11000000;	
		9'b00_0110_010: 	data=8'b01100000;		
		9'b00_0110_011: 	data=8'b01111000;	
		9'b00_0110_100: 	data=8'b01110100;		
		9'b00_0110_101: 	data=8'b00110000;	
		9'b00_0110_110: 	data=8'b01011000;		
		9'b00_0110_111: 	data=8'b00101000;
		//----8-----------------
		9'b00_0111_000: 	data=8'b01100000;	
		9'b00_0111_001: 	data=8'b01100000;	
		9'b00_0111_010: 	data=8'b00110000;		
		9'b00_0111_011: 	data=8'b00111000;	
		9'b00_0111_100: 	data=8'b00011000;		
		9'b00_0111_101: 	data=8'b00010100;	
		9'b00_0111_110: 	data=8'b00011100;		
		9'b00_0111_111: 	data=8'b00000100;
		//----red----------------
		9'b01_1000_000: 	data=8'b00011000;	
		9'b01_1000_001: 	data=8'b00011000;	
		9'b01_1000_010: 	data=8'b00111100;		
		9'b01_1000_011: 	data=8'b01011010;	
		9'b01_1000_100: 	data=8'b01011010;		
		9'b01_1000_101: 	data=8'b00011000;	
		9'b01_1000_110: 	data=8'b00110100;		
		9'b01_1000_111: 	data=8'b01100110;
		//----yellow----------------
		9'b10_1001_000: 	data=8'b00000000;	
		9'b10_1001_001: 	data=8'b01111110;	
		9'b10_1001_010: 	data=8'b01000010;		
		9'b10_1001_011: 	data=8'b01011010;	
		9'b10_1001_100: 	data=8'b01011010;		
		9'b10_1001_101: 	data=8'b01000010;	
		9'b10_1001_110: 	data=8'b01111110;		
		9'b10_1001_111: 	data=8'b00000000;
		
		default: 			data=8'b11100111;
		endcase
end
endmodule
//---------------------------------------------------
/*module 	idx_gen(clk, reset, idx);
input 	clk,reset;
output	[6:0]idx;
reg		[6:0]idx;

always@(posedge clk or posedge reset) 
begin
	if(reset)
		idx= 7'd0;
	else 
			if(idx==7'd80)
				idx= 7'd0;
			else
				idx=idx+7'd08;
end
endmodule*/
//---------------------------------------------------
module 	row_gen(clk, reset, row, cnt);
input 	clk, reset;
//input	[6:0]idx;
output	[7:0]row;
output	[6:0]cnt;
reg		[7:0]row;
//reg		[6:0]idx_cnt;
reg		[6:0]cnt;

always@(posedge clk or posedge reset) 
begin
	if(reset) begin
		row		=8'b1000_0000;
		cnt		=4'd0;
		//idx_cnt	=7'd0;
		end
	else 
		if(cnt==7'd80)
			cnt=7'd0;
		else begin
			row		={row[0],row[7:1]} ;    	//(??????????????????LED??????)
			cnt		=cnt+7'd1;        	//(???0??????7) 
			//idx_cnt	=idx+cnt;  	//(??????????????????0???7)
			end
end
endmodule
