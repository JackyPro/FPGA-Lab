# compile

vlog lab4_1.v

vlog lab4_1_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic              /testbench/lab4_1_instance/reset
add wave -noupdate -format -logic              /testbench/lab4_1_instance/clk

add wave -noupdate -format -logic              /testbench/lab4_1_instance/clk_idx
add wave -noupdate -format -logic              /testbench/lab4_1_instance/clk_row
add wave -noupdate -format -literal -radix bin /testbench/lab4_1_instance/column_green
add wave -noupdate -format -literal -radix bin /testbench/lab4_1_instance/column_red
add wave -noupdate -format -literal -radix bin /testbench/lab4_1_instance/row
add wave -noupdate -format -literal -radix bin /testbench/lab4_1_instance/sel
add wave -noupdate -format -literal -radix bin /testbench/lab4_1_instance/idx
add wave -noupdate -format -literal -radix bin /testbench/lab4_1_instance/idx_cnt



# 2060 ns
run 13870100
