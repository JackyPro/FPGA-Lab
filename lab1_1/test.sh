source_module="freq_div"
testbentch_module="freq_div_tb"
gtkwave_module="wave"

echo $source_module
echo $testbentch_module
echo $gtkwave_module

iverilog -o $source_module".vvp" $source_module".v" $testbentch_module".v"
vvp -n $source_module".vvp" 
gtkwave  $gtkwave_module".vcd"