`timescale 1 ns/1 ns
module	lab7_1self(clk, reset, enable, nightcomes, light_led, led_com,
					seg7, seg7_sel,NS_lights, EW_lights);

input	clk, reset, enable, nightcomes;
output	[5:0]light_led;
output	led_com;
output	[6:0]seg7;
output	[2:0]seg7_sel,NS_lights, EW_lights;

wire	[3:0]segg;
wire	[3:0]timer0;
wire	timer1;
wire	clk_cnt_dn,clk_sel;

assign	light_led={EW_lights,NS_lights};
assign	led_com= 1'b1;
assign	segg=	(seg7_sel == 3'b101 )? timer0 :
				(seg7_sel == 3'b100 )? timer1 :4'b0;

//freq_div	#(23)u1(.clk_in(clk), .reset(reset), .clk_out(clk_cnt_dn));
//freq_div	#(15)u2(.clk_in(clk),.reset(reset),.clk_out(clk_sel));
freq_div	#(2)u1(.clk_in(clk), .reset(reset), .clk_out(clk_cnt_dn));
freq_div	#(1)u2(.clk_in(clk),.reset(reset),.clk_out(clk_sel));
control_1 		u3(.clk(clk_cnt_dn), .reset(reset), .enable(enable), .nightcomes(nightcomes),
					.timer1(timer1), .timer0(timer0), .NS_lights(NS_lights), .EW_lights(EW_lights));
seg7_select	#(4) u4(.clk(clk_sel),.reset(reset),.seg7_sel(seg7_sel));
bcd_to_seg7_1 	u5(.bcd_in(segg),.seg7(seg7));
endmodule
//-----------------------------------------------------
module 	control_1(clk, reset, enable, nightcomes, timer1, timer0, NS_lights, EW_lights);
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
parameter 	GREEN_COUNT = 5'h18,//5'd20-2,
			YELLOW_COUNT= 5'h01,//5'd03-2,
			RED_COUNT  	= 5'h21,//5'd23-2,
			NIGHT_COUNT	= 5'h02;//5'd04-2;

reg		[2:0]NS_lights, EW_lights, next_NS_lights, next_EW_lights;
reg		[1:0]traffic_state, next_state;
reg		timer_clr, EW_side, next_timer_clr, next_EW_side;

//reg		[4:0]timer;
output	[3:0]timer0;
output	timer1;
wire	[3:0]timer0;
wire	timer1;

reg		[3:0]timer0reg;
reg		timer1reg;

assign 	timer0 = timer0reg;
assign	timer1 = timer1reg;


always @(posedge clk or posedge reset or enable)
begin
  if (reset) begin
	traffic_state <= #1 GREEN_LIGHT;
    timer_clr     <= #1 1'b1;
    EW_side       <= #1 1'b1;
    EW_lights     <= #1 3'b100;
    NS_lights     <= #1 3'b001;
	end
  else
	if (enable==1'b1) begin
	  traffic_state <= #1 next_state;
	  timer_clr     <= #1 next_timer_clr;
	  EW_side       <= #1 next_EW_side;
	  EW_lights     <= #1 next_EW_lights;
	  NS_lights     <= #1 next_NS_lights;
	end
end

always @(traffic_state or timer_clr or EW_side or
			EW_lights or NS_lights or timer1reg or timer0reg or nightcomes)
begin
    next_state     = traffic_state;
    next_timer_clr = timer_clr;
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
				if ({timer1reg,timer0reg}==GREEN_COUNT) begin
					next_timer_clr = 1'b1;
					next_state     = YELLOW_LIGHT;
				end
				if (nightcomes==1'b1) begin
					next_timer_clr = 1'b1;
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
				if ({timer1reg,timer0reg}==YELLOW_COUNT) begin
					next_timer_clr = 1'b1;
					next_state     = RED_LIGHT;
				end
				if (nightcomes==1'b1) begin
					next_timer_clr = 1'b1;
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
				if({timer1reg,timer0reg}==RED_COUNT) begin
					next_timer_clr = 1'b1;
					next_state     = GREEN_LIGHT;
					next_EW_side   = ~EW_side;
				end
				if (nightcomes==1'b1) begin
					next_timer_clr = 1'b1;
					next_state     = NIGHT;
				end
					
		    end
	  NIGHT:  begin
				next_timer_clr = 1'b0;
				next_EW_lights = 3'b010; //{g,y,r}
				next_NS_lights = 3'b010; //{g,y,r}
				if({timer1reg,timer0reg}==NIGHT_COUNT) begin
					next_timer_clr	= 1'b1;
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
		  end
    endcase
end

always @(posedge clk or posedge reset)
begin
/*
  if (reset)
    timer <= #1 4'd0;
  else
    if (enable==1'b1)
      if (timer_clr==1'b1)
		timer <= #1 4'd0;
      else
		timer <= #1 timer + 4'd01;
*/		
  if(reset) 
		begin
		timer1reg<=1'd0;
		timer0reg<=4'd0;
		end
	else 	
		if(enable == 1'b1)
			if (timer_clr==1'b1)begin
				timer1reg<=1'd0;
				timer0reg<=4'd0;
				end
			else
				if({timer1reg,timer0reg}<5'd31)
					if(timer0reg<9)
						timer0reg<=timer0reg+4'd1;
					else begin
						timer0reg=4'd0;
						timer1reg=timer1reg+1'd1;
						end
				else begin
					timer0reg<=4'd0;
					timer1reg<=1'd0;
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