# 200MHz
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVDS_25} [get_ports SYS_CLK_P]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVDS_25} [get_ports SYS_CLK_N]
create_clock -period 5.000 -name clk_pin -waveform {0.000 2.500} -add [get_ports SYS_CLK_P]

# PUSH BUBTTON
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports sys_rst]

# HDMI CN2
set_property -dict {PACKAGE_PIN V20 IOSTANDARD TMDS_33} [get_ports TMDS_TX_Clk_n]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD TMDS_33} [get_ports TMDS_TX_Clk_p]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_n[0]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_p[0]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_n[1]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_p[1]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_n[2]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_p[2]}]
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_SCL]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_SDA]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_OUT_EN]
set_property PACKAGE_PIN B21 [get_ports TMDS_TX_HPD]
set_property IOSTANDARD LVCMOS33 [get_ports TMDS_TX_HPD]
set_property PULLUP true [get_ports TMDS_TX_HPD]

# HDMI CN3
set_property -dict {PACKAGE_PIN W20 IOSTANDARD TMDS_33} [get_ports TMDS_RX_Clk_n]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD TMDS_33} [get_ports TMDS_RX_Clk_p]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_n[0]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_p[0]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_n[1]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_p[1]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_n[2]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_p[2]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_SCL]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_SDA]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_OUT_EN]
set_property PACKAGE_PIN E22 [get_ports TMDS_RX_HPD]
set_property IOSTANDARD LVCMOS33 [get_ports TMDS_RX_HPD]
set_property PULLUP true [get_ports TMDS_RX_HPD]

# 74.25MHz
create_clock -period 13.468 -waveform {0.000 6.734} [get_ports TMDS_RX_Clk_p]

# ON BOARD LEDs
set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {LED[0]}]
set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS33} [get_ports {LED[2]}]

# Ethernet
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33} [get_ports {GEPHY_RD[3]}]
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33} [get_ports {GEPHY_RD[2]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33} [get_ports {GEPHY_RD[1]}]
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports {GEPHY_RD[0]}]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33} [get_ports {GEPHY_TD[3]}]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33} [get_ports {GEPHY_TD[2]}]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33} [get_ports {GEPHY_TD[1]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {GEPHY_TD[0]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports GEPHY_PMEB]
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33} [get_ports GEPHY_RCK]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports GEPHY_RST_N]
set_property -dict {PACKAGE_PIN AA9 IOSTANDARD LVCMOS33} [get_ports GEPHY_RXDV_ER]
set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS33} [get_ports GEPHY_TCK]
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33} [get_ports GEPHY_TXEN_ER]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33} [get_ports GEPHY_INT_N]
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33} [get_ports GEPHY_MDC]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports GEPHY_MDIO]
create_clock -period 8.000 -name rgmii_rxclk -waveform {0.000 4.000} [get_ports GEPHY_RCK]

## set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]
set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]]

set_false_path -from [get_clocks rgmii_rxclk] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks rgmii_rxclk]

set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_memc_ui_top_std/mem_intfc0/ddr_phy_top0/u_ddr_mc_phy_wrapper/u_ddr_mc_phy/ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in/ICLK]]
set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_memc_ui_top_std/mem_intfc0/ddr_phy_top0/u_ddr_mc_phy_wrapper/u_ddr_mc_phy/ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in/ICLK]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]

set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins U_DVI2RGB/TMDS_ClockingX/PixelClkBuffer/O]]
set_false_path -from [get_clocks -of_objects [get_pins U_DVI2RGB/TMDS_ClockingX/PixelClkBuffer/O]] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]]

set_false_path -from [get_clocks -of_objects [get_pins U_DVI2RGB/TMDS_ClockingX/PixelClkBuffer/O]] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins U_DVI2RGB/TMDS_ClockingX/PixelClkBuffer/O]]

set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]

set_false_path -from [get_clocks -of_objects [get_pins U_DVI2RGB/TMDS_ClockingX/PixelClkBuffer/O]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]
set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins U_DVI2RGB/TMDS_ClockingX/PixelClkBuffer/O]]

set_false_path -from [get_clocks rgmii_rxclk] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]
set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks rgmii_rxclk]


## 90-degree shift from RCK
set_input_delay -clock [get_clocks rgmii_rxclk] -clock_fall -min -add_delay 1.000 [get_ports {GEPHY_RD[*]}]
set_input_delay -clock [get_clocks rgmii_rxclk] -clock_fall -max -add_delay 3.000 [get_ports {GEPHY_RD[*]}]
set_input_delay -clock [get_clocks rgmii_rxclk] -min -add_delay 1.000 [get_ports {GEPHY_RD[*]}]
set_input_delay -clock [get_clocks rgmii_rxclk] -max -add_delay 3.000 [get_ports {GEPHY_RD[*]}]
set_input_delay -clock [get_clocks rgmii_rxclk] -clock_fall -min -add_delay 1.000 [get_ports GEPHY_RXDV_ER]
set_input_delay -clock [get_clocks rgmii_rxclk] -clock_fall -max -add_delay 3.000 [get_ports GEPHY_RXDV_ER]
set_input_delay -clock [get_clocks rgmii_rxclk] -min -add_delay 1.000 [get_ports GEPHY_RXDV_ER]
set_input_delay -clock [get_clocks rgmii_rxclk] -max -add_delay 3.000 [get_ports GEPHY_RXDV_ER]

## 90-degree shift from TCK
create_generated_clock -name GEPHY_TCK -source [get_pins u_e7udpip/u_e7udpip/u_ether/u_gmiitx/miitxregs_a7.txclk_ddr/C] -divide_by 1 [get_ports GEPHY_TCK]
set_output_delay -clock [get_clocks GEPHY_TCK] -clock_fall -min -add_delay 1.000 [get_ports {GEPHY_TD[*]}]
set_output_delay -clock [get_clocks GEPHY_TCK] -clock_fall -max -add_delay 3.000 [get_ports {GEPHY_TD[*]}]
set_output_delay -clock [get_clocks GEPHY_TCK] -max -add_delay 3.000 [get_ports {GEPHY_TD[*]}]
set_output_delay -clock [get_clocks GEPHY_TCK] -max -add_delay 3.000 [get_ports {GEPHY_TD[*]}]

set_output_delay -clock [get_clocks GEPHY_TCK] -clock_fall -min -add_delay 1.000 [get_ports GEPHY_TXEN_ER]
set_output_delay -clock [get_clocks GEPHY_TCK] -clock_fall -max -add_delay 3.000 [get_ports GEPHY_TXEN_ER]
set_output_delay -clock [get_clocks GEPHY_TCK] -min -add_delay 1.000 [get_ports GEPHY_TXEN_ER]
set_output_delay -clock [get_clocks GEPHY_TCK] -max -add_delay 3.000 [get_ports GEPHY_TXEN_ER]

set_property OFFCHIP_TERM NONE [get_ports LED0]
set_property OFFCHIP_TERM NONE [get_ports LED1]
set_property OFFCHIP_TERM NONE [get_ports LED2]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]







connect_debug_port u_ila_0/clk [get_nets [list u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/CLK]]

connect_debug_port u_ila_0/clk [get_nets [list u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i_0]]



connect_debug_port u_ila_0/clk [get_nets [list u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/CLK]]

set_property OFFCHIP_TERM NONE [get_ports GEPHY_RST_N]
set_property OFFCHIP_TERM NONE [get_ports GEPHY_TCK]
set_property OFFCHIP_TERM NONE [get_ports GEPHY_TXEN_ER]
set_property OFFCHIP_TERM NONE [get_ports GEPHY_TD[3]]
set_property OFFCHIP_TERM NONE [get_ports GEPHY_TD[2]]
set_property OFFCHIP_TERM NONE [get_ports GEPHY_TD[1]]
set_property OFFCHIP_TERM NONE [get_ports GEPHY_TD[0]]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 12 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_dram_copy/RPOS_X[0]} {u_dram_copy/RPOS_X[1]} {u_dram_copy/RPOS_X[2]} {u_dram_copy/RPOS_X[3]} {u_dram_copy/RPOS_X[4]} {u_dram_copy/RPOS_X[5]} {u_dram_copy/RPOS_X[6]} {u_dram_copy/RPOS_X[7]} {u_dram_copy/RPOS_X[8]} {u_dram_copy/RPOS_X[9]} {u_dram_copy/RPOS_X[10]} {u_dram_copy/RPOS_X[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_dram_copy/u_processing_wrapper/WPOSX[0]} {u_dram_copy/u_processing_wrapper/WPOSX[1]} {u_dram_copy/u_processing_wrapper/WPOSX[2]} {u_dram_copy/u_processing_wrapper/WPOSX[3]} {u_dram_copy/u_processing_wrapper/WPOSX[4]} {u_dram_copy/u_processing_wrapper/WPOSX[5]} {u_dram_copy/u_processing_wrapper/WPOSX[6]} {u_dram_copy/u_processing_wrapper/WPOSX[7]} {u_dram_copy/u_processing_wrapper/WPOSX[8]} {u_dram_copy/u_processing_wrapper/WPOSX[9]} {u_dram_copy/u_processing_wrapper/WPOSX[10]} {u_dram_copy/u_processing_wrapper/WPOSX[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_dram_copy/READFIFO_CNT[0]} {u_dram_copy/READFIFO_CNT[1]} {u_dram_copy/READFIFO_CNT[2]} {u_dram_copy/READFIFO_CNT[3]} {u_dram_copy/READFIFO_CNT[4]} {u_dram_copy/READFIFO_CNT[5]} {u_dram_copy/READFIFO_CNT[6]} {u_dram_copy/READFIFO_CNT[7]} {u_dram_copy/READFIFO_CNT[8]} {u_dram_copy/READFIFO_CNT[9]} {u_dram_copy/READFIFO_CNT[10]} {u_dram_copy/READFIFO_CNT[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 12 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_dram_copy/u_processing_wrapper/POSX[0]} {u_dram_copy/u_processing_wrapper/POSX[1]} {u_dram_copy/u_processing_wrapper/POSX[2]} {u_dram_copy/u_processing_wrapper/POSX[3]} {u_dram_copy/u_processing_wrapper/POSX[4]} {u_dram_copy/u_processing_wrapper/POSX[5]} {u_dram_copy/u_processing_wrapper/POSX[6]} {u_dram_copy/u_processing_wrapper/POSX[7]} {u_dram_copy/u_processing_wrapper/POSX[8]} {u_dram_copy/u_processing_wrapper/POSX[9]} {u_dram_copy/u_processing_wrapper/POSX[10]} {u_dram_copy/u_processing_wrapper/POSX[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_dram_copy/u_processing_wrapper/POSY[0]} {u_dram_copy/u_processing_wrapper/POSY[1]} {u_dram_copy/u_processing_wrapper/POSY[2]} {u_dram_copy/u_processing_wrapper/POSY[3]} {u_dram_copy/u_processing_wrapper/POSY[4]} {u_dram_copy/u_processing_wrapper/POSY[5]} {u_dram_copy/u_processing_wrapper/POSY[6]} {u_dram_copy/u_processing_wrapper/POSY[7]} {u_dram_copy/u_processing_wrapper/POSY[8]} {u_dram_copy/u_processing_wrapper/POSY[9]} {u_dram_copy/u_processing_wrapper/POSY[10]} {u_dram_copy/u_processing_wrapper/POSY[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 3 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_dram_copy/state_READ[0]} {u_dram_copy/state_READ[1]} {u_dram_copy/state_READ[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {u_dram_copy/RPOS_Y[0]} {u_dram_copy/RPOS_Y[1]} {u_dram_copy/RPOS_Y[2]} {u_dram_copy/RPOS_Y[3]} {u_dram_copy/RPOS_Y[4]} {u_dram_copy/RPOS_Y[5]} {u_dram_copy/RPOS_Y[6]} {u_dram_copy/RPOS_Y[7]} {u_dram_copy/RPOS_Y[8]} {u_dram_copy/RPOS_Y[9]} {u_dram_copy/RPOS_Y[10]} {u_dram_copy/RPOS_Y[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 12 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {u_dram_copy/WPOS_Y[0]} {u_dram_copy/WPOS_Y[1]} {u_dram_copy/WPOS_Y[2]} {u_dram_copy/WPOS_Y[3]} {u_dram_copy/WPOS_Y[4]} {u_dram_copy/WPOS_Y[5]} {u_dram_copy/WPOS_Y[6]} {u_dram_copy/WPOS_Y[7]} {u_dram_copy/WPOS_Y[8]} {u_dram_copy/WPOS_Y[9]} {u_dram_copy/WPOS_Y[10]} {u_dram_copy/WPOS_Y[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 3 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {u_dram_copy/state_WRITE[0]} {u_dram_copy/state_WRITE[1]} {u_dram_copy/state_WRITE[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 12 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {u_dram_copy/WPOS_X[0]} {u_dram_copy/WPOS_X[1]} {u_dram_copy/WPOS_X[2]} {u_dram_copy/WPOS_X[3]} {u_dram_copy/WPOS_X[4]} {u_dram_copy/WPOS_X[5]} {u_dram_copy/WPOS_X[6]} {u_dram_copy/WPOS_X[7]} {u_dram_copy/WPOS_X[8]} {u_dram_copy/WPOS_X[9]} {u_dram_copy/WPOS_X[10]} {u_dram_copy/WPOS_X[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {udp_axi/buf_dout[0]} {udp_axi/buf_dout[1]} {udp_axi/buf_dout[2]} {udp_axi/buf_dout[3]} {udp_axi/buf_dout[4]} {udp_axi/buf_dout[5]} {udp_axi/buf_dout[6]} {udp_axi/buf_dout[7]} {udp_axi/buf_dout[8]} {udp_axi/buf_dout[9]} {udp_axi/buf_dout[10]} {udp_axi/buf_dout[11]} {udp_axi/buf_dout[12]} {udp_axi/buf_dout[13]} {udp_axi/buf_dout[14]} {udp_axi/buf_dout[15]} {udp_axi/buf_dout[16]} {udp_axi/buf_dout[17]} {udp_axi/buf_dout[18]} {udp_axi/buf_dout[19]} {udp_axi/buf_dout[20]} {udp_axi/buf_dout[21]} {udp_axi/buf_dout[22]} {udp_axi/buf_dout[23]} {udp_axi/buf_dout[24]} {udp_axi/buf_dout[25]} {udp_axi/buf_dout[26]} {udp_axi/buf_dout[27]} {udp_axi/buf_dout[28]} {udp_axi/buf_dout[29]} {udp_axi/buf_dout[30]} {udp_axi/buf_dout[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {m1_axi_awlen[0]} {m1_axi_awlen[1]} {m1_axi_awlen[2]} {m1_axi_awlen[3]} {m1_axi_awlen[4]} {m1_axi_awlen[5]} {m1_axi_awlen[6]} {m1_axi_awlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {m1_axi_awaddr[0]} {m1_axi_awaddr[1]} {m1_axi_awaddr[2]} {m1_axi_awaddr[3]} {m1_axi_awaddr[4]} {m1_axi_awaddr[5]} {m1_axi_awaddr[6]} {m1_axi_awaddr[7]} {m1_axi_awaddr[8]} {m1_axi_awaddr[9]} {m1_axi_awaddr[10]} {m1_axi_awaddr[11]} {m1_axi_awaddr[12]} {m1_axi_awaddr[13]} {m1_axi_awaddr[14]} {m1_axi_awaddr[15]} {m1_axi_awaddr[16]} {m1_axi_awaddr[17]} {m1_axi_awaddr[18]} {m1_axi_awaddr[19]} {m1_axi_awaddr[20]} {m1_axi_awaddr[21]} {m1_axi_awaddr[22]} {m1_axi_awaddr[23]} {m1_axi_awaddr[24]} {m1_axi_awaddr[25]} {m1_axi_awaddr[26]} {m1_axi_awaddr[27]} {m1_axi_awaddr[28]} {m1_axi_awaddr[29]} {m1_axi_awaddr[30]} {m1_axi_awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {m0_axi_awaddr[0]} {m0_axi_awaddr[1]} {m0_axi_awaddr[2]} {m0_axi_awaddr[3]} {m0_axi_awaddr[4]} {m0_axi_awaddr[5]} {m0_axi_awaddr[6]} {m0_axi_awaddr[7]} {m0_axi_awaddr[8]} {m0_axi_awaddr[9]} {m0_axi_awaddr[10]} {m0_axi_awaddr[11]} {m0_axi_awaddr[12]} {m0_axi_awaddr[13]} {m0_axi_awaddr[14]} {m0_axi_awaddr[15]} {m0_axi_awaddr[16]} {m0_axi_awaddr[17]} {m0_axi_awaddr[18]} {m0_axi_awaddr[19]} {m0_axi_awaddr[20]} {m0_axi_awaddr[21]} {m0_axi_awaddr[22]} {m0_axi_awaddr[23]} {m0_axi_awaddr[24]} {m0_axi_awaddr[25]} {m0_axi_awaddr[26]} {m0_axi_awaddr[27]} {m0_axi_awaddr[28]} {m0_axi_awaddr[29]} {m0_axi_awaddr[30]} {m0_axi_awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {s_axi_awaddr[0]} {s_axi_awaddr[1]} {s_axi_awaddr[2]} {s_axi_awaddr[3]} {s_axi_awaddr[4]} {s_axi_awaddr[5]} {s_axi_awaddr[6]} {s_axi_awaddr[7]} {s_axi_awaddr[8]} {s_axi_awaddr[9]} {s_axi_awaddr[10]} {s_axi_awaddr[11]} {s_axi_awaddr[12]} {s_axi_awaddr[13]} {s_axi_awaddr[14]} {s_axi_awaddr[15]} {s_axi_awaddr[16]} {s_axi_awaddr[17]} {s_axi_awaddr[18]} {s_axi_awaddr[19]} {s_axi_awaddr[20]} {s_axi_awaddr[21]} {s_axi_awaddr[22]} {s_axi_awaddr[23]} {s_axi_awaddr[24]} {s_axi_awaddr[25]} {s_axi_awaddr[26]} {s_axi_awaddr[27]} {s_axi_awaddr[28]} {s_axi_awaddr[29]} {s_axi_awaddr[30]} {s_axi_awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {s_axi_awlen[0]} {s_axi_awlen[1]} {s_axi_awlen[2]} {s_axi_awlen[3]} {s_axi_awlen[4]} {s_axi_awlen[5]} {s_axi_awlen[6]} {s_axi_awlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 3 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {s_axi_awsize[0]} {s_axi_awsize[1]} {s_axi_awsize[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {m0_axi_awlen[0]} {m0_axi_awlen[1]} {m0_axi_awlen[2]} {m0_axi_awlen[3]} {m0_axi_awlen[4]} {m0_axi_awlen[5]} {m0_axi_awlen[6]} {m0_axi_awlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list udp_axi/buf_we]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list udp_axi/busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list ctrl_in1_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list data_in1_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list u_dram_copy/END]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list u_dram_copy/u_processing_wrapper/KICK]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list m0_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list m0_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list m0_axi_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list m0_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list m0_axi_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list m1_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list m1_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list m1_axi_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list m1_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list m1_axi_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list u_dram_copy/u_processing_wrapper/READ_LINE_DONE]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list s_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list s_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list s_axi_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list s_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list s_axi_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list validreadytest]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list u_dram_copy/WRITESTART]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list u_clk_wiz_1/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 8 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {udp_axi/fifo_cnt[0]} {udp_axi/fifo_cnt[1]} {udp_axi/fifo_cnt[2]} {udp_axi/fifo_cnt[3]} {udp_axi/fifo_cnt[4]} {udp_axi/fifo_cnt[5]} {udp_axi/fifo_cnt[6]} {udp_axi/fifo_cnt[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 32 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {udp_axi/interval_val[0]} {udp_axi/interval_val[1]} {udp_axi/interval_val[2]} {udp_axi/interval_val[3]} {udp_axi/interval_val[4]} {udp_axi/interval_val[5]} {udp_axi/interval_val[6]} {udp_axi/interval_val[7]} {udp_axi/interval_val[8]} {udp_axi/interval_val[9]} {udp_axi/interval_val[10]} {udp_axi/interval_val[11]} {udp_axi/interval_val[12]} {udp_axi/interval_val[13]} {udp_axi/interval_val[14]} {udp_axi/interval_val[15]} {udp_axi/interval_val[16]} {udp_axi/interval_val[17]} {udp_axi/interval_val[18]} {udp_axi/interval_val[19]} {udp_axi/interval_val[20]} {udp_axi/interval_val[21]} {udp_axi/interval_val[22]} {udp_axi/interval_val[23]} {udp_axi/interval_val[24]} {udp_axi/interval_val[25]} {udp_axi/interval_val[26]} {udp_axi/interval_val[27]} {udp_axi/interval_val[28]} {udp_axi/interval_val[29]} {udp_axi/interval_val[30]} {udp_axi/interval_val[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 32 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {udp_axi/cnt[0]} {udp_axi/cnt[1]} {udp_axi/cnt[2]} {udp_axi/cnt[3]} {udp_axi/cnt[4]} {udp_axi/cnt[5]} {udp_axi/cnt[6]} {udp_axi/cnt[7]} {udp_axi/cnt[8]} {udp_axi/cnt[9]} {udp_axi/cnt[10]} {udp_axi/cnt[11]} {udp_axi/cnt[12]} {udp_axi/cnt[13]} {udp_axi/cnt[14]} {udp_axi/cnt[15]} {udp_axi/cnt[16]} {udp_axi/cnt[17]} {udp_axi/cnt[18]} {udp_axi/cnt[19]} {udp_axi/cnt[20]} {udp_axi/cnt[21]} {udp_axi/cnt[22]} {udp_axi/cnt[23]} {udp_axi/cnt[24]} {udp_axi/cnt[25]} {udp_axi/cnt[26]} {udp_axi/cnt[27]} {udp_axi/cnt[28]} {udp_axi/cnt[29]} {udp_axi/cnt[30]} {udp_axi/cnt[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 32 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {udp_axi/header_reg[1]__0[0]} {udp_axi/header_reg[1]__0[1]} {udp_axi/header_reg[1]__0[2]} {udp_axi/header_reg[1]__0[3]} {udp_axi/header_reg[1]__0[4]} {udp_axi/header_reg[1]__0[5]} {udp_axi/header_reg[1]__0[6]} {udp_axi/header_reg[1]__0[7]} {udp_axi/header_reg[1]__0[8]} {udp_axi/header_reg[1]__0[9]} {udp_axi/header_reg[1]__0[10]} {udp_axi/header_reg[1]__0[11]} {udp_axi/header_reg[1]__0[12]} {udp_axi/header_reg[1]__0[13]} {udp_axi/header_reg[1]__0[14]} {udp_axi/header_reg[1]__0[15]} {udp_axi/header_reg[1]__0[16]} {udp_axi/header_reg[1]__0[17]} {udp_axi/header_reg[1]__0[18]} {udp_axi/header_reg[1]__0[19]} {udp_axi/header_reg[1]__0[20]} {udp_axi/header_reg[1]__0[21]} {udp_axi/header_reg[1]__0[22]} {udp_axi/header_reg[1]__0[23]} {udp_axi/header_reg[1]__0[24]} {udp_axi/header_reg[1]__0[25]} {udp_axi/header_reg[1]__0[26]} {udp_axi/header_reg[1]__0[27]} {udp_axi/header_reg[1]__0[28]} {udp_axi/header_reg[1]__0[29]} {udp_axi/header_reg[1]__0[30]} {udp_axi/header_reg[1]__0[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 32 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {udp_axi/header_reg[2]__0[0]} {udp_axi/header_reg[2]__0[1]} {udp_axi/header_reg[2]__0[2]} {udp_axi/header_reg[2]__0[3]} {udp_axi/header_reg[2]__0[4]} {udp_axi/header_reg[2]__0[5]} {udp_axi/header_reg[2]__0[6]} {udp_axi/header_reg[2]__0[7]} {udp_axi/header_reg[2]__0[8]} {udp_axi/header_reg[2]__0[9]} {udp_axi/header_reg[2]__0[10]} {udp_axi/header_reg[2]__0[11]} {udp_axi/header_reg[2]__0[12]} {udp_axi/header_reg[2]__0[13]} {udp_axi/header_reg[2]__0[14]} {udp_axi/header_reg[2]__0[15]} {udp_axi/header_reg[2]__0[16]} {udp_axi/header_reg[2]__0[17]} {udp_axi/header_reg[2]__0[18]} {udp_axi/header_reg[2]__0[19]} {udp_axi/header_reg[2]__0[20]} {udp_axi/header_reg[2]__0[21]} {udp_axi/header_reg[2]__0[22]} {udp_axi/header_reg[2]__0[23]} {udp_axi/header_reg[2]__0[24]} {udp_axi/header_reg[2]__0[25]} {udp_axi/header_reg[2]__0[26]} {udp_axi/header_reg[2]__0[27]} {udp_axi/header_reg[2]__0[28]} {udp_axi/header_reg[2]__0[29]} {udp_axi/header_reg[2]__0[30]} {udp_axi/header_reg[2]__0[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 32 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list {udp_axi/read_addr[0]} {udp_axi/read_addr[1]} {udp_axi/read_addr[2]} {udp_axi/read_addr[3]} {udp_axi/read_addr[4]} {udp_axi/read_addr[5]} {udp_axi/read_addr[6]} {udp_axi/read_addr[7]} {udp_axi/read_addr[8]} {udp_axi/read_addr[9]} {udp_axi/read_addr[10]} {udp_axi/read_addr[11]} {udp_axi/read_addr[12]} {udp_axi/read_addr[13]} {udp_axi/read_addr[14]} {udp_axi/read_addr[15]} {udp_axi/read_addr[16]} {udp_axi/read_addr[17]} {udp_axi/read_addr[18]} {udp_axi/read_addr[19]} {udp_axi/read_addr[20]} {udp_axi/read_addr[21]} {udp_axi/read_addr[22]} {udp_axi/read_addr[23]} {udp_axi/read_addr[24]} {udp_axi/read_addr[25]} {udp_axi/read_addr[26]} {udp_axi/read_addr[27]} {udp_axi/read_addr[28]} {udp_axi/read_addr[29]} {udp_axi/read_addr[30]} {udp_axi/read_addr[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 32 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list {udp_axi/read_num[0]} {udp_axi/read_num[1]} {udp_axi/read_num[2]} {udp_axi/read_num[3]} {udp_axi/read_num[4]} {udp_axi/read_num[5]} {udp_axi/read_num[6]} {udp_axi/read_num[7]} {udp_axi/read_num[8]} {udp_axi/read_num[9]} {udp_axi/read_num[10]} {udp_axi/read_num[11]} {udp_axi/read_num[12]} {udp_axi/read_num[13]} {udp_axi/read_num[14]} {udp_axi/read_num[15]} {udp_axi/read_num[16]} {udp_axi/read_num[17]} {udp_axi/read_num[18]} {udp_axi/read_num[19]} {udp_axi/read_num[20]} {udp_axi/read_num[21]} {udp_axi/read_num[22]} {udp_axi/read_num[23]} {udp_axi/read_num[24]} {udp_axi/read_num[25]} {udp_axi/read_num[26]} {udp_axi/read_num[27]} {udp_axi/read_num[28]} {udp_axi/read_num[29]} {udp_axi/read_num[30]} {udp_axi/read_num[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 32 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list {udp_axi/header_reg[0]__0[0]} {udp_axi/header_reg[0]__0[1]} {udp_axi/header_reg[0]__0[2]} {udp_axi/header_reg[0]__0[3]} {udp_axi/header_reg[0]__0[4]} {udp_axi/header_reg[0]__0[5]} {udp_axi/header_reg[0]__0[6]} {udp_axi/header_reg[0]__0[7]} {udp_axi/header_reg[0]__0[8]} {udp_axi/header_reg[0]__0[9]} {udp_axi/header_reg[0]__0[10]} {udp_axi/header_reg[0]__0[11]} {udp_axi/header_reg[0]__0[12]} {udp_axi/header_reg[0]__0[13]} {udp_axi/header_reg[0]__0[14]} {udp_axi/header_reg[0]__0[15]} {udp_axi/header_reg[0]__0[16]} {udp_axi/header_reg[0]__0[17]} {udp_axi/header_reg[0]__0[18]} {udp_axi/header_reg[0]__0[19]} {udp_axi/header_reg[0]__0[20]} {udp_axi/header_reg[0]__0[21]} {udp_axi/header_reg[0]__0[22]} {udp_axi/header_reg[0]__0[23]} {udp_axi/header_reg[0]__0[24]} {udp_axi/header_reg[0]__0[25]} {udp_axi/header_reg[0]__0[26]} {udp_axi/header_reg[0]__0[27]} {udp_axi/header_reg[0]__0[28]} {udp_axi/header_reg[0]__0[29]} {udp_axi/header_reg[0]__0[30]} {udp_axi/header_reg[0]__0[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 32 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list {udp_axi/header_reg[3]__0[0]} {udp_axi/header_reg[3]__0[1]} {udp_axi/header_reg[3]__0[2]} {udp_axi/header_reg[3]__0[3]} {udp_axi/header_reg[3]__0[4]} {udp_axi/header_reg[3]__0[5]} {udp_axi/header_reg[3]__0[6]} {udp_axi/header_reg[3]__0[7]} {udp_axi/header_reg[3]__0[8]} {udp_axi/header_reg[3]__0[9]} {udp_axi/header_reg[3]__0[10]} {udp_axi/header_reg[3]__0[11]} {udp_axi/header_reg[3]__0[12]} {udp_axi/header_reg[3]__0[13]} {udp_axi/header_reg[3]__0[14]} {udp_axi/header_reg[3]__0[15]} {udp_axi/header_reg[3]__0[16]} {udp_axi/header_reg[3]__0[17]} {udp_axi/header_reg[3]__0[18]} {udp_axi/header_reg[3]__0[19]} {udp_axi/header_reg[3]__0[20]} {udp_axi/header_reg[3]__0[21]} {udp_axi/header_reg[3]__0[22]} {udp_axi/header_reg[3]__0[23]} {udp_axi/header_reg[3]__0[24]} {udp_axi/header_reg[3]__0[25]} {udp_axi/header_reg[3]__0[26]} {udp_axi/header_reg[3]__0[27]} {udp_axi/header_reg[3]__0[28]} {udp_axi/header_reg[3]__0[29]} {udp_axi/header_reg[3]__0[30]} {udp_axi/header_reg[3]__0[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
set_property port_width 3 [get_debug_ports u_ila_1/probe9]
connect_debug_port u_ila_1/probe9 [get_nets [list {udp_axi/header_cnt[0]} {udp_axi/header_cnt[1]} {udp_axi/header_cnt[2]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe10]
set_property port_width 32 [get_debug_ports u_ila_1/probe10]
connect_debug_port u_ila_1/probe10 [get_nets [list {udp_axi/r_data[0]} {udp_axi/r_data[1]} {udp_axi/r_data[2]} {udp_axi/r_data[3]} {udp_axi/r_data[4]} {udp_axi/r_data[5]} {udp_axi/r_data[6]} {udp_axi/r_data[7]} {udp_axi/r_data[8]} {udp_axi/r_data[9]} {udp_axi/r_data[10]} {udp_axi/r_data[11]} {udp_axi/r_data[12]} {udp_axi/r_data[13]} {udp_axi/r_data[14]} {udp_axi/r_data[15]} {udp_axi/r_data[16]} {udp_axi/r_data[17]} {udp_axi/r_data[18]} {udp_axi/r_data[19]} {udp_axi/r_data[20]} {udp_axi/r_data[21]} {udp_axi/r_data[22]} {udp_axi/r_data[23]} {udp_axi/r_data[24]} {udp_axi/r_data[25]} {udp_axi/r_data[26]} {udp_axi/r_data[27]} {udp_axi/r_data[28]} {udp_axi/r_data[29]} {udp_axi/r_data[30]} {udp_axi/r_data[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe11]
set_property port_width 4 [get_debug_ports u_ila_1/probe11]
connect_debug_port u_ila_1/probe11 [get_nets [list {udp_axi/state[0]} {udp_axi/state[1]} {udp_axi/state[2]} {udp_axi/state[3]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe12]
set_property port_width 32 [get_debug_ports u_ila_1/probe12]
connect_debug_port u_ila_1/probe12 [get_nets [list {udp_axi/w_data[0]} {udp_axi/w_data[1]} {udp_axi/w_data[2]} {udp_axi/w_data[3]} {udp_axi/w_data[4]} {udp_axi/w_data[5]} {udp_axi/w_data[6]} {udp_axi/w_data[7]} {udp_axi/w_data[8]} {udp_axi/w_data[9]} {udp_axi/w_data[10]} {udp_axi/w_data[11]} {udp_axi/w_data[12]} {udp_axi/w_data[13]} {udp_axi/w_data[14]} {udp_axi/w_data[15]} {udp_axi/w_data[16]} {udp_axi/w_data[17]} {udp_axi/w_data[18]} {udp_axi/w_data[19]} {udp_axi/w_data[20]} {udp_axi/w_data[21]} {udp_axi/w_data[22]} {udp_axi/w_data[23]} {udp_axi/w_data[24]} {udp_axi/w_data[25]} {udp_axi/w_data[26]} {udp_axi/w_data[27]} {udp_axi/w_data[28]} {udp_axi/w_data[29]} {udp_axi/w_data[30]} {udp_axi/w_data[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe13]
set_property port_width 1 [get_debug_ports u_ila_1/probe13]
connect_debug_port u_ila_1/probe13 [get_nets [list udp_axi/frame_select]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe14]
set_property port_width 1 [get_debug_ports u_ila_1/probe14]
connect_debug_port u_ila_1/probe14 [get_nets [list udp_axi/kick]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe15]
set_property port_width 1 [get_debug_ports u_ila_1/probe15]
connect_debug_port u_ila_1/probe15 [get_nets [list udp_axi/r_ack]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe16]
set_property port_width 1 [get_debug_ports u_ila_1/probe16]
connect_debug_port u_ila_1/probe16 [get_nets [list udp_axi/r_enable]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe17]
set_property port_width 1 [get_debug_ports u_ila_1/probe17]
connect_debug_port u_ila_1/probe17 [get_nets [list udp_axi/r_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe18]
set_property port_width 1 [get_debug_ports u_ila_1/probe18]
connect_debug_port u_ila_1/probe18 [get_nets [list udp_axi/w_ack]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe19]
set_property port_width 1 [get_debug_ports u_ila_1/probe19]
connect_debug_port u_ila_1/probe19 [get_nets [list udp_axi/w_enable]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe20]
set_property port_width 1 [get_debug_ports u_ila_1/probe20]
connect_debug_port u_ila_1/probe20 [get_nets [list udp_axi/w_req]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets rgb2dvi_pixel_clk]
