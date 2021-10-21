`timescale 1 ns/1 ns
module 	control(clk, reset, enable, nightcomes, cnt_d0, NS_lights, EW_lights);
input	clk, reset, enable, nightcomes;
output	[4:0]cnt_d0;
output	[2:0]NS_lights, EW_lights;
wire	[4:0]cnt_d0;

parameter 	GREEN_LIGHT = 2'b00,
			YELLOW_LIGHT= 2'b01,
			RED_LIGHT   = 2'b10,
			NIGHT		= 2'b11;

// timer starts to count from 0 and
// timer_clr also holds one cycle
parameter 	GREEN_COUNT = 5'd20-2,
			YELLOW_COUNT= 5'd03-2,
			RED_COUNT  	= 5'd23-2,
			NIGHT_COUNT	= 5'd04-2;

reg		[2:0]NS_lights, EW_lights, next_NS_lights, next_EW_lights;
reg		[1:0]traffic_state, next_state;
reg		timer_clr, EW_side, next_timer_clr, next_EW_side;

reg		[4:0]timer;

assign 	cnt_d0 = timer;


always @(posedge clk or negedge reset or enable)
begin
  if (!reset) begin
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
			EW_lights or NS_lights or timer or nightcomes)
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
				if (timer==GREEN_COUNT) begin
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
				if (timer==YELLOW_COUNT) begin
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
				if(timer==RED_COUNT) begin
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
				if(timer==NIGHT_COUNT) begin
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

always @(posedge clk or negedge reset)
begin
  if (!reset)
    timer <= #1 4'd0;
  else
    if (enable==1'b1)
      if (timer_clr==1'b1)
		timer <= #1 4'd0;
      else
		timer <= #1 timer + 4'd01;
end

endmodule
//-------------------------------------------------