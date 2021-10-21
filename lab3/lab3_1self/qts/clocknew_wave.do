# compile

vlog clocknew.v
vlog clocknew_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic              /testbench/clocknew_instance/reset
add wave -noupdate -format -logic              /testbench/clocknew_instance/clk

add wave -noupdate -format -logic              /testbench/clocknew_instance/enable
add wave -noupdate -format -literal -radix unsigned /testbench/clocknew_instance/count0
add wave -noupdate -format -literal -radix unsigned /testbench/clocknew_instance/count1
add wave -noupdate -format -literal -radix unsigned /testbench/clocknew_instance/count2
add wave -noupdate -format -literal -radix unsigned /testbench/clocknew_instance/count3
add wave -noupdate -format -literal -radix unsigned /testbench/clocknew_instance/count4
add wave -noupdate -format -literal -radix unsigned /testbench/clocknew_instance/count5
add wave -noupdate -format -logic              /testbench/clocknew_instance/carry

# 2060 ns
run 712100
