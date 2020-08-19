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










connect_debug_port u_ila_0/probe0 [get_nets [list {udp_axi/buf_dout[0]} {udp_axi/buf_dout[1]} {udp_axi/buf_dout[2]} {udp_axi/buf_dout[3]} {udp_axi/buf_dout[4]} {udp_axi/buf_dout[5]} {udp_axi/buf_dout[6]} {udp_axi/buf_dout[7]} {udp_axi/buf_dout[8]} {udp_axi/buf_dout[9]} {udp_axi/buf_dout[10]} {udp_axi/buf_dout[11]} {udp_axi/buf_dout[12]} {udp_axi/buf_dout[13]} {udp_axi/buf_dout[14]} {udp_axi/buf_dout[15]} {udp_axi/buf_dout[16]} {udp_axi/buf_dout[17]} {udp_axi/buf_dout[18]} {udp_axi/buf_dout[19]} {udp_axi/buf_dout[20]} {udp_axi/buf_dout[21]} {udp_axi/buf_dout[22]} {udp_axi/buf_dout[23]} {udp_axi/buf_dout[24]} {udp_axi/buf_dout[25]} {udp_axi/buf_dout[26]} {udp_axi/buf_dout[27]} {udp_axi/buf_dout[28]} {udp_axi/buf_dout[29]} {udp_axi/buf_dout[30]} {udp_axi/buf_dout[31]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list udp_axi/buf_we]]
connect_debug_port u_ila_0/probe2 [get_nets [list udp_axi/busy]]
connect_debug_port u_ila_0/probe3 [get_nets [list udp_axi/fifo_full]]
connect_debug_port u_ila_1/probe0 [get_nets [list {udp_axi/read_addr[0]} {udp_axi/read_addr[1]} {udp_axi/read_addr[2]} {udp_axi/read_addr[3]} {udp_axi/read_addr[4]} {udp_axi/read_addr[5]} {udp_axi/read_addr[6]} {udp_axi/read_addr[7]} {udp_axi/read_addr[8]} {udp_axi/read_addr[9]} {udp_axi/read_addr[10]} {udp_axi/read_addr[11]} {udp_axi/read_addr[12]} {udp_axi/read_addr[13]} {udp_axi/read_addr[14]} {udp_axi/read_addr[15]} {udp_axi/read_addr[16]} {udp_axi/read_addr[17]} {udp_axi/read_addr[18]} {udp_axi/read_addr[19]} {udp_axi/read_addr[20]} {udp_axi/read_addr[21]} {udp_axi/read_addr[22]} {udp_axi/read_addr[23]} {udp_axi/read_addr[24]} {udp_axi/read_addr[25]} {udp_axi/read_addr[26]} {udp_axi/read_addr[27]} {udp_axi/read_addr[28]} {udp_axi/read_addr[29]} {udp_axi/read_addr[30]} {udp_axi/read_addr[31]}]]
connect_debug_port u_ila_1/probe1 [get_nets [list {udp_axi/fifo_cnt[0]} {udp_axi/fifo_cnt[1]} {udp_axi/fifo_cnt[2]} {udp_axi/fifo_cnt[3]} {udp_axi/fifo_cnt[4]} {udp_axi/fifo_cnt[5]} {udp_axi/fifo_cnt[6]} {udp_axi/fifo_cnt[7]} {udp_axi/fifo_cnt[8]} {udp_axi/fifo_cnt[9]} {udp_axi/fifo_cnt[10]}]]
connect_debug_port u_ila_1/probe2 [get_nets [list {udp_axi/state_udp[0]} {udp_axi/state_udp[1]} {udp_axi/state_udp[2]} {udp_axi/state_udp[3]}]]
connect_debug_port u_ila_1/probe3 [get_nets [list {udp_axi/offset[0]} {udp_axi/offset[1]} {udp_axi/offset[2]} {udp_axi/offset[3]} {udp_axi/offset[4]} {udp_axi/offset[5]} {udp_axi/offset[6]} {udp_axi/offset[7]} {udp_axi/offset[8]} {udp_axi/offset[9]} {udp_axi/offset[10]} {udp_axi/offset[11]} {udp_axi/offset[12]} {udp_axi/offset[13]} {udp_axi/offset[14]} {udp_axi/offset[15]} {udp_axi/offset[16]} {udp_axi/offset[17]} {udp_axi/offset[18]} {udp_axi/offset[19]} {udp_axi/offset[20]} {udp_axi/offset[21]} {udp_axi/offset[22]} {udp_axi/offset[23]} {udp_axi/offset[24]} {udp_axi/offset[25]} {udp_axi/offset[26]} {udp_axi/offset[27]} {udp_axi/offset[28]} {udp_axi/offset[29]} {udp_axi/offset[30]} {udp_axi/offset[31]}]]
connect_debug_port u_ila_1/probe4 [get_nets [list {udp_axi/w_data[0]} {udp_axi/w_data[1]} {udp_axi/w_data[2]} {udp_axi/w_data[3]} {udp_axi/w_data[4]} {udp_axi/w_data[5]} {udp_axi/w_data[6]} {udp_axi/w_data[7]} {udp_axi/w_data[8]} {udp_axi/w_data[9]} {udp_axi/w_data[10]} {udp_axi/w_data[11]} {udp_axi/w_data[12]} {udp_axi/w_data[13]} {udp_axi/w_data[14]} {udp_axi/w_data[15]} {udp_axi/w_data[16]} {udp_axi/w_data[17]} {udp_axi/w_data[18]} {udp_axi/w_data[19]} {udp_axi/w_data[20]} {udp_axi/w_data[21]} {udp_axi/w_data[22]} {udp_axi/w_data[23]} {udp_axi/w_data[24]} {udp_axi/w_data[25]} {udp_axi/w_data[26]} {udp_axi/w_data[27]} {udp_axi/w_data[28]} {udp_axi/w_data[29]} {udp_axi/w_data[30]} {udp_axi/w_data[31]}]]
connect_debug_port u_ila_1/probe5 [get_nets [list {udp_axi/fifo_offset_cnt[0]} {udp_axi/fifo_offset_cnt[1]} {udp_axi/fifo_offset_cnt[2]} {udp_axi/fifo_offset_cnt[3]} {udp_axi/fifo_offset_cnt[4]} {udp_axi/fifo_offset_cnt[5]} {udp_axi/fifo_offset_cnt[6]} {udp_axi/fifo_offset_cnt[7]}]]
connect_debug_port u_ila_1/probe6 [get_nets [list {udp_axi/offset_read[0]} {udp_axi/offset_read[1]} {udp_axi/offset_read[2]} {udp_axi/offset_read[3]} {udp_axi/offset_read[4]} {udp_axi/offset_read[5]} {udp_axi/offset_read[6]} {udp_axi/offset_read[7]} {udp_axi/offset_read[8]} {udp_axi/offset_read[9]} {udp_axi/offset_read[10]} {udp_axi/offset_read[11]} {udp_axi/offset_read[12]} {udp_axi/offset_read[13]} {udp_axi/offset_read[14]} {udp_axi/offset_read[15]} {udp_axi/offset_read[16]} {udp_axi/offset_read[17]} {udp_axi/offset_read[18]} {udp_axi/offset_read[19]} {udp_axi/offset_read[20]} {udp_axi/offset_read[21]} {udp_axi/offset_read[22]} {udp_axi/offset_read[23]} {udp_axi/offset_read[24]} {udp_axi/offset_read[25]} {udp_axi/offset_read[26]} {udp_axi/offset_read[27]} {udp_axi/offset_read[28]} {udp_axi/offset_read[29]} {udp_axi/offset_read[30]} {udp_axi/offset_read[31]}]]
connect_debug_port u_ila_1/probe7 [get_nets [list {udp_axi/state_axi[0]} {udp_axi/state_axi[1]} {udp_axi/state_axi[2]}]]
connect_debug_port u_ila_1/probe8 [get_nets [list {udp_axi/read_num[0]} {udp_axi/read_num[1]} {udp_axi/read_num[2]} {udp_axi/read_num[3]} {udp_axi/read_num[4]} {udp_axi/read_num[5]} {udp_axi/read_num[6]} {udp_axi/read_num[7]} {udp_axi/read_num[8]} {udp_axi/read_num[9]} {udp_axi/read_num[10]} {udp_axi/read_num[11]} {udp_axi/read_num[12]} {udp_axi/read_num[13]} {udp_axi/read_num[14]} {udp_axi/read_num[15]} {udp_axi/read_num[16]} {udp_axi/read_num[17]} {udp_axi/read_num[18]} {udp_axi/read_num[19]} {udp_axi/read_num[20]} {udp_axi/read_num[21]} {udp_axi/read_num[22]} {udp_axi/read_num[23]} {udp_axi/read_num[24]} {udp_axi/read_num[25]} {udp_axi/read_num[26]} {udp_axi/read_num[27]} {udp_axi/read_num[28]} {udp_axi/read_num[29]} {udp_axi/read_num[30]} {udp_axi/read_num[31]}]]
connect_debug_port u_ila_1/probe9 [get_nets [list udp_axi/kick]]
connect_debug_port u_ila_1/probe10 [get_nets [list udp_axi/test_rden]]
connect_debug_port u_ila_1/probe11 [get_nets [list udp_axi/test_wren]]
connect_debug_port u_ila_1/probe12 [get_nets [list udp_axi/w_ack]]
connect_debug_port u_ila_1/probe13 [get_nets [list udp_axi/w_enable]]
connect_debug_port u_ila_1/probe14 [get_nets [list udp_axi/w_req]]





connect_debug_port u_ila_0/probe0 [get_nets [list {u_udp_send/u_dram2rgb/addr[30]} {u_udp_send/u_dram2rgb/addr[31]}]]



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
connect_debug_port u_ila_0/clk [get_nets [list u_clk_wiz_1/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_udp_send/u_dram2rgb/offset[0]} {u_udp_send/u_dram2rgb/offset[1]} {u_udp_send/u_dram2rgb/offset[2]} {u_udp_send/u_dram2rgb/offset[3]} {u_udp_send/u_dram2rgb/offset[4]} {u_udp_send/u_dram2rgb/offset[5]} {u_udp_send/u_dram2rgb/offset[6]} {u_udp_send/u_dram2rgb/offset[7]} {u_udp_send/u_dram2rgb/offset[8]} {u_udp_send/u_dram2rgb/offset[9]} {u_udp_send/u_dram2rgb/offset[10]} {u_udp_send/u_dram2rgb/offset[11]} {u_udp_send/u_dram2rgb/offset[12]} {u_udp_send/u_dram2rgb/offset[13]} {u_udp_send/u_dram2rgb/offset[14]} {u_udp_send/u_dram2rgb/offset[15]} {u_udp_send/u_dram2rgb/offset[16]} {u_udp_send/u_dram2rgb/offset[17]} {u_udp_send/u_dram2rgb/offset[18]} {u_udp_send/u_dram2rgb/offset[19]} {u_udp_send/u_dram2rgb/offset[20]} {u_udp_send/u_dram2rgb/offset[21]} {u_udp_send/u_dram2rgb/offset[22]} {u_udp_send/u_dram2rgb/offset[23]} {u_udp_send/u_dram2rgb/offset[24]} {u_udp_send/u_dram2rgb/offset[25]} {u_udp_send/u_dram2rgb/offset[26]} {u_udp_send/u_dram2rgb/offset[27]} {u_udp_send/u_dram2rgb/offset[28]} {u_udp_send/u_dram2rgb/offset[29]} {u_udp_send/u_dram2rgb/offset[30]} {u_udp_send/u_dram2rgb/offset[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_udp_send/u_dram2rgb/busy_clk[0]} {u_udp_send/u_dram2rgb/busy_clk[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 6 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_udp_send/u_dram2rgb/addr_cnt[0]} {u_udp_send/u_dram2rgb/addr_cnt[1]} {u_udp_send/u_dram2rgb/addr_cnt[2]} {u_udp_send/u_dram2rgb/addr_cnt[3]} {u_udp_send/u_dram2rgb/addr_cnt[4]} {u_udp_send/u_dram2rgb/addr_cnt[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_udp_send/u_dram2rgb/read_addr[0]} {u_udp_send/u_dram2rgb/read_addr[1]} {u_udp_send/u_dram2rgb/read_addr[2]} {u_udp_send/u_dram2rgb/read_addr[3]} {u_udp_send/u_dram2rgb/read_addr[4]} {u_udp_send/u_dram2rgb/read_addr[5]} {u_udp_send/u_dram2rgb/read_addr[6]} {u_udp_send/u_dram2rgb/read_addr[7]} {u_udp_send/u_dram2rgb/read_addr[8]} {u_udp_send/u_dram2rgb/read_addr[9]} {u_udp_send/u_dram2rgb/read_addr[10]} {u_udp_send/u_dram2rgb/read_addr[11]} {u_udp_send/u_dram2rgb/read_addr[12]} {u_udp_send/u_dram2rgb/read_addr[13]} {u_udp_send/u_dram2rgb/read_addr[14]} {u_udp_send/u_dram2rgb/read_addr[15]} {u_udp_send/u_dram2rgb/read_addr[16]} {u_udp_send/u_dram2rgb/read_addr[17]} {u_udp_send/u_dram2rgb/read_addr[18]} {u_udp_send/u_dram2rgb/read_addr[19]} {u_udp_send/u_dram2rgb/read_addr[20]} {u_udp_send/u_dram2rgb/read_addr[21]} {u_udp_send/u_dram2rgb/read_addr[22]} {u_udp_send/u_dram2rgb/read_addr[23]} {u_udp_send/u_dram2rgb/read_addr[24]} {u_udp_send/u_dram2rgb/read_addr[25]} {u_udp_send/u_dram2rgb/read_addr[26]} {u_udp_send/u_dram2rgb/read_addr[27]} {u_udp_send/u_dram2rgb/read_addr[28]} {u_udp_send/u_dram2rgb/read_addr[29]} {u_udp_send/u_dram2rgb/read_addr[30]} {u_udp_send/u_dram2rgb/read_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_udp_send/u_dram2rgb/read_num[0]} {u_udp_send/u_dram2rgb/read_num[1]} {u_udp_send/u_dram2rgb/read_num[2]} {u_udp_send/u_dram2rgb/read_num[3]} {u_udp_send/u_dram2rgb/read_num[4]} {u_udp_send/u_dram2rgb/read_num[5]} {u_udp_send/u_dram2rgb/read_num[6]} {u_udp_send/u_dram2rgb/read_num[7]} {u_udp_send/u_dram2rgb/read_num[8]} {u_udp_send/u_dram2rgb/read_num[9]} {u_udp_send/u_dram2rgb/read_num[10]} {u_udp_send/u_dram2rgb/read_num[11]} {u_udp_send/u_dram2rgb/read_num[12]} {u_udp_send/u_dram2rgb/read_num[13]} {u_udp_send/u_dram2rgb/read_num[14]} {u_udp_send/u_dram2rgb/read_num[15]} {u_udp_send/u_dram2rgb/read_num[16]} {u_udp_send/u_dram2rgb/read_num[17]} {u_udp_send/u_dram2rgb/read_num[18]} {u_udp_send/u_dram2rgb/read_num[19]} {u_udp_send/u_dram2rgb/read_num[20]} {u_udp_send/u_dram2rgb/read_num[21]} {u_udp_send/u_dram2rgb/read_num[22]} {u_udp_send/u_dram2rgb/read_num[23]} {u_udp_send/u_dram2rgb/read_num[24]} {u_udp_send/u_dram2rgb/read_num[25]} {u_udp_send/u_dram2rgb/read_num[26]} {u_udp_send/u_dram2rgb/read_num[27]} {u_udp_send/u_dram2rgb/read_num[28]} {u_udp_send/u_dram2rgb/read_num[29]} {u_udp_send/u_dram2rgb/read_num[30]} {u_udp_send/u_dram2rgb/read_num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_udp_send/u_dram2rgb/state[0]} {u_udp_send/u_dram2rgb/state[1]} {u_udp_send/u_dram2rgb/state[2]} {u_udp_send/u_dram2rgb/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {u_udp_send/state[0]} {u_udp_send/state[1]} {u_udp_send/state[2]} {u_udp_send/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 11 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {u_udp_send/u_dram2rgb/rgb_cnt[0]} {u_udp_send/u_dram2rgb/rgb_cnt[1]} {u_udp_send/u_dram2rgb/rgb_cnt[2]} {u_udp_send/u_dram2rgb/rgb_cnt[3]} {u_udp_send/u_dram2rgb/rgb_cnt[4]} {u_udp_send/u_dram2rgb/rgb_cnt[5]} {u_udp_send/u_dram2rgb/rgb_cnt[6]} {u_udp_send/u_dram2rgb/rgb_cnt[7]} {u_udp_send/u_dram2rgb/rgb_cnt[8]} {u_udp_send/u_dram2rgb/rgb_cnt[9]} {u_udp_send/u_dram2rgb/rgb_cnt[10]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {u_udp_send/w_data[0]} {u_udp_send/w_data[1]} {u_udp_send/w_data[2]} {u_udp_send/w_data[3]} {u_udp_send/w_data[4]} {u_udp_send/w_data[5]} {u_udp_send/w_data[6]} {u_udp_send/w_data[7]} {u_udp_send/w_data[8]} {u_udp_send/w_data[9]} {u_udp_send/w_data[10]} {u_udp_send/w_data[11]} {u_udp_send/w_data[12]} {u_udp_send/w_data[13]} {u_udp_send/w_data[14]} {u_udp_send/w_data[15]} {u_udp_send/w_data[16]} {u_udp_send/w_data[17]} {u_udp_send/w_data[18]} {u_udp_send/w_data[19]} {u_udp_send/w_data[20]} {u_udp_send/w_data[21]} {u_udp_send/w_data[22]} {u_udp_send/w_data[23]} {u_udp_send/w_data[24]} {u_udp_send/w_data[25]} {u_udp_send/w_data[26]} {u_udp_send/w_data[27]} {u_udp_send/w_data[28]} {u_udp_send/w_data[29]} {u_udp_send/w_data[30]} {u_udp_send/w_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list u_udp_send/u_dram2rgb/addr_rd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list u_udp_send/u_dram2rgb/busy_clk_sig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list u_udp_send/dram2rgb_rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list u_udp_send/u_dram2rgb/kick]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list u_udp_send/u_dram2rgb/rgb_rd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list u_udp_send/u_dram2rgb/rgb_rd_busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list u_udp_send/rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list u_udp_send/w_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list u_udp_send/w_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list u_udp_send/w_req]]
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
connect_debug_port u_ila_1/clk [get_nets [list u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {u_udp_send/u_dram2rgb/buf_dout[0]} {u_udp_send/u_dram2rgb/buf_dout[1]} {u_udp_send/u_dram2rgb/buf_dout[2]} {u_udp_send/u_dram2rgb/buf_dout[3]} {u_udp_send/u_dram2rgb/buf_dout[4]} {u_udp_send/u_dram2rgb/buf_dout[5]} {u_udp_send/u_dram2rgb/buf_dout[6]} {u_udp_send/u_dram2rgb/buf_dout[7]} {u_udp_send/u_dram2rgb/buf_dout[8]} {u_udp_send/u_dram2rgb/buf_dout[9]} {u_udp_send/u_dram2rgb/buf_dout[10]} {u_udp_send/u_dram2rgb/buf_dout[11]} {u_udp_send/u_dram2rgb/buf_dout[12]} {u_udp_send/u_dram2rgb/buf_dout[13]} {u_udp_send/u_dram2rgb/buf_dout[14]} {u_udp_send/u_dram2rgb/buf_dout[15]} {u_udp_send/u_dram2rgb/buf_dout[16]} {u_udp_send/u_dram2rgb/buf_dout[17]} {u_udp_send/u_dram2rgb/buf_dout[18]} {u_udp_send/u_dram2rgb/buf_dout[19]} {u_udp_send/u_dram2rgb/buf_dout[20]} {u_udp_send/u_dram2rgb/buf_dout[21]} {u_udp_send/u_dram2rgb/buf_dout[22]} {u_udp_send/u_dram2rgb/buf_dout[23]} {u_udp_send/u_dram2rgb/buf_dout[24]} {u_udp_send/u_dram2rgb/buf_dout[25]} {u_udp_send/u_dram2rgb/buf_dout[26]} {u_udp_send/u_dram2rgb/buf_dout[27]} {u_udp_send/u_dram2rgb/buf_dout[28]} {u_udp_send/u_dram2rgb/buf_dout[29]} {u_udp_send/u_dram2rgb/buf_dout[30]} {u_udp_send/u_dram2rgb/buf_dout[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 8 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {u_udp_send/u_dram2rgb/buf_cnt[0]} {u_udp_send/u_dram2rgb/buf_cnt[1]} {u_udp_send/u_dram2rgb/buf_cnt[2]} {u_udp_send/u_dram2rgb/buf_cnt[3]} {u_udp_send/u_dram2rgb/buf_cnt[4]} {u_udp_send/u_dram2rgb/buf_cnt[5]} {u_udp_send/u_dram2rgb/buf_cnt[6]} {u_udp_send/u_dram2rgb/buf_cnt[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 1 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list u_udp_send/u_dram2rgb/buf_we]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list u_udp_send/u_dram2rgb/busy]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list u_udp_send/u_dram2rgb/rgb_full]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list u_udp_send/u_dram2rgb/rgb_wr_busy]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list U_DVI2RGB/GenerateBUFG.ResyncToBUFG_X/CLK]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 40 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list {ctrl_in0[0]} {ctrl_in0[1]} {ctrl_in0[2]} {ctrl_in0[3]} {ctrl_in0[4]} {ctrl_in0[5]} {ctrl_in0[6]} {ctrl_in0[7]} {ctrl_in0[8]} {ctrl_in0[9]} {ctrl_in0[10]} {ctrl_in0[11]} {ctrl_in0[12]} {ctrl_in0[13]} {ctrl_in0[14]} {ctrl_in0[15]} {ctrl_in0[16]} {ctrl_in0[17]} {ctrl_in0[18]} {ctrl_in0[19]} {ctrl_in0[20]} {ctrl_in0[21]} {ctrl_in0[22]} {ctrl_in0[23]} {ctrl_in0[24]} {ctrl_in0[25]} {ctrl_in0[26]} {ctrl_in0[27]} {ctrl_in0[28]} {ctrl_in0[29]} {ctrl_in0[30]} {ctrl_in0[31]} {ctrl_in0[32]} {ctrl_in0[33]} {ctrl_in0[34]} {ctrl_in0[35]} {ctrl_in0[36]} {ctrl_in0[37]} {ctrl_in0[38]} {ctrl_in0[39]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe1]
set_property port_width 1 [get_debug_ports u_ila_2/probe1]
connect_debug_port u_ila_2/probe1 [get_nets [list ctrl_we0]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets CLK125M]
