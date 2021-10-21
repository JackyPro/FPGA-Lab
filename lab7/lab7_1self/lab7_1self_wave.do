# compile
vlog lab7_1self.v
vlog lab7_1self_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic /testbench/lab7_1self_instance/reset
add wave -noupdate -format -logic /testbench/lab7_1self_instance/clk
add wave -noupdate -format -logic /testbench/lab7_1self_instance/clk_cnt_dn
add wave -noupdate -format -logic /testbench/lab7_1self_instance/clk_sel
add wave -noupdate -format -logic /testbench/lab7_1self_instance/enable
add wave -noupdate -format -logic /testbench/lab7_1self_instance/nightcomes
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self_instance/light_led
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self_instance/seg7
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self_instance/seg7_sel
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self_instance/NS_lights
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self_instance/EW_lights
add wave -noupdate -format -literal -radix unsigned /testbench/lab7_1self_instance/timer0
add wave -noupdate -format -literal -radix unsigned /testbench/lab7_1self_instance/timer1
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self_instance/segg

# 1.5 ms
run 9382
