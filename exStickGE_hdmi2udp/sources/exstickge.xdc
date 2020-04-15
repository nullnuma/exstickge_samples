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
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_clk_wiz_1/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {rgb2udp_inst/header_cnt[0]} {rgb2udp_inst/header_cnt[1]} {rgb2udp_inst/header_cnt[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {rgb2udp_inst/store_cnt[0]} {rgb2udp_inst/store_cnt[1]} {rgb2udp_inst/store_cnt[2]} {rgb2udp_inst/store_cnt[3]} {rgb2udp_inst/store_cnt[4]} {rgb2udp_inst/store_cnt[5]} {rgb2udp_inst/store_cnt[6]} {rgb2udp_inst/store_cnt[7]} {rgb2udp_inst/store_cnt[8]} {rgb2udp_inst/store_cnt[9]} {rgb2udp_inst/store_cnt[10]} {rgb2udp_inst/store_cnt[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 24 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {rgb2udp_inst/rgb_data_o[0]} {rgb2udp_inst/rgb_data_o[1]} {rgb2udp_inst/rgb_data_o[2]} {rgb2udp_inst/rgb_data_o[3]} {rgb2udp_inst/rgb_data_o[4]} {rgb2udp_inst/rgb_data_o[5]} {rgb2udp_inst/rgb_data_o[6]} {rgb2udp_inst/rgb_data_o[7]} {rgb2udp_inst/rgb_data_o[8]} {rgb2udp_inst/rgb_data_o[9]} {rgb2udp_inst/rgb_data_o[10]} {rgb2udp_inst/rgb_data_o[11]} {rgb2udp_inst/rgb_data_o[12]} {rgb2udp_inst/rgb_data_o[13]} {rgb2udp_inst/rgb_data_o[14]} {rgb2udp_inst/rgb_data_o[15]} {rgb2udp_inst/rgb_data_o[16]} {rgb2udp_inst/rgb_data_o[17]} {rgb2udp_inst/rgb_data_o[18]} {rgb2udp_inst/rgb_data_o[19]} {rgb2udp_inst/rgb_data_o[20]} {rgb2udp_inst/rgb_data_o[21]} {rgb2udp_inst/rgb_data_o[22]} {rgb2udp_inst/rgb_data_o[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {rgb2udp_inst/w_data[0]} {rgb2udp_inst/w_data[1]} {rgb2udp_inst/w_data[2]} {rgb2udp_inst/w_data[3]} {rgb2udp_inst/w_data[4]} {rgb2udp_inst/w_data[5]} {rgb2udp_inst/w_data[6]} {rgb2udp_inst/w_data[7]} {rgb2udp_inst/w_data[8]} {rgb2udp_inst/w_data[9]} {rgb2udp_inst/w_data[10]} {rgb2udp_inst/w_data[11]} {rgb2udp_inst/w_data[12]} {rgb2udp_inst/w_data[13]} {rgb2udp_inst/w_data[14]} {rgb2udp_inst/w_data[15]} {rgb2udp_inst/w_data[16]} {rgb2udp_inst/w_data[17]} {rgb2udp_inst/w_data[18]} {rgb2udp_inst/w_data[19]} {rgb2udp_inst/w_data[20]} {rgb2udp_inst/w_data[21]} {rgb2udp_inst/w_data[22]} {rgb2udp_inst/w_data[23]} {rgb2udp_inst/w_data[24]} {rgb2udp_inst/w_data[25]} {rgb2udp_inst/w_data[26]} {rgb2udp_inst/w_data[27]} {rgb2udp_inst/w_data[28]} {rgb2udp_inst/w_data[29]} {rgb2udp_inst/w_data[30]} {rgb2udp_inst/w_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {rgb2udp_inst/data_cnt[0]} {rgb2udp_inst/data_cnt[1]} {rgb2udp_inst/data_cnt[2]} {rgb2udp_inst/data_cnt[3]} {rgb2udp_inst/data_cnt[4]} {rgb2udp_inst/data_cnt[5]} {rgb2udp_inst/data_cnt[6]} {rgb2udp_inst/data_cnt[7]} {rgb2udp_inst/data_cnt[8]} {rgb2udp_inst/data_cnt[9]} {rgb2udp_inst/data_cnt[10]} {rgb2udp_inst/data_cnt[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {pUdp1Receive_Data[0]} {pUdp1Receive_Data[1]} {pUdp1Receive_Data[2]} {pUdp1Receive_Data[3]} {pUdp1Receive_Data[4]} {pUdp1Receive_Data[5]} {pUdp1Receive_Data[6]} {pUdp1Receive_Data[7]} {pUdp1Receive_Data[8]} {pUdp1Receive_Data[9]} {pUdp1Receive_Data[10]} {pUdp1Receive_Data[11]} {pUdp1Receive_Data[12]} {pUdp1Receive_Data[13]} {pUdp1Receive_Data[14]} {pUdp1Receive_Data[15]} {pUdp1Receive_Data[16]} {pUdp1Receive_Data[17]} {pUdp1Receive_Data[18]} {pUdp1Receive_Data[19]} {pUdp1Receive_Data[20]} {pUdp1Receive_Data[21]} {pUdp1Receive_Data[22]} {pUdp1Receive_Data[23]} {pUdp1Receive_Data[24]} {pUdp1Receive_Data[25]} {pUdp1Receive_Data[26]} {pUdp1Receive_Data[27]} {pUdp1Receive_Data[28]} {pUdp1Receive_Data[29]} {pUdp1Receive_Data[30]} {pUdp1Receive_Data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 2 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {rgb2udp_inst/state[0]} {rgb2udp_inst/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list pUdp1Receive_Ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list pUdp1Receive_Enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list pUdp1Receive_Request]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list rgb2udp_inst/rd_en_fifo]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list rgb2udp_inst/w_ack]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list rgb2udp_inst/w_enable]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list rgb2udp_inst/w_req]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list U_DVI2RGB/GenerateBUFG.ResyncToBUFG_X/PixelClk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 24 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {dvi2rgb_data[0]} {dvi2rgb_data[1]} {dvi2rgb_data[2]} {dvi2rgb_data[3]} {dvi2rgb_data[4]} {dvi2rgb_data[5]} {dvi2rgb_data[6]} {dvi2rgb_data[7]} {dvi2rgb_data[8]} {dvi2rgb_data[9]} {dvi2rgb_data[10]} {dvi2rgb_data[11]} {dvi2rgb_data[12]} {dvi2rgb_data[13]} {dvi2rgb_data[14]} {dvi2rgb_data[15]} {dvi2rgb_data[16]} {dvi2rgb_data[17]} {dvi2rgb_data[18]} {dvi2rgb_data[19]} {dvi2rgb_data[20]} {dvi2rgb_data[21]} {dvi2rgb_data[22]} {dvi2rgb_data[23]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 12 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {rgb2udp_inst/h_cnt[0]} {rgb2udp_inst/h_cnt[1]} {rgb2udp_inst/h_cnt[2]} {rgb2udp_inst/h_cnt[3]} {rgb2udp_inst/h_cnt[4]} {rgb2udp_inst/h_cnt[5]} {rgb2udp_inst/h_cnt[6]} {rgb2udp_inst/h_cnt[7]} {rgb2udp_inst/h_cnt[8]} {rgb2udp_inst/h_cnt[9]} {rgb2udp_inst/h_cnt[10]} {rgb2udp_inst/h_cnt[11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 12 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {rgb2udp_inst/v_cnt[0]} {rgb2udp_inst/v_cnt[1]} {rgb2udp_inst/v_cnt[2]} {rgb2udp_inst/v_cnt[3]} {rgb2udp_inst/v_cnt[4]} {rgb2udp_inst/v_cnt[5]} {rgb2udp_inst/v_cnt[6]} {rgb2udp_inst/v_cnt[7]} {rgb2udp_inst/v_cnt[8]} {rgb2udp_inst/v_cnt[9]} {rgb2udp_inst/v_cnt[10]} {rgb2udp_inst/v_cnt[11]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list dvi2rgb_de]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list dvi2rgb_hsync]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list dvi2rgb_vsync]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets rgb2dvi_pixel_clk]
