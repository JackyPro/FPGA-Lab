# compile

vlog clock.v
vlog clock_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic              /testbench/clock_instance/reset
add wave -noupdate -format -logic              /testbench/clock_instance/clk

add wave -noupdate -format -logic              /testbench/clock_instance/enable
add wave -noupdate -format -literal -radix unsigned /testbench/clock_instance/count0
add wave -noupdate -format -literal -radix unsigned /testbench/clock_instance/count1
add wave -noupdate -format -literal -radix unsigned /testbench/clock_instance/count2
add wave -noupdate -format -literal -radix unsigned /testbench/clock_instance/count3
add wave -noupdate -format -literal -radix unsigned /testbench/clock_instance/count4
add wave -noupdate -format -literal -radix unsigned /testbench/clock_instance/count5
add wave -noupdate -format -logic              /testbench/clock_instance/carry0

add wave -noupdate -format -logic              /testbench/clock_instance/carry1
add wave -noupdate -format -logic              /testbench/clock_instance/carry2
add wave -noupdate -format -logic              /testbench/clock_instance/carry4
add wave -noupdate -format -logic              /testbench/clock_instance/carry

# 2060 ns
run 692100
