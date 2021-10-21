# compile

vlog count_00_23_bcd.v

vlog count_00_23_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic              /testbench/count_00_23_bcd_instance/reset
add wave -noupdate -format -logic              /testbench/count_00_23_bcd_instance/clk

add wave -noupdate -format -logic              /testbench/count_00_23_bcd_instance/enable
add wave -noupdate -format -literal -radix unsigned /testbench/count_00_23_bcd_instance/count0
add wave -noupdate -format -literal -radix unsigned /testbench/count_00_23_bcd_instance/count1
add wave -noupdate -format -logic              /testbench/count_00_23_bcd_instance/carry

# 2060 ns
run 2260
