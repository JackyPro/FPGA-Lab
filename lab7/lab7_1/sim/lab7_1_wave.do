# compile
vlog lab7_1.v
vlog lab7_1_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic /testbench/lab7_1_instance/reset
add wave -noupdate -format -logic /testbench/lab7_1_instance/clk
add wave -noupdate -format -logic /testbench/lab7_1_instance/clk_cnt
add wave -noupdate -format -logic /testbench/lab7_1_instance/clk_sel
add wave -noupdate -format -logic /testbench/lab7_1_instance/day_night
add wave -noupdate -format -literal -radix bin /testbench/lab7_1_instance/light_led
add wave -noupdate -format -literal -radix bin /testbench/lab7_1_instance/seg7
add wave -noupdate -format -literal -radix bin /testbench/lab7_1_instance/seg7_sel
add wave -noupdate -format -literal -radix unsigned /testbench/lab7_1_instance/count_out
add wave -noupdate -format -literal -radix unsigned /testbench/lab7_1_instance/light_mode
add wave -noupdate -format -literal -radix bin /testbench/lab7_1_instance/g1_cnt

# 1.5 ms
run 9382
