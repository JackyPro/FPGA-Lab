# compile
vlog control.v
vlog control_tb.v

# simulate
vsim -debugdb testbench

#probe signals

add wave -noupdate -format -logic /testbench/control_instance/reset
add wave -noupdate -format -logic /testbench/control_instance/clk
add wave -noupdate -format -logic /testbench/control_instance/enable
add wave -noupdate -format -logic /testbench/control_instance/nightcomes
add wave -noupdate -format -logic /testbench/control_instance/cnt_d0
add wave -noupdate -format -logic /testbench/control_instance/NS_lights
add wave -noupdate -format -logic /testbench/control_instance/EW_lights
add wave -noupdate -format -logic /testbench/control_instance/traffic_state
add wave -noupdate -format -logic /testbench/control_instance/next_state
add wave -noupdate -format -logic /testbench/control_instance/timer
add wave -noupdate -format -logic /testbench/control_instance/timer_clr

add wave -noupdate -format -logic /testbench/control_instance/next_timer_clr
add wave -noupdate -format -logic /testbench/control_instance/EW_side
add wave -noupdate -format -logic /testbench/control_instance/next_EW_side


# 1.5 ms
run 1000
