module	lab6(clk, reset, column, sel, seg7);

input	clk, reset;		//pin55,124
input	[2:0]column;		// pin 42, 43, 44
output	[2:0]sel;		// pin 37, 36, 33
output	[6:0]seg7;		// pin 23, 26, 27,28,29,30,31
wire 	clk_sel;
wire	[3:0] key_code;

//freq_div#(13) 	M1(clk,reset,clk_sel);
freq_div#(3) 	M1(clk,reset,clk_sel);
key_seg7_6dig 	M2(clk_sel, reset, column, sel, key_code);
bcd_to_seg7		M3(key_code,seg7);

endmodule
//---------------------------------------------------------------------
module	key_seg7_6dig(clk_sel, reset, column, sel, key_code);

input	clk_sel, reset;
input	[2:0]column;
output	[2:0]sel;
output	[3:0]key_code;
wire 	press_valid,press;
wire	[3:0] scan_code, key_code;
wire	[23:0]display_code;

count6			N1(clk_sel,sel);
key_decode		N2(sel, column, press, scan_code);
debounce_ctl	N3(clk_sel,reset,press,press_valid);
key_buf6		N4(clk_sel, reset, press_valid, scan_code, display_code);
key_code_mux	N5(display_code, sel, key_code);
endmodule

//---------------------------------------------------------------------
module 	key_code_mux(display_code, sel, key_code);

input	[23:0]display_code;
input	[2:0]sel;
output	[3:0]key_code;

assign 	key_code= (sel== 3'b101) ? display_code[3:0] :
				(sel== 3'b100) ? display_code[7:4] :
				(sel== 3'b011) ? display_code[11:8] :
				(sel== 3'b010) ? display_code[15:12] :
				(sel== 3'b001) ? display_code[19:16] :
				(sel== 3'b000) ? display_code[23:20] : 	4'b1111;
endmodule
//--------------------------------------------------------------------
module 	debounce_ctl (clk,reset,press,press_valid);

input 	press,clk,reset;
output 	press_valid;
reg		[5:0] gg;

assign 	press_valid=~(gg[5]||(~press));

always@(posedge clk or posedge reset)
begin
	if(reset)
		gg<=6'b0;
	else
		gg<={gg[4:0],press};
	end
endmodule

//---------------------------------------------------------------------
module	key_decode(sel, column, press, scan_code);
input	[2:0]sel;
input	[2:0] column;
output 	press;
output	[3:0]scan_code;
reg		[3:0]scan_code;
reg 	press;

always@(sel or column) 
begin
case(sel)
	3'b000:
		case(column)
		3'b011: begin scan_code= 4'b0001; press = 1'b1; end // 1
		3'b101: begin scan_code= 4'b0010; press = 1'b1; end // 2
		3'b110: begin scan_code= 4'b0011; press = 1'b1; end // 3
		default: begin scan_code= 4'b1111; press = 1'b0; end
		endcase
	3'b001:
		case(column)
		3'b011: begin scan_code= 4'b0100; press = 1'b1; end // 4
		3'b101: begin scan_code= 4'b0101; press = 1'b1; end // 5
		3'b110: begin scan_code= 4'b0110; press = 1'b1; end // 6
		default: begin scan_code= 4'b1111; press = 1'b0; end
		endcase
	3'b010:
		case(column)
		3'b011: begin scan_code= 4'b0111; press = 1'b1; end // 7
		3'b101: begin scan_code= 4'b1000; press = 1'b1; end // 8
		3'b110: begin scan_code= 4'b1001; press = 1'b1; end // 9
		default: begin scan_code= 4'b1111; press = 1'b0; end
		endcase
	3'b011:
		case(column)
		3'b101: begin scan_code= 4'b0000; press = 1'b1; end // 0
		default: begin scan_code= 4'b1111; press = 1'b0; end
		endcase
	default:
		begin scan_code= 4'b1111; press = 1'b0; end
endcase
end
endmodule
//---------------------------------------------------
module 	key_led(clk_sel, reset, column, sel, key_code);

input 	clk_sel, reset;
input	[2:0]column;
output	[2:0]sel;
output	[3:0] key_code;
wire 	press;
wire	[3:0] scan_code, key_code;
wire	[23:0]display_code;

count6 g1(clk_sel,sel);
key_decode g2(sel,column,press,scan_code);
key_buf6 g3(clk_sel, reset, press_valid, scan_code, display_code);
endmodule
//---------------------------------------------------
module key_buf6(clk, reset, press_valid, scan_code, display_code);

input clk, reset, press_valid;
input[3:0] scan_code;
output[23:0]display_code;

reg[23:0]display_code;

always@(posedge clk or posedge reset) 
begin
	if(reset)
	display_code= 24'hffffff;// initial value
	else
	display_code= press_valid?{display_code[19:0],scan_code} :display_code;
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
module	count6(clk, out);
input	clk;
output 	reg [2:0]out;

always@(posedge clk)
begin
	if(out==3'b101)
		out=3'b000;
	else
		out=out+3'b001;
end
endmodule
//--------------------------------------------------
module bcd_to_seg7(bcd_in,seg7);

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


