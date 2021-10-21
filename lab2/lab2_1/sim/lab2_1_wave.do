# compile

vlog bcd_to_seg7.v
vlog lab2_1_tb.v

# simulate
vsim -debugdb testbench

#probe signals

add wave -noupdate -format -literal -radix bin /testbench/bcd_to_seg7_instance/seg7_sel
add wave -noupdate -format -literal -radix bin /testbench/bcd_to_seg7_instance/seg7_out
add wave -noupdate -format -literal -radix bin /testbench/bcd_to_seg7_instance/dpt_out
add wave -noupdate -format -literal -radix bin /testbench/bcd_to_seg7_instance/bcd_in

# 2060 ns
run 200
