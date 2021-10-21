module	lab3_1(clk,reset,enable,seg7_sel,seg7_out,dpt,carry,led_com);

input	clk,reset,enable;
output	[2:0]seg7_sel;
output	[6:0]seg7_out;
output 	dpt,carry,led_com;
wire	clk_count,clk_sel;
wire	[3:0]count_out,count5,count4,count3,count2,count1,count0;

assign	led_com	= 1'b1;
assign	count_out=	(seg7_sel == 3'b101 )? count0 : (seg7_sel == 3'b100 )? count1 :
					(seg7_sel == 3'b011 )? count2 : 
					(seg7_sel == 3'b010 )? count3 : 
					(seg7_sel == 3'b001 )? count4 : count5;
assign	dpt		=	(seg7_sel == 3'b101 )? 1'b1 : (seg7_sel == 3'b100 )? 1'b0 :
					(seg7_sel == 3'b011 )? 1'b1 : 
					(seg7_sel == 3'b010 )? 1'b0 : 
					(seg7_sel == 3'b001 )? 1'b1 :1'b0;
//freq_div#(13)m1(clk, reset, clk_count);

//freq_div#(15)m2(clk, reset, clk_sel);

onehz_freq m2(clk_in,reset,clk_count);

clock m3(clk_count, reset, enable, count5, count4, count3, count2, count1, count0, carry);

bcd_to_seg7_1 m4(count_out,seg7_out);

seg7_select#(6) m5(clk_sel,reset,seg7_sel);

endmodule 
//---------------------------------
module	clock(clk,reset,enable,count5,count4,count3,count2,count1,count0,carry);

input	clk,reset,enable;
output	[3:0]count5,count4,count3,count2,count1,count0;
output 	carry;
wire	[3:0]count5,count4,count3,count2,count1,count0;
wire 	carry,carry2,carry1,carry0,carry4;

assign 	carry = carry2 & carry1 & carry0;
assign	carry4=	carry0 & carry1;

count_00_23_bcd m6(.clk(clk), .reset(reset),  .enable(carry4), 
					.count1(count5), .count0(count4), .carry(carry2));
					
count_00_59_bcd m7(.clk(clk), .reset(reset),  .enable(carry0), 
					.count1(count3), .count0(count2), .carry(carry1));
					
count_00_59_bcd m8(.clk(clk), .reset(reset),  .enable(enable), 
					.count1(count1), .count0(count0), .carry(carry0));

endmodule
//---------------------------------
module	count_00_23_bcd(clk,reset,enable,count1,count0,carry);

input	clk,reset,enable;
output	[3:0]count1,count0;
wire	[3:0]count1,count0;
reg		[3:0]count1reg,count0reg;
reg		carryreg;
output 	carry;

assign 	count1=count1reg;
assign	count0=count0reg;
assign	carry=carryreg;

always@ (posedge clk or posedge reset)
begin
if(reset) 
	begin
	carryreg<=1'd0;
	count1reg<=4'd0;
	count0reg<=4'd0;
	end
else 	
	if(enable == 1'b1)begin
			if((count1reg==4'd2)&&(count0reg==4'd3))begin
				count1reg<=4'd0;
				count0reg<=4'd0;
				carryreg<=1'b1;
				end
			else
				if((count1reg==4'd2)&&(count0reg!=4'd3))
					count0reg<=count0reg+4'd1;
					
				else 
					if(count0reg==4'd9)begin
						count0reg<=4'd0;
						count1reg<=count1reg+4'd1;
						end
					else begin
						count0reg<=count0reg+4'd1;
						carryreg<=1'd0;
						end
			end
end
endmodule
//-------------------------------------------
module 	count_00_59_bcd(clk,reset,enable,count1,count0,carry);

input 	clk,reset,enable;
output	[3:0]count1,count0;
wire	[3:0]count1,count0;
reg		[3:0]count1reg,count0reg;
reg		carryreg;
output 	carry;

assign 	count1=count1reg;
assign	count0=count0reg;
assign	carry=carryreg;

always@ (posedge clk or posedge reset)
begin
	if(reset) 
		begin
		carryreg<=1'd0;
		count1reg<=4'd0;
		count0reg<=4'd0;
		end
	else 	
		if(enable == 1'b1)
				if({count1reg,count0reg}<8'h59)
					if(count0reg<9)begin
						count0reg<=count0reg+4'd1;
						carryreg<=1'd0;
						end
					else begin
						count0reg=4'd0;
						count1reg=count1reg+4'd1;
						//carryreg=1'd1;
						end
				else begin
					carryreg<=1'd1;
					count0reg<=4'd0;
					count1reg<=4'd0;
					end
					
		
end
endmodule
//---------------------------------
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

//---------------------------------
module 		onehz_freq(clk_in,reset,clk_count);
  
input		clk_in, reset;
//output		clk_out;
output		[23:0]clk_count;
reg			[23:0]countreg;

assign	clk_count=countreg;

always@ (posedge clk_in or posedge reset)
begin
	if(reset)
		countreg<=24'd0;
	else if(countreg==10^7-1)
			countreg<=24'd0;
		else
			countreg<=countreg+24'd1;
end
//10Mhz/100000
endmodule
//-------------------------------------
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