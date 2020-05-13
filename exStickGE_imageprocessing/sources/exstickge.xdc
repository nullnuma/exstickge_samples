# 200MHz
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVDS_25} [get_ports SYS_CLK_P]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVDS_25} [get_ports SYS_CLK_N]
create_clock -period 5.000 -name clk_pin -waveform {0.000 2.500} -add [get_ports SYS_CLK_P]

# PUSH BUBTTON
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports sys_rst]

# HDMI CN2
set_property -dict {PACKAGE_PIN V20 IOSTANDARD TMDS_33} [get_ports TMDS_RX_Clk_n]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD TMDS_33} [get_ports TMDS_RX_Clk_p]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_n[0]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_p[0]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_n[1]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_p[1]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_n[2]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD TMDS_33} [get_ports {TMDS_RX_Data_p[2]}]
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_SCL]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_SDA]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_OUT_EN]
set_property PACKAGE_PIN B21 [get_ports TMDS_RX_HPD]
set_property IOSTANDARD LVCMOS33 [get_ports TMDS_RX_HPD]
set_property PULLUP true [get_ports TMDS_RX_HPD]

# HDMI CN3
set_property -dict {PACKAGE_PIN W20 IOSTANDARD TMDS_33} [get_ports TMDS_TX_Clk_n]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD TMDS_33} [get_ports TMDS_TX_Clk_p]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_n[0]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_p[0]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_n[1]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_p[1]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_n[2]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD TMDS_33} [get_ports {TMDS_TX_Data_p[2]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_SCL]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_SDA]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_OUT_EN]
set_property PACKAGE_PIN E22 [get_ports TMDS_TX_HPD]
set_property IOSTANDARD LVCMOS33 [get_ports TMDS_TX_HPD]
set_property PULLUP true [get_ports TMDS_TX_HPD]

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





connect_debug_port u_ila_0/probe0 [get_nets [list {rgb2dram_inst/write_cnt[0]} {rgb2dram_inst/write_cnt[1]} {rgb2dram_inst/write_cnt[2]} {rgb2dram_inst/write_cnt[3]} {rgb2dram_inst/write_cnt[4]} {rgb2dram_inst/write_cnt[5]} {rgb2dram_inst/write_cnt[6]} {rgb2dram_inst/write_cnt[7]}]]




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
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {read_addr1[0]} {read_addr1[1]} {read_addr1[2]} {read_addr1[3]} {read_addr1[4]} {read_addr1[5]} {read_addr1[6]} {read_addr1[7]} {read_addr1[8]} {read_addr1[9]} {read_addr1[10]} {read_addr1[11]} {read_addr1[12]} {read_addr1[13]} {read_addr1[14]} {read_addr1[15]} {read_addr1[16]} {read_addr1[17]} {read_addr1[18]} {read_addr1[19]} {read_addr1[20]} {read_addr1[21]} {read_addr1[22]} {read_addr1[23]} {read_addr1[24]} {read_addr1[25]} {read_addr1[26]} {read_addr1[27]} {read_addr1[28]} {read_addr1[29]} {read_addr1[30]} {read_addr1[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {read_num1[0]} {read_num1[1]} {read_num1[2]} {read_num1[3]} {read_num1[4]} {read_num1[5]} {read_num1[6]} {read_num1[7]} {read_num1[8]} {read_num1[9]} {read_num1[10]} {read_num1[11]} {read_num1[12]} {read_num1[13]} {read_num1[14]} {read_num1[15]} {read_num1[16]} {read_num1[17]} {read_num1[18]} {read_num1[19]} {read_num1[20]} {read_num1[21]} {read_num1[22]} {read_num1[23]} {read_num1[24]} {read_num1[25]} {read_num1[26]} {read_num1[27]} {read_num1[28]} {read_num1[29]} {read_num1[30]} {read_num1[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {m1_axi_awlen[0]} {m1_axi_awlen[1]} {m1_axi_awlen[2]} {m1_axi_awlen[3]} {m1_axi_awlen[4]} {m1_axi_awlen[5]} {m1_axi_awlen[6]} {m1_axi_awlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {m1_axi_araddr[0]} {m1_axi_araddr[1]} {m1_axi_araddr[2]} {m1_axi_araddr[3]} {m1_axi_araddr[4]} {m1_axi_araddr[5]} {m1_axi_araddr[6]} {m1_axi_araddr[7]} {m1_axi_araddr[8]} {m1_axi_araddr[9]} {m1_axi_araddr[10]} {m1_axi_araddr[11]} {m1_axi_araddr[12]} {m1_axi_araddr[13]} {m1_axi_araddr[14]} {m1_axi_araddr[15]} {m1_axi_araddr[16]} {m1_axi_araddr[17]} {m1_axi_araddr[18]} {m1_axi_araddr[19]} {m1_axi_araddr[20]} {m1_axi_araddr[21]} {m1_axi_araddr[22]} {m1_axi_araddr[23]} {m1_axi_araddr[24]} {m1_axi_araddr[25]} {m1_axi_araddr[26]} {m1_axi_araddr[27]} {m1_axi_araddr[28]} {m1_axi_araddr[29]} {m1_axi_araddr[30]} {m1_axi_araddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {m1_axi_awaddr[0]} {m1_axi_awaddr[1]} {m1_axi_awaddr[2]} {m1_axi_awaddr[3]} {m1_axi_awaddr[4]} {m1_axi_awaddr[5]} {m1_axi_awaddr[6]} {m1_axi_awaddr[7]} {m1_axi_awaddr[8]} {m1_axi_awaddr[9]} {m1_axi_awaddr[10]} {m1_axi_awaddr[11]} {m1_axi_awaddr[12]} {m1_axi_awaddr[13]} {m1_axi_awaddr[14]} {m1_axi_awaddr[15]} {m1_axi_awaddr[16]} {m1_axi_awaddr[17]} {m1_axi_awaddr[18]} {m1_axi_awaddr[19]} {m1_axi_awaddr[20]} {m1_axi_awaddr[21]} {m1_axi_awaddr[22]} {m1_axi_awaddr[23]} {m1_axi_awaddr[24]} {m1_axi_awaddr[25]} {m1_axi_awaddr[26]} {m1_axi_awaddr[27]} {m1_axi_awaddr[28]} {m1_axi_awaddr[29]} {m1_axi_awaddr[30]} {m1_axi_awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {buf_dout1[0]} {buf_dout1[1]} {buf_dout1[2]} {buf_dout1[3]} {buf_dout1[4]} {buf_dout1[5]} {buf_dout1[6]} {buf_dout1[7]} {buf_dout1[8]} {buf_dout1[9]} {buf_dout1[10]} {buf_dout1[11]} {buf_dout1[12]} {buf_dout1[13]} {buf_dout1[14]} {buf_dout1[15]} {buf_dout1[16]} {buf_dout1[17]} {buf_dout1[18]} {buf_dout1[19]} {buf_dout1[20]} {buf_dout1[21]} {buf_dout1[22]} {buf_dout1[23]} {buf_dout1[24]} {buf_dout1[25]} {buf_dout1[26]} {buf_dout1[27]} {buf_dout1[28]} {buf_dout1[29]} {buf_dout1[30]} {buf_dout1[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 40 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {ctrl_in1[0]} {ctrl_in1[1]} {ctrl_in1[2]} {ctrl_in1[3]} {ctrl_in1[4]} {ctrl_in1[5]} {ctrl_in1[6]} {ctrl_in1[7]} {ctrl_in1[8]} {ctrl_in1[9]} {ctrl_in1[10]} {ctrl_in1[11]} {ctrl_in1[12]} {ctrl_in1[13]} {ctrl_in1[14]} {ctrl_in1[15]} {ctrl_in1[16]} {ctrl_in1[17]} {ctrl_in1[18]} {ctrl_in1[19]} {ctrl_in1[20]} {ctrl_in1[21]} {ctrl_in1[22]} {ctrl_in1[23]} {ctrl_in1[24]} {ctrl_in1[25]} {ctrl_in1[26]} {ctrl_in1[27]} {ctrl_in1[28]} {ctrl_in1[29]} {ctrl_in1[30]} {ctrl_in1[31]} {ctrl_in1[32]} {ctrl_in1[33]} {ctrl_in1[34]} {ctrl_in1[35]} {ctrl_in1[36]} {ctrl_in1[37]} {ctrl_in1[38]} {ctrl_in1[39]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 36 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {data_in1[0]} {data_in1[1]} {data_in1[2]} {data_in1[3]} {data_in1[4]} {data_in1[5]} {data_in1[6]} {data_in1[7]} {data_in1[8]} {data_in1[9]} {data_in1[10]} {data_in1[11]} {data_in1[12]} {data_in1[13]} {data_in1[14]} {data_in1[15]} {data_in1[16]} {data_in1[17]} {data_in1[18]} {data_in1[19]} {data_in1[20]} {data_in1[21]} {data_in1[22]} {data_in1[23]} {data_in1[24]} {data_in1[25]} {data_in1[26]} {data_in1[27]} {data_in1[28]} {data_in1[29]} {data_in1[30]} {data_in1[31]} {data_in1[32]} {data_in1[33]} {data_in1[34]} {data_in1[35]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {m1_axi_arlen[0]} {m1_axi_arlen[1]} {m1_axi_arlen[2]} {m1_axi_arlen[3]} {m1_axi_arlen[4]} {m1_axi_arlen[5]} {m1_axi_arlen[6]} {m1_axi_arlen[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {m1_axi_rdata[0]} {m1_axi_rdata[1]} {m1_axi_rdata[2]} {m1_axi_rdata[3]} {m1_axi_rdata[4]} {m1_axi_rdata[5]} {m1_axi_rdata[6]} {m1_axi_rdata[7]} {m1_axi_rdata[8]} {m1_axi_rdata[9]} {m1_axi_rdata[10]} {m1_axi_rdata[11]} {m1_axi_rdata[12]} {m1_axi_rdata[13]} {m1_axi_rdata[14]} {m1_axi_rdata[15]} {m1_axi_rdata[16]} {m1_axi_rdata[17]} {m1_axi_rdata[18]} {m1_axi_rdata[19]} {m1_axi_rdata[20]} {m1_axi_rdata[21]} {m1_axi_rdata[22]} {m1_axi_rdata[23]} {m1_axi_rdata[24]} {m1_axi_rdata[25]} {m1_axi_rdata[26]} {m1_axi_rdata[27]} {m1_axi_rdata[28]} {m1_axi_rdata[29]} {m1_axi_rdata[30]} {m1_axi_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {m1_axi_wdata[0]} {m1_axi_wdata[1]} {m1_axi_wdata[2]} {m1_axi_wdata[3]} {m1_axi_wdata[4]} {m1_axi_wdata[5]} {m1_axi_wdata[6]} {m1_axi_wdata[7]} {m1_axi_wdata[8]} {m1_axi_wdata[9]} {m1_axi_wdata[10]} {m1_axi_wdata[11]} {m1_axi_wdata[12]} {m1_axi_wdata[13]} {m1_axi_wdata[14]} {m1_axi_wdata[15]} {m1_axi_wdata[16]} {m1_axi_wdata[17]} {m1_axi_wdata[18]} {m1_axi_wdata[19]} {m1_axi_wdata[20]} {m1_axi_wdata[21]} {m1_axi_wdata[22]} {m1_axi_wdata[23]} {m1_axi_wdata[24]} {m1_axi_wdata[25]} {m1_axi_wdata[26]} {m1_axi_wdata[27]} {m1_axi_wdata[28]} {m1_axi_wdata[29]} {m1_axi_wdata[30]} {m1_axi_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {u_dram_copy/READFIFO_CNT[0]} {u_dram_copy/READFIFO_CNT[1]} {u_dram_copy/READFIFO_CNT[2]} {u_dram_copy/READFIFO_CNT[3]} {u_dram_copy/READFIFO_CNT[4]} {u_dram_copy/READFIFO_CNT[5]} {u_dram_copy/READFIFO_CNT[6]} {u_dram_copy/READFIFO_CNT[7]} {u_dram_copy/READFIFO_CNT[8]} {u_dram_copy/READFIFO_CNT[9]} {u_dram_copy/READFIFO_CNT[10]} {u_dram_copy/READFIFO_CNT[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 3 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {u_dram_copy/state_WRITE[0]} {u_dram_copy/state_WRITE[1]} {u_dram_copy/state_WRITE[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 12 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {u_dram_copy/WPOS_Y[0]} {u_dram_copy/WPOS_Y[1]} {u_dram_copy/WPOS_Y[2]} {u_dram_copy/WPOS_Y[3]} {u_dram_copy/WPOS_Y[4]} {u_dram_copy/WPOS_Y[5]} {u_dram_copy/WPOS_Y[6]} {u_dram_copy/WPOS_Y[7]} {u_dram_copy/WPOS_Y[8]} {u_dram_copy/WPOS_Y[9]} {u_dram_copy/WPOS_Y[10]} {u_dram_copy/WPOS_Y[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 12 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {u_dram_copy/RPOS_Y[0]} {u_dram_copy/RPOS_Y[1]} {u_dram_copy/RPOS_Y[2]} {u_dram_copy/RPOS_Y[3]} {u_dram_copy/RPOS_Y[4]} {u_dram_copy/RPOS_Y[5]} {u_dram_copy/RPOS_Y[6]} {u_dram_copy/RPOS_Y[7]} {u_dram_copy/RPOS_Y[8]} {u_dram_copy/RPOS_Y[9]} {u_dram_copy/RPOS_Y[10]} {u_dram_copy/RPOS_Y[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 12 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {u_dram_copy/RPOS_X[0]} {u_dram_copy/RPOS_X[1]} {u_dram_copy/RPOS_X[2]} {u_dram_copy/RPOS_X[3]} {u_dram_copy/RPOS_X[4]} {u_dram_copy/RPOS_X[5]} {u_dram_copy/RPOS_X[6]} {u_dram_copy/RPOS_X[7]} {u_dram_copy/RPOS_X[8]} {u_dram_copy/RPOS_X[9]} {u_dram_copy/RPOS_X[10]} {u_dram_copy/RPOS_X[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 3 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {u_dram_copy/state_READ[0]} {u_dram_copy/state_READ[1]} {u_dram_copy/state_READ[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 12 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {u_dram_copy/WPOS_X[0]} {u_dram_copy/WPOS_X[1]} {u_dram_copy/WPOS_X[2]} {u_dram_copy/WPOS_X[3]} {u_dram_copy/WPOS_X[4]} {u_dram_copy/WPOS_X[5]} {u_dram_copy/WPOS_X[6]} {u_dram_copy/WPOS_X[7]} {u_dram_copy/WPOS_X[8]} {u_dram_copy/WPOS_X[9]} {u_dram_copy/WPOS_X[10]} {u_dram_copy/WPOS_X[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list buf_we1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list busy1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list ctrl_we1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list data_we1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list kick1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list m1_axi_arready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list m1_axi_arvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list m1_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list m1_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list m1_axi_rlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list m1_axi_rready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list m1_axi_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list m1_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list m1_axi_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list u_dram_copy/WRITESTART]]
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
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {pUdp1Receive_Data[0]} {pUdp1Receive_Data[1]} {pUdp1Receive_Data[2]} {pUdp1Receive_Data[3]} {pUdp1Receive_Data[4]} {pUdp1Receive_Data[5]} {pUdp1Receive_Data[6]} {pUdp1Receive_Data[7]} {pUdp1Receive_Data[8]} {pUdp1Receive_Data[9]} {pUdp1Receive_Data[10]} {pUdp1Receive_Data[11]} {pUdp1Receive_Data[12]} {pUdp1Receive_Data[13]} {pUdp1Receive_Data[14]} {pUdp1Receive_Data[15]} {pUdp1Receive_Data[16]} {pUdp1Receive_Data[17]} {pUdp1Receive_Data[18]} {pUdp1Receive_Data[19]} {pUdp1Receive_Data[20]} {pUdp1Receive_Data[21]} {pUdp1Receive_Data[22]} {pUdp1Receive_Data[23]} {pUdp1Receive_Data[24]} {pUdp1Receive_Data[25]} {pUdp1Receive_Data[26]} {pUdp1Receive_Data[27]} {pUdp1Receive_Data[28]} {pUdp1Receive_Data[29]} {pUdp1Receive_Data[30]} {pUdp1Receive_Data[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list capture_done]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 1 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list capture_rtn]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list capture_sig]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list pUdp1Receive_Ack]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list pUdp1Receive_Enable]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 1 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list pUdp1Receive_Request]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets CLK125M]
