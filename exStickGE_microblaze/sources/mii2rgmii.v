`timescale 1ns / 1ps
module mii2rgmii(
	(* X_INTERFACE_INFO = "xilinx.com:interface:rgmii:1.0 RGMII TD" *)
	output wire [3:0] rgmii_tx_data,
	(* X_INTERFACE_INFO = "xilinx.com:interface:rgmii:1.0 RGMII TX_CTL" *)
	output reg rgmii_tx_ctl,
	(* X_INTERFACE_PARAMETER = "FREQ_HZ 25000000" *)
	(* X_INTERFACE_INFO = "xilinx.com:interface:rgmii:1.0 RGMII TXC" *)
	output wire rgmii_tx_clk,
	(* X_INTERFACE_INFO = "xilinx.com:interface:rgmii:1.0 RGMII RD" *)
	input wire [3:0] rgmii_rx_data,
	(* X_INTERFACE_INFO = "xilinx.com:interface:rgmii:1.0 RGMII RX_CTL" *)
	input wire rgmii_rx_ctl,
	(* X_INTERFACE_PARAMETER = "FREQ_HZ 25000000" *)
	(* X_INTERFACE_INFO = "xilinx.com:interface:rgmii:1.0 RGMII RXC" *)
	input wire rgmii_rx_clk,

	output rgmii_reset_n,
	
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII TXD" *)
	input wire [3:0] mii_phy_tx_data,
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII TX_EN" *)
	input wire mii_phy_tx_en,
//    (* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII TX_ER" *)
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII RXD" *)
	output reg [3:0] mii_phy_rx_data,
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII RX_DV" *)
	output reg mii_phy_dv,
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII RX_ER" *)
	output reg mii_phy_rx_er,
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII CRS" *)
	output wire mii_phy_crs,
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII COL" *)
	output wire mii_phy_col,
	(* X_INTERFACE_PARAMETER = "FREQ_HZ 25000000" *)
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII TX_CLK" *)
	output wire mii_phy_tx_clk,
	(* X_INTERFACE_PARAMETER = "FREQ_HZ 25000000" *)
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII RX_CLK" *)
	output wire mii_phy_rx_clk,
	(* X_INTERFACE_INFO = "xilinx.com:interface:mii:1.0 MII RST_N" *)
	input wire mii_phy_rst_n,

	input wire clk_resetn

	);

	wire clk_0deg;
	wire clk_90deg;

	clock_gen inst(
		.clk_0deg(clk_0deg),
		.clk_90deg(clk_90deg),
		.resetn(clk_resetn)
	);

//Clock
	assign clk_0deg = rgmii_rx_clk;
	assign rgmii_tx_clk = clk_90deg;
	assign mii_phy_tx_clk = clk_0deg;
	assign mii_phy_rx_clk = clk_90deg;
	

//Convert RGMII to MII
	always @(posedge clk_90deg) begin
		mii_phy_rx_data <= rgmii_rx_data;
	end
	reg rgmii_rx_ctl_tmp;
	always @(posedge clk_90deg) begin
		mii_phy_dv <= rgmii_rx_ctl;
	end
	always @(negedge clk_90deg) begin
		mii_phy_rx_er <= mii_phy_dv ^ rgmii_rx_ctl;
	end

//Convert MII to RGMII
	assign mii_phy_tx_data = rgmii_tx_data;
	assign mii_phy_crs = 1'b0;
	assign mii_phy_col = 1'b0;
	assign mii_phy_rst_n = rgmii_reset_n;
	always @(rgmii_tx_clk) begin
		rgmii_tx_ctl <= mii_phy_tx_en;
	end
endmodule

module clock_gen (
	input wire clk_0deg,
	output wire clk_90deg,
	input wire resetn
	);
	wire clk_out_nobuf;
	wire clk_fb_out;
	wire clk_fb_in;
	BUFG clkf_buf
	(.O (clk_fb_in),
		.I (clk_fb_out));
	BUFG clkout1_buf
	(.O   (clk_90deg),
		.I   (clk_out_nobuf));

	MMCME2_ADV
	#(.BANDWIDTH            ("OPTIMIZED"),
		.CLKOUT4_CASCADE      ("FALSE"),
		.COMPENSATION         ("ZHOLD"),
		.STARTUP_WAIT         ("FALSE"),
		.DIVCLK_DIVIDE        (1),
		.CLKFBOUT_MULT_F      (40.000),
		.CLKFBOUT_PHASE       (0.000),
		.CLKFBOUT_USE_FINE_PS ("FALSE"),
		.CLKOUT0_DIVIDE_F     (40.000),
		.CLKOUT0_PHASE        (90.000),
		.CLKOUT0_DUTY_CYCLE   (0.500),
		.CLKOUT0_USE_FINE_PS  ("FALSE"),
		.CLKIN1_PERIOD        (40.000))
	mmcm_adv_inst
		// Output clocks
	(
		.CLKFBOUT            (clk_fb_out),
		.CLKOUT0             (clk_out_nobuf),
		// Input clock control
		.CLKFBIN             (clk_fb_in),
		.CLKIN1              (clk_0deg),
		.CLKIN2              (1'b0),
		// Tied to always select the primary input clock
		.CLKINSEL            (1'b1),
		// Ports for dynamic reconfiguration
		.DADDR               (7'h0),
		.DCLK                (1'b0),
		.DEN                 (1'b0),
		.DI                  (16'h0),
		.DO                  (do_unused),
		.DRDY                (drdy_unused),
		.DWE                 (1'b0),
		// Ports for dynamic phase shift
		.PSCLK               (1'b0),
		.PSEN                (1'b0),
		.PSINCDEC            (1'b0),
		// Other control and status signalsf
		.PWRDWN              (1'b0),
		.RST                 (~resetn));
endmodule