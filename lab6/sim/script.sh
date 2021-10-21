iverilog -o design lab6.v lab6_tb.v
vvp design
gtkwave wave.vcd