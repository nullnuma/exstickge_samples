set_property PACKAGE_PIN D20 [get_ports {GPIO_Out4_tri_o[0]}]
set_property PACKAGE_PIN C22 [get_ports {GPIO_Out4_tri_o[1]}]
set_property PACKAGE_PIN G17 [get_ports {GPIO_Out4_tri_o[2]}]
set_property PACKAGE_PIN H17 [get_ports {GPIO_Out4_tri_o[3]}]
set_property PACKAGE_PIN B22 [get_ports {GPIO_In4_tri_i[0]}]
set_property PACKAGE_PIN C20 [get_ports {GPIO_In4_tri_i[1]}]
set_property PACKAGE_PIN G18 [get_ports {GPIO_In4_tri_i[2]}]
set_property PACKAGE_PIN H18 [get_ports {GPIO_In4_tri_i[3]}]
set_property PACKAGE_PIN T18 [get_ports UART_rxd]
set_property PACKAGE_PIN R18 [get_ports UART_txd]
set_property PACKAGE_PIN H4 [get_ports CLK200M_clk_p]
set_property PACKAGE_PIN D19 [get_ports RESET]

set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_Out4_tri_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_Out4_tri_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_Out4_tri_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_Out4_tri_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_In4_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_In4_tri_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_In4_tri_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_In4_tri_i[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports UART_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_txd]
set_property IOSTANDARD LVDS_25 [get_ports CLK200M_clk_p]
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

//MDIO
set_property PACKAGE_PIN AA10 [get_ports MDIO_mdc]
set_property PACKAGE_PIN AB10 [get_ports MDIO_mdio_io]
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_mdio_io]
//RGMII
set_property PACKAGE_PIN AA15 [get_ports {RGMII_rd[0]}]
set_property PACKAGE_PIN AB15 [get_ports {RGMII_rd[1]}]
set_property PACKAGE_PIN Y13 [get_ports {RGMII_rd[2]}]
set_property PACKAGE_PIN AA14 [get_ports {RGMII_rd[3]}]
set_property PACKAGE_PIN AA9 [get_ports RGMII_rx_ctl]
set_property PACKAGE_PIN Y11 [get_ports RGMII_rxc]
set_property PACKAGE_PIN Y16 [get_ports {RGMII_td[0]}]
set_property PACKAGE_PIN AA16 [get_ports {RGMII_td[1]}]
set_property PACKAGE_PIN AB16 [get_ports {RGMII_td[2]}]
set_property PACKAGE_PIN AB17 [get_ports {RGMII_td[3]}]
set_property PACKAGE_PIN AA13 [get_ports RGMII_tx_ctl]
set_property PACKAGE_PIN AB13 [get_ports RGMII_txc]
set_property PACKAGE_PIN U16 [get_ports RGMII_RESET_N]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_rd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_rd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_rd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_rd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports RGMII_rx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports RGMII_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_td[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_td[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_td[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RGMII_td[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports RGMII_tx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports RGMII_txc]
set_property IOSTANDARD LVCMOS33 [get_ports RGMII_RESET_N]
