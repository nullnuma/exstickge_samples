set project_target "xc7a200tsbg484-2"

# create project
create_project -force prj ./prj -part $project_target
add_files -fileset constrs_1 -norecurse ./sources/top_onboard_jtag_uart.xdc

# create board file
create_bd_design "top"
update_compile_order -fileset sources_1
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1
set_property -dict [list CONFIG.PRIM_IN_FREQ.VALUE_SRC USER] [get_bd_cells clk_wiz_0]
set_property -dict [list CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
                         CONFIG.PRIM_IN_FREQ {200} \
                         CONFIG.CLK_OUT1_PORT {CLK100M} \
                         CONFIG.RESET_TYPE {ACTIVE_LOW} \
                         CONFIG.CLKIN1_JITTER_PS {50.0} \
                         CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
                         CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
                         CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
                         CONFIG.RESET_PORT {resetn} \
                         CONFIG.CLKOUT1_JITTER {112.316} \
                         CONFIG.CLKOUT1_PHASE_ERROR {89.971}] [get_bd_cells clk_wiz_0]
set_property -dict [list CONFIG.CLK_OUT1_PORT {CLK310M} \
                         CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {310} \
                         CONFIG.RESET_TYPE {ACTIVE_LOW} \
                         CONFIG.MMCM_DIVCLK_DIVIDE {5} \
                         CONFIG.MMCM_CLKFBOUT_MULT_F {50.375} \
                         CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.250} \
                         CONFIG.RESET_PORT {resetn} \
                         CONFIG.CLKOUT1_JITTER {204.659} \
                         CONFIG.CLKOUT1_PHASE_ERROR {297.890}] [get_bd_cells clk_wiz_1]
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
connect_bd_net [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins clk_wiz_0/CLK100M]
apply_bd_automation -rule xilinx.com:bd_rule:microblaze \
                   -config { axi_intc {0} \
                             axi_periph {Enabled} \
                             cache {None} \
                             clk {/clk_wiz_0/CLK100M (100 MHz)} \
                             cores {1} \
                             debug_module {Debug Only} \
                             ecc {None} \
                             local_mem {64KB} \
                             preset {None}} [get_bd_cells microblaze_0]
apply_bd_automation -rule xilinx.com:bd_rule:board \
                    -config { Manual_Source {Auto}}  [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
apply_bd_automation -rule xilinx.com:bd_rule:board \
                    -config { Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins clk_wiz_0/resetn]
apply_bd_automation -rule xilinx.com:bd_rule:board \
                    -config { Manual_Source {Auto}}  [get_bd_pins rst_clk_wiz_0_100M/ext_reset_in]
connect_bd_net [get_bd_ports reset_rtl_0] [get_bd_pins clk_wiz_1/resetn]
set_property name CLK200M [get_bd_intf_ports diff_clock_rtl_0]
set_property name RESET [get_bd_ports reset_rtl_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
set_property -name {CONFIG.XML_INPUT_FILE} -value  {../../../../../../../mig_a.prj} -objects [get_bd_cells mig_7series_0]
set_property -name {CONFIG.RESET_BOARD_INTERFACE} -value  {Custom} -objects [get_bd_cells mig_7series_0]
set_property -name {CONFIG.MIG_DONT_TOUCH_PARAM} -value  {Custom} -objects [get_bd_cells mig_7series_0]
set_property -name {CONFIG.BOARD_MIG_PARAM} -value  {Custom} -objects [get_bd_cells mig_7series_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
                    -config { Clk_master {/clk_wiz_0/CLK100M (100 MHz)} \
                              Clk_slave {Auto} \
                              Clk_xbar {Auto} \
                              Master {/microblaze_0 (Periph)} \
                              Slave {/axi_timer_0/S_AXI} \
                              ddr_seg {Auto} \
                              intc_ip {New AXI Interconnect} \
                              master_apm {0}}  [get_bd_intf_pins axi_timer_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
                    -config { Clk_master {/clk_wiz_0/CLK100M (100 MHz)} \
                              Clk_slave {Auto} \
                              Clk_xbar {Auto} \
                              Master {/microblaze_0 (Periph)} \
                              Slave {/axi_uartlite_0/S_AXI} \
                              ddr_seg {Auto} \
                              intc_ip {New AXI Interconnect} \
                              master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board \
                    -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_uartlite_0/UART]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst \
                    -config { Clk {/clk_wiz_1/CLK310M (310 MHz)} \
                              Freq {310} \
                              Ref_Clk0 {None} \
                              Ref_Clk1 {None} \
                              Ref_Clk2 {None}}  [get_bd_pins mig_7series_0/clk_ref_i]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
                    -config { Clk_master {/clk_wiz_0/CLK100M (100 MHz)} \
                              Clk_slave {/mig_7series_0/ui_clk (155 MHz)} \
                              Clk_xbar {Auto} \
                              Master {/microblaze_0 (Periph)} \
                              Slave {/mig_7series_0/S_AXI} \
                              ddr_seg {Auto} \
                              intc_ip {New AXI SmartConnect} \
                              master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst \
                    -config { Clk {/clk_wiz_1/CLK310M (310 MHz)} \
                              Freq {310} \
                              Ref_Clk0 {None} \
                              Ref_Clk1 {None} \
                              Ref_Clk2 {None}}  [get_bd_pins mig_7series_0/sys_clk_i]
apply_bd_automation -rule xilinx.com:bd_rule:board \
                    -config { Manual_Source {Auto}}  [get_bd_pins mig_7series_0/sys_rst]
connect_bd_net [get_bd_ports RESET] [get_bd_pins mig_7series_0/sys_rst]
make_bd_intf_pins_external  [get_bd_intf_pins mig_7series_0/DDR3]
set_property name DDR3 [get_bd_intf_ports DDR3_0]
set_property name UART [get_bd_intf_ports uart_rtl_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0
connect_bd_intf_net [get_bd_intf_pins ila_0/SLOT_0_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
connect_bd_net [get_bd_pins ila_0/clk] [get_bd_pins clk_wiz_0/CLK100M]
regenerate_bd_layout
add_files -norecurse ./sources/mii2rgmii.v
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0
set_property -dict [list CONFIG.C_INCLUDE_GLOBAL_BUFFERS {0}] [get_bd_cells axi_ethernetlite_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
create_bd_cell -type module -reference mii2rgmii mii2rgmii_0
connect_bd_intf_net [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii2rgmii_0/MII]
connect_bd_net [get_bd_pins axi_ethernetlite_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_ports RESET] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn]
connect_bd_net [get_bd_pins axi_timer_0/interrupt] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins axi_intc_0/intr]
connect_bd_intf_net [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
make_bd_intf_pins_external  [get_bd_intf_pins mii2rgmii_0/RGMII]
set_property name RGMII [get_bd_intf_ports RGMII_0]
make_bd_pins_external  [get_bd_pins mii2rgmii_0/rgmii_reset_n]
set_property name RGMII_RESET_N [get_bd_ports rgmii_reset_n_0]
make_bd_intf_pins_external  [get_bd_intf_pins axi_ethernetlite_0/MDIO]
set_property name MDIO [get_bd_intf_ports MDIO_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
                    -config { Clk_master {/clk_wiz_0/CLK100M (100 MHz)} \
                              Clk_slave {Auto} \
                              Clk_xbar {/clk_wiz_0/CLK100M (100 MHz)} \
                              Master {/microblaze_0 (Periph)} \
                              Slave {/axi_ethernetlite_0/S_AXI} \
                              ddr_seg {Auto} \
                              intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
                    -config { Clk_master {/clk_wiz_0/CLK100M (100 MHz)} \
                              Clk_slave {Auto} \
                              Clk_xbar {/clk_wiz_0/CLK100M (100 MHz)} \
                              Master {/microblaze_0 (Periph)} \
                              Slave {/axi_intc_0/s_axi} \
                              ddr_seg {Auto} \
                              intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_intc_0/s_axi]
regenerate_bd_layout
set_property range 1M [get_bd_addr_segs {microblaze_0/Data/SEG_dlmb_bram_if_cntlr_Mem}]
set_property range 1M [get_bd_addr_segs {microblaze_0/Instruction/SEG_ilmb_bram_if_cntlr_Mem}]

save_bd_design
regenerate_bd_layout
validate_bd_design
save_bd_design

close_bd_design [get_bd_designs top]

# setup build environment
make_wrapper -files [get_files ./prj/prj.srcs/sources_1/bd/top/top.bd] -top
add_files -norecurse ./prj/prj.srcs/sources_1/bd/top/hdl/top_wrapper.v
update_compile_order -fileset sources_1
set_property top top_wrapper [current_fileset]

update_compile_order -fileset sources_1

reset_project

# build
launch_runs synth_1 -jobs 4
wait_on_run synth_1

launch_runs impl_1 -jobs 4
wait_on_run impl_1
open_run impl_1
report_utilization -file "./prj/project.rpt"
report_timing -file "./prj/project.rpt" -append

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

set_property pfm_name {} [get_files -all {./prj/prj.srcs/sources_1/bd/top/top.bd}]
write_hw_platform -fixed -include_bit -force -file ./prj/top_wrapper.xsa

close_project
quit
