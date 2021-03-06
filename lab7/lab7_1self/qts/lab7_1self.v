`timescale 1 ns/1 ns
module	lab7_1self(clk, reset, enable, day_night, light_led, led_com,
					seg7, seg7_sel,NS_lights, EW_lights);

input	clk, reset, enable, day_night;
output	[5:0]light_led;
output	led_com;
output	[6:0]seg7;
output	[2:0]seg7_sel,NS_lights, EW_lights;

wire	[3:0]cnt_d0,segg;
wire	clk_cnt_dn,clk_sel;

assign	light_led={EW_lights,NS_lights};
assign	led_com= 1'b1;
assign	segg=	cnt_d0;
//(seg7_sel == 3'b010 )? cnt_d0: 
				//	(seg7_sel == 3'b011 )? cnt_d0:4'b0;

freq_div	#(23)u1(.clk_in(clk), .reset(reset), .clk_out(clk_cnt_dn));
freq_div	#(15)u2(.clk_in(clk),.reset(reset),.clk_out(clk_sel));
control 		u3(.clk(clk_cnt_dn), .reset(reset), .enable(enable), .day_night(day_night),
					.cnt_d0(cnt_d0),.NS_lights(NS_lights), .EW_lights(EW_lights));
seg7_select	#(4) u4(.clk(clk_sel),.reset(reset),.seg7_sel(seg7_sel));
bcd_to_seg7_1 	u5(.bcd_in(segg),.seg7(seg7));
endmodule
//-----------------------------------------------------
module 	control(clk, reset, enable, day_night, cnt_d0, NS_lights, EW_lights);
input	clk, reset, enable, day_night;
output	[4:0]cnt_d0;
output	[2:0]NS_lights, EW_lights;
wire	[4:0]cnt_d0;
wire	nee;

parameter 	GREEN_LIGHT = 2'b00,
			YELLOW_LIGHT= 2'b01,
			RED_LIGHT   = 2'b10,
			NIGHT		= 2'b11;

// timer starts to count from 0 and
// timer_clr also holds one cycle
parameter 	GREEN_COUNT = 5'd20-2,
			YELLOW_COUNT= 4'd03-2,
			RED_COUNT  	= 5'd23-2,
			NIGHT_COUNT	= 4'd04-2;

reg		[2:0]NS_lights, EW_lights, next_NS_lights, next_EW_lights;
reg		[1:0]traffic_state, next_state;
reg		timer_clr, EW_side, next_timer_clr, next_EW_side;
reg 	nightcomes, next_nightcomes;
reg		[4:0]timer;

assign	nee=day_night;
assign 	cnt_d0 = timer;
assign	nightcimes=nee;
always @(posedge clk or negedge reset)
begin
  if (!reset) begin
	traffic_state <= #1 GREEN_LIGHT;
    timer_clr     <= #1 1'b1;
    EW_side       <= #1 1'b1;
    EW_lights     <= #1 3'b100;
    NS_lights     <= #1 3'b001;
	nightcomes	  <= #1 1'b0;
	end
  else
	begin
	  traffic_state <= #1 next_state;
	  timer_clr     <= #1 next_timer_clr;
	  EW_side       <= #1 next_EW_side;
	  EW_lights     <= #1 next_EW_lights;
	  NS_lights     <= #1 next_NS_lights;
	  nightcomes	<= #1 next_nightcomes;
	end
end

always @(*)
begin
    next_state     = traffic_state;
    next_timer_clr = timer_clr;
	next_nightcomes= nightcomes;
    next_EW_side   = EW_side;
    next_EW_lights = EW_lights;
    next_NS_lights = NS_lights;
    case (traffic_state)
      GREEN_LIGHT : begin
				next_timer_clr = 1'b0;
				if (EW_side==1'b1) begin
					next_EW_lights = 3'b100; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
				end
				else begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b100; //{g,y,r}
				end
				if (timer==GREEN_COUNT) begin
					next_timer_clr = 1'b1;
					next_state     = YELLOW_LIGHT;
				end
				if (nightcomes==1'b1) begin
					next_state     = NIGHT;
				end				
		    end

      YELLOW_LIGHT : begin
				next_timer_clr = 1'b0;
				if (EW_side==1'b1) begin
					next_EW_lights = 3'b010; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
				end
				else begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b010; //{g,y,r}
				end
				if (timer==YELLOW_COUNT) begin
					next_timer_clr = 1'b1;
					next_state     = RED_LIGHT;
				end
				if (nightcomes==1'b1) begin
					next_state     = NIGHT;
				end	
		    end

      RED_LIGHT : begin
				next_timer_clr = 1'b0;
				if(EW_side==1'b1) begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
				end
				else begin
					next_EW_lights = 3'b001; //{g,y,r}
					next_NS_lights = 3'b001; //{g,y,r}
				end
				if(timer==RED_COUNT) begin
					next_timer_clr = 1'b1;
					next_state     = GREEN_LIGHT;
					next_EW_side   = ~EW_side;
				end
				if (nightcomes==1'b1) 
					next_state     = NIGHT;
					
		    end
	  NIGHT:  begin
				next_timer_clr = 1'b0;
				next_EW_lights = 3'b010; //{g,y,r}
				next_NS_lights = 3'b010; //{g,y,r}
				if(timer==NIGHT_COUNT) begin
					next_timer_clr = 1'b1;
					next_nightcomes= 1'b0;
					next_state     = GREEN_LIGHT;			
				end
			end
      default	: begin
		    next_state     = GREEN_LIGHT;
			next_timer_clr = 1'b1;
			next_nightcomes= 1'b0;
		    next_EW_side   = 1'b1;
		    next_EW_lights = 3'b100; //{g,y,r}
		    next_NS_lights = 3'b001; //{g,y,r}
		  end
    endcase
end

always @(posedge clk or negedge reset)
begin
  if (!reset)
    timer <= #1 4'd0;
  else
      if (timer_clr==1'b1)
		timer <= #1 4'd0;
      else
		timer <= #1 timer + 4'd01;
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