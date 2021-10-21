# compile

vlog freq_div.v

vlog freq_div_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic  /testbench/freq_div_instance/reset
add wave -noupdate -format -logic  /testbench/freq_div_instance/clk_in
add wave -noupdate -format -logic  /testbench/freq_div_instance/clk_out
add wave -noupdate -format -literal -radix bin  /testbench/freq_div_instance/divider

# 2000 ns
run 2000
