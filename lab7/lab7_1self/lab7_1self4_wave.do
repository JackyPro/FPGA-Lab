# compile
vlog lab7_1self4.v
vlog lab7_1self4_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic /testbench/lab7_1self4_instance/reset
add wave -noupdate -format -logic /testbench/lab7_1self4_instance/clk
add wave -noupdate -format -logic /testbench/lab7_1self4_instance/clk_cnt_dn
add wave -noupdate -format -logic /testbench/lab7_1self4_instance/clk_sel
add wave -noupdate -format -logic /testbench/lab7_1self4_instance/enable
add wave -noupdate -format -logic /testbench/lab7_1self4_instance/nightcomes
add wave -noupdate -color Yellow -format -literal -radix bin /testbench/lab7_1self4_instance/light_led
add wave -noupdate -color Magenta -format -literal -radix bin /testbench/lab7_1self4_instance/seg7
add wave -noupdate -color Blue -format -literal -radix bin /testbench/lab7_1self4_instance/seg7_sel
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self4_instance/NS_lights
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self4_instance/EW_lights
add wave -noupdate -color Cyan -format -literal -radix unsigned /testbench/lab7_1self4_instance/timer0
add wave -noupdate -color Cyan -format -literal -radix unsigned /testbench/lab7_1self4_instance/timer1
add wave -noupdate -color Cyan -format -literal -radix unsigned /testbench/lab7_1self4_instance/timer2
add wave -noupdate -color Cyan -format -literal -radix unsigned /testbench/lab7_1self4_instance/timer3
add wave -noupdate -format -literal -radix bin /testbench/lab7_1self4_instance/segg

# 1.5 ms
run 9382
