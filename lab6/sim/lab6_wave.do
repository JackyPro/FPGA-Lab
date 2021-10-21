# compile
vlog lab6.v
vlog lab6_tb.v

# simulate
vsim -debugdb testbench

#probe signals
add wave -noupdate -format -logic /testbench/lab6_instance/reset
add wave -noupdate -format -logic /testbench/lab6_instance/clk
add wave -noupdate -format -logic /testbench/lab6_instance/clk_sel
add wave -noupdate -color Yellow -format -literal -radix bin /testbench/lab6_instance/column
add wave -noupdate -color Blue   -format -literal -radix bin /testbench/lab6_instance/seg7
add wave -noupdate -color Green  -format -literal -radix bin /testbench/lab6_instance/sel

run 60052
