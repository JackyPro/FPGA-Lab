# compile

vlog lab3_1self.v
vlog seg7_select.v
vlog freq_div.v
#vlog clock.v
vlog clocknew.v
vlog bcd_to_seg7_1.v
vlog count_00_59_bcd.v
vlog count_00_23_bcd.v

vlog lab3_1self_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic              /testbench/lab3_1self_instance/reset
add wave -noupdate -format -logic              /testbench/lab3_1self_instance/clk
add wave -noupdate -format -logic              /testbench/lab3_1self_instance/clk_count

add wave -noupdate -format -logic              /testbench/lab3_1self_instance/clk_sel
add wave -noupdate -format -logic              /testbench/lab3_1self_instance/carry
add wave -noupdate -format -logic              /testbench/lab3_1self_instance/enable
add wave -noupdate -format -literal -radix bin /testbench/lab3_1self_instance/seg7_sel
add wave -noupdate -format -literal -radix bin /testbench/lab3_1self_instance/seg7_out
add wave -noupdate -format -literal -radix bin /testbench/lab3_1self_instance/dpt
add wave -noupdate -format -literal -radix bin /testbench/lab3_1self_instance/count_out
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1self_instance/count0
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1self_instance/count1
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1self_instance/count2
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1self_instance/count3
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1self_instance/count4
add wave -noupdate -format -literal -radix unsigned /testbench/lab3_1self_instance/count5

# 2060 ns
run 13870100
