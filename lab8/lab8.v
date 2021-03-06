module 	lab8(clk, row, red, green, column, sel, reset);

input 		reset, clk;     		//124,55
input 		[2:0]column;		//42,43,44
output	    [7:0]red, row, green;		//98-102,109-111;
					//88-92,95-97;
					//112-114,116-120;
output 		[2:0]sel;			//37,36,33
wire 		press, press_valid, coll,clk_out,clk_outt;
wire 		[3:0]key_code, scan_code, addr;
wire		[2:0]idx;
wire		[7:0]hor, ver;


assign 	addr = { coll, idx };
freq_div#(14) 	M6 (clk, reset, clk_out);
//freq_div#(16) 	M11 (clk, reset, clk_outt);
key_decode 	M1 (sel, column, press, scan_code);//-----------
key_buff 	M2 (clk_out, reset, press_valid, scan_code, key_code);
vaild		M3 (clk_out,reset,press,press_valid);
count6  	M4 (clk_out, reset, sel);
//
move		M5 (reset, coll, key_code, ver, hor,clk_out);
 	
map		M7 (addr,green);
idx		M8 (clk_out, reset, idx, row);
mix		M9 (ver, hor, row, red);
collision 	M10 (clk_out, reset, red, green, coll);

endmodule
//---------------------------------------OK---------------------------
module count6(clk, reset, count_out);
input clk, reset;
output[2:0] count_out;
reg[2:0] count_out;
always@ (posedge clk or posedge reset)
	begin
	if(reset)
			count_out= 3'b000;
	else
		begin
		if(count_out==3'b101)
				count_out= 3'b000;
		
		else count_out=count_out+3'b001;

		end	
	end
endmodule
//-----------------------------------------ok--------------------------
module key_decode(sel, column, press, scan_code);
input[2:0]sel;
input[2:0] column;
output press;
output[3:0] scan_code;
reg[3:0] scan_code;
reg press;
always@(sel or column) begin
	case(sel)
		3'b000:
			case(column)
			//3'b011: begin scan_code= 4'b0001; press = 1'b0; end // 1
			3'b101: begin scan_code= 4'b0010; press = 1'b1; end // 2
			//3'b110: begin scan_code= 4'b0011; press = 1'b0; end // 3
			default: begin scan_code= 4'b0; press = 1'b0; end
			endcase
			//
		3'b001:
			case(column)
			3'b011: 	
				begin
				scan_code= 4'b0100; press = 1'b1; 
				end // 4
			//3'b101: begin scan_code= 4'b0101; press = 1'b0; end // 5
			3'b110: 
			begin scan_code= 4'b0110; press = 1'b1; end // 6
			default: begin scan_code= 4'b0; press = 1'b0; end
			endcase
			//
		3'b010:
			case(column)
			//3'b011: begin scan_code= 4'b0111; press = 1'b0; end // 7
			3'b101: begin scan_code= 4'b1000; press = 1'b1; end // 8
			//3'b110: begin scan_code= 4'b1001; press = 1'b0; end // 9
			default: begin scan_code= 4'b0; press = 1'b0; end
			endcase
		//
		//3'b011:
		//case(column)
		//3'b101: begin scan_code= 4'b0000; press = 1'b0; end // 0
	    //default: begin scan_code= 4'b1111; press = 1'b0; end
		//endcase
		//
	default:
		begin scan_code= 4'b0; press = 1'b0; end
endcase
end
endmodule
//-----------------------------------------OK------------------------------
module 	vaild (clk,rst,press,press_valid);
input press,clk,rst;
output press_valid;
reg[6:0] gg;
assign press_valid=(press&~(gg[5]));
always@(posedge clk or posedge rst)
begin
if(rst)
	gg<=7'b0;
else
	gg<={gg[5:0],press};
end
endmodule

//------------ ----------------------------ok----------
module key_buff(clk, rst, press, scan_code, key_code);
input clk, rst, press;
input[3:0] scan_code;
output[3:0]key_code;
reg[3:0]key_code;
always@(posedge clk or posedge rst) begin
if(rst)
key_code= 4'b0;// initial value
else
key_code= press ? scan_code:4'b0;  //
end 
endmodule
//---------------------------------------------------ok--------------
module freq_div(clk_in, reset, clk_out);
parameter exp = 20;   
input clk_in, reset;
output clk_out;
reg[exp-1:0] divider;
integer i;
assign clk_out= divider[exp-1];
always@ (posedge clk_in or posedge reset)
begin
if(reset)
for(i=0; i < exp; i=i+1)
divider[i] = 1'b0;
else
divider = divider+ 1'b1;
end
endmodule
//------------------------------------------ok---------------------
module	move(reset, unable, keycode, ver, hor, clk);
input 		reset, clk, unable;
input 		[3:0]keycode;
output 	[7:0]ver, hor;
wire		left, right, up, down;

assign 	left   =~keycode[1]& keycode[2];
assign 	right =  keycode[1]& keycode[2];
assign 	up    =  keycode[1]&~keycode[2];
assign	down=  keycode[3];

shift S1(left, right, reset, unable, hor, clk); //left & right
shift S2(up, down, reset, unable, ver, clk); //up & down

endmodule
//----------------------------------------------??------------------
module 	shift(left, right, reset, unable, out, clk);
input 		left, right, reset, clk, unable;
output reg	[7:0]out;

always@(posedge clk or posedge reset)
begin
	if(reset)
		out<=8'b0000_1000;
	else if(unable) 		//????????????
 		out<=8'b0000_0000;
 	else if(left)
		out={out[6:0],out[7]};
	else if(right)
		out ={out[0],out[7:1]};
 	else
  		out<=out;
end
endmodule



//--------------------------------------------------ok------------
module  	collision(clk, reset, red, green, coll);
input		clk, reset;
input		[7:0]red, green;
output reg 	coll;
always@(posedge clk or posedge reset)
begin
	if(reset)
		coll<=1'b0;
	else if((red & green) != 8'b0)    //????????????
		coll<=1'b1;
	else
		coll<=coll;
end
endmodule
//---------------------------------------------ok---------------------
module 	idx(clk, reset, idx, row);
input		 reset, clk;
output reg	[2:0]idx;
output reg	[7:0]row;
always@(posedge clk or posedge reset)
begin
	if(reset) begin
		idx<=3'b000;
		row<=8'b1000_0000;
	end
	else begin
		idx<=idx+3'b001;
		row<={row[0],row[7:1]};
	end
end
endmodule
//-----------------------------------------ok----------------
module 	mix(ver, hor, row, red);
input		[7:0]ver, hor, row;
output 	[7:0]red;

assign 	red=(row==ver)?hor:8'b0;

endmodule
//-----------------------------------------------------------
module		map(addr,data);
input		[3:0]addr;
output reg 	[7:0]data;
always@(addr)
begin
case(addr)
	4'd0  	:data=  8'b0001_1000;          //?????????????????????
	4'd1  	:data=	8'b0010_0100;
	4'd2  	:data=	8'b0110_0110;
	4'd3  	:data=	8'b1110_0111;
	4'd4  	:data=	8'b0110_0110;
	4'd5  	:data=	8'b0110_0110;
	4'd6  	:data=	8'b0110_0110;
	4'd7  	:data=	8'b0110_0110;
	
	4'd8  	:data=8'b1111_1111;
	4'd9  	:data=8'b1111_1111;
	4'd10	:data=8'b1111_1111;
	4'd11	:data=8'b1111_1111;
	4'd12	:data=8'b1111_1111;
	4'd13	:data=8'b1111_1111;
	4'd14	:data=8'b1111_1111;
	4'd15	:data=8'b1111_1111;
	default	:data=8'b0000_0000;
endcase
end
endmodule
//----------------------------------------------------------------
