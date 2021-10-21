transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/flex10ke_ver
vmap flex10ke_ver ./verilog_libs/flex10ke_ver
vlog -vlog01compat -work flex10ke_ver {c:/altera/90sp2/quartus/eda/sim_lib/flex10ke_atoms.v}

if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab3_1.vo}

