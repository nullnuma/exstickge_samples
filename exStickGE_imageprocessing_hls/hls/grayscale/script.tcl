open_project grayscale
set_top grayscale
add_files grayscale/grayscale.h
add_files grayscale/grayscale.cpp
add_files -tb grayscale/grayscale_tb.cpp
open_solution "solution1"
set_part {xc7a200tsbg484-2} -tool vivado
create_clock -period 200MHz -name default
#source "./grayscale/solution1/directives.tcl"
csim_design -clean -compiler gcc
csynth_design
cosim_design -trace_level all
export_design -rtl verilog -format ip_catalog -version "1.0"

