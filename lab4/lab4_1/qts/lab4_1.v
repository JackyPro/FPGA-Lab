module	lab4_1(clk, reset, row, sel, column_green, column_red);
input 	clk,reset;
input	[1:0]sel;
output	[7:0]row, column_green, column_red;
wire 	clk_shift, clk_scan;
wire	[7:0]idx, idx_cnt;
wire	[7:0]column_out;

assign 	column_green= (sel== 2'b01 || sel== 2'b11)? column_out: 8'b0;
assign 	column_red	= (sel== 2'b10 || sel== 2'b11)? column_out: 8'b0;

//freq_div#(22) M1 (clk,reset,clk_idx);
freq_div#(2) M1 (clk,reset,clk_idx);
//freq_div#(12) M2 (clk,reset,clk_row);
freq_div#(1) M2 (clk,reset,clk_row);
idx_gen M3 (clk_idx,reset,idx); 
row_gen M4 (clk_row,reset, idx, row, idx_cnt);
rom_char M5 (idx_cnt, column_out);
endmodule
//---------------------------------------------------------------------
module 	rom_char(addr, data);
input	[6:0]addr;
output	[7:0]data;
reg		[7:0]data;

always@(addr) 
begin
	case(addr)
	7'd0: 	data=8'b00000000;		
	7'd1: 	data=8'b00000000;	
	7'd2: 	data=8'b00000000; 	
	7'd3: 	data=8'b00000000;
	7'd4: 	data=8'b00000000;		
	7'd5: 	data=8'b00000000;	
	7'd6: 	data=8'b00000000;		
	7'd7: 	data=8'b00000000;
	//-----------------------
	7'd8: 	data=8'b00111100;		
	7'd9: 	data=8'b01000010;	
	7'd10: 	data=8'b01000110; 	
	7'd11: 	data=8'b01001010;
	7'd12: 	data=8'b01010010;	
	7'd13: 	data=8'b01100010;
	7'd14: 	data=8'b00111100;	
	7'd15: 	data=8'b00000000;
	//-----------------------

	7'd16: 	data=8'b00001000;	
	7'd17: 	data=8'b00011000;
	7'd18: 	data=8'b00001000;	
	7'd19: 	data=8'b00001000;
	7'd20: 	data=8'b00001000;	
	7'd21: 	data=8'b00001000;
	7'd22: 	data=8'b00011100;	
	7'd23: 	data=8'b00000000;
	//
	7'd24: 	data=8'b00111100;	
	7'd25: 	data=8'b01000010;
	7'd26: 	data=8'b01000010;	
	7'd27: 	data=8'b00000100;
	7'd28: 	data=8'b00001000;	
	7'd29: 	data=8'b00010000;
	7'd30: 	data=8'b01111110;	
	7'd31: 	data=8'b00000000;
	//
	7'd32: 	data=8'b00111100; 	
	7'd33: 	data=8'b01000010;
	7'd34: 	data=8'b00000010;	
	7'd35: 	data=8'b00111100;
	7'd36: 	data=8'b00000010;	
	7'd37: 	data=8'b01000010;
	7'd38: 	data=8'b00111100;	
	7'd39: 	data=8'b00000000;
	//
	7'd40: 	data=8'b00011100; 	
	7'd41: 	data=8'b00100100;
	7'd42: 	data=8'b01000100;	
	7'd43: 	data=8'b01000100;
	7'd44: 	data=8'b01000100;	
	7'd45: 	data=8'b01111110;
	7'd46: 	data=8'b00000100;	
	7'd47: 	data=8'b00000000;
	//
	7'd48: 	data=8'b01111110;	
	7'd49: 	data=8'b01000000;
	7'd50: 	data=8'b01000000;	
	7'd51: 	data=8'b01111100;
	7'd52: 	data=8'b00000010;	
	7'd53: 	data=8'b01000010;
	7'd54: 	data=8'b00111100;	
	7'd55: 	data=8'b00000000;
	//
	7'd56:	data=8'b00111100;
	7'd57:	data=8'b01000000;
	7'd58:	data=8'b01000000;
	7'd59:	data=8'b01111100;
	7'd60:	data=8'b01000010;
	7'd61:	data=8'b01000010;
	7'd62:	data=8'b00111100;
	7'd63:	data=8'b00000000;
	//-----------------------
	7'd64:	data=8'b01111110;
	7'd65:	data=8'b01000010;
	7'd66:	data=8'b01000010;
	7'd67:	data=8'b00000100;
	7'd68:	data=8'b00001000;
	7'd69:	data=8'b00001000;
	7'd70:	data=8'b00001000;
	7'd71:	data=8'b00000000;
	//-----------------------
	7'd72:	data=8'b00111100;
	7'd73:	data=8'b01000010;
	7'd74:	data=8'b01000010;
	7'd75:	data=8'b00111100;
	7'd76:	data=8'b01000010;
	7'd77:	data=8'b01000010;
	7'd78:	data=8'b00111100;
	7'd79:	data=8'b00000000;
	//-----------------------
	7'd80:	data=8'b00111100;
	7'd81:	data=8'b01000010;
	7'd82:	data=8'b01000010;
	7'd83:	data=8'b00111100;
	7'd84:	data=8'b00000010;
	7'd85:	data=8'b00000010;
	7'd86:	data=8'b00000010;
	7'd87:	data=8'b00000000;
	endcase
end
endmodule
//---------------------------------------------------
module 	idx_gen(clk, reset, idx);
input 	clk,reset;
output	[6:0]idx;
reg		[6:0]idx;

always@(posedge clk or posedge reset) 
begin
	if(reset)
		idx= 7'd0;
	else if(idx==7'd80)
			idx= 7'd0;
		else
			idx=idx+7'd08;
end
endmodule
//---------------------------------------------------
module 	row_gen(clk, reset, idx, row, idx_cnt);
input 	clk, reset;
input	[6:0]idx;
output	[7:0]row;
output	[6:0]idx_cnt;
reg		[7:0]row;
reg		[6:0]idx_cnt;
reg		[2:0]cnt;

always@(posedge clk or posedge reset) 
begin
	if(reset) begin
		row		=8'b1000_0000;
		cnt		=3'd0;
		idx_cnt	=7'd0;
		end
	else begin
		row		={row[0],row[7:1]} ;    	//(??????????????????LED??????)
		cnt		=cnt+3'd1;        	//(???0??????7) 
		idx_cnt	=idx+cnt;  	//(??????????????????0???7)
		end
end
endmodule
//---------------------------------------------------
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
//--------------------------------------------------


