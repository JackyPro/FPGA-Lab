# compile

vlog lab3_1.v

vlog lab3_1_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic              /testbench/lab3_1_instance/reset
add wave -noupdate -format -logic              /testbench/lab3_1_instance/clk
add wave -noupdate -format -logic              /testbench/lab3_1_instance/clk_count

add wave -noupdate -format -logic              /testbench/lab3_1_instance/clk_sel
add wave -noupdate -format -logic              /testbench/lab3_1_instance/carry
add wave -noupdate -format -logic              /testbench/lab3_1_instance/enable
add wave -noupdate -format -literal -radix bin /testbench/lab3_1_instance/seg7_sel
add wave -noupdate -format -literal -radix bin /testbench/lab3_1_instance/seg7_out
add wave -noupdate -format -literal -radix bin /testbench/lab3_1_instance/dpt
add wave -noupdate -format -literal -radix bin /testbench/lab3_1_instance/count_out
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1_instance/count0
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1_instance/count1
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1_instance/count2
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1_instance/count3
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1_instance/count4
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1_instance/count5

# 2060 ns
run 692100000
