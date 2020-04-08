# 200MHz
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVDS_25} [get_ports SYS_CLK_P]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVDS_25} [get_ports SYS_CLK_N]
create_clock -period 5.000 -name clk_pin -waveform {0.000 2.500} -add [get_ports SYS_CLK_P]

# PUSH BUBTTON
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports sys_rst]

# HDMI CN2
set_property -dict {PACKAGE_PIN V20 IOSTANDARD TMDS_33}  [get_ports TMDS_RX_Clk_n]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD TMDS_33}  [get_ports TMDS_RX_Clk_p]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD TMDS_33}  [get_ports {TMDS_RX_Data_n[0]}]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD TMDS_33}  [get_ports {TMDS_RX_Data_p[0]}]
set_property -dict {PACKAGE_PIN U21 IOSTANDARD TMDS_33}  [get_ports {TMDS_RX_Data_n[1]}]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD TMDS_33}  [get_ports {TMDS_RX_Data_p[1]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD TMDS_33}  [get_ports {TMDS_RX_Data_n[2]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD TMDS_33}  [get_ports {TMDS_RX_Data_p[2]}]
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_SCL]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_SDA]
set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports TMDS_RX_OUT_EN]
set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33 PULLUP true} [get_ports TMDS_RX_HPD]

# HDMI CN3
set_property -dict {PACKAGE_PIN W20  IOSTANDARD TMDS_33}  [get_ports TMDS_TX_Clk_n]
set_property -dict {PACKAGE_PIN W19  IOSTANDARD TMDS_33}  [get_ports TMDS_TX_Clk_p]
set_property -dict {PACKAGE_PIN Y19  IOSTANDARD TMDS_33}  [get_ports {TMDS_TX_Data_n[0]}]
set_property -dict {PACKAGE_PIN Y18  IOSTANDARD TMDS_33}  [get_ports {TMDS_TX_Data_p[0]}]
set_property -dict {PACKAGE_PIN V19  IOSTANDARD TMDS_33}  [get_ports {TMDS_TX_Data_n[1]}]
set_property -dict {PACKAGE_PIN V18  IOSTANDARD TMDS_33}  [get_ports {TMDS_TX_Data_p[1]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD TMDS_33}  [get_ports {TMDS_TX_Data_n[2]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD TMDS_33}  [get_ports {TMDS_TX_Data_p[2]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_SCL]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports TMDS_TX_SDA]
set_property -dict {PACKAGE_PIN D22  IOSTANDARD LVCMOS33} [get_ports TMDS_TX_OUT_EN]
set_property -dict {PACKAGE_PIN E22  IOSTANDARD LVCMOS33 PULLUP true} [get_ports TMDS_TX_HPD]

# 74.25MHz
#create_clock -period 13.468 -waveform {0.000 6.734} [get_ports TMDS_RX_Clk_p]

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
create_clock -period 8.000 -name rgmii_rxclk -waveform {0.000 4.000} [get_ports {GEPHY_RCK}]

## set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]


set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]
set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT0]]

set_false_path -from [get_clocks rgmii_rxclk] -to [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]]
set_false_path -from [get_clocks -of_objects [get_pins u_clk_wiz_1/inst/mmcm_adv_inst/CLKOUT1]] -to [get_clocks rgmii_rxclk]

set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_memc_ui_top_std/mem_intfc0/ddr_phy_top0/u_ddr_mc_phy_wrapper/u_ddr_mc_phy/ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in/ICLK]]
set_false_path -from [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_memc_ui_top_std/mem_intfc0/ddr_phy_top0/u_ddr_mc_phy_wrapper/u_ddr_mc_phy/ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in/ICLK]] -to [get_clocks -of_objects [get_pins u_mig_7series_0/u_mig_7series_0_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i/CLKFBOUT]]
