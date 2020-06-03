`default_nettype none

module top (
	    input wire SYS_CLK_P,
	    input wire SYS_CLK_N,
	    input wire sys_rst,

	    // HDMI
	    output wire       TMDS_TX_Clk_p,
	    output wire       TMDS_TX_Clk_n,
	    output wire [2:0] TMDS_TX_Data_p,
	    output wire [2:0] TMDS_TX_Data_n,
	    input wire        TMDS_TX_HPD,
	    output wire       TMDS_TX_OUT_EN,
	    output wire       TMDS_TX_SCL,
	    output wire       TMDS_TX_SDA,

	    input wire       TMDS_RX_Clk_p,
	    input wire       TMDS_RX_Clk_n,
	    input wire [2:0] TMDS_RX_Data_p,
	    input wire [2:0] TMDS_RX_Data_n,
	    output wire      TMDS_RX_HPD,
	    output wire      TMDS_RX_OUT_EN,
	    inout wire       TMDS_RX_SCL,
	    inout wire       TMDS_RX_SDA,

	    // DDR3
	    inout wire [7:0]   ddr3_dq,
	    inout wire [0:0]   ddr3_dqs_p,
	    inout wire [0:0]   ddr3_dqs_n,
    
	    // Outputs
	    output wire [13:0] ddr3_addr,
	    output wire [2:0]  ddr3_ba,
	    output wire        ddr3_ras_n,
	    output wire        ddr3_cas_n,
	    output wire        ddr3_we_n,
	    output wire        ddr3_reset_n,
	    output wire [0:0]  ddr3_ck_p,
	    output wire [0:0]  ddr3_ck_n,
	    output wire [0:0]  ddr3_cke,
	    output wire [0:0]  ddr3_cs_n,
	    output wire [0:0]  ddr3_dm,
	    output wire [0:0]  ddr3_odt,
    
	    // ETHER PHY
	    output wire [3:0]  GEPHY_TD,
	    output wire        GEPHY_TXEN_ER,
	    output wire        GEPHY_TCK,
	    input wire [3:0]   GEPHY_RD,
	    input wire 	       GEPHY_RCK,
	    input wire 	       GEPHY_RXDV_ER,
	    input wire 	       GEPHY_MAC_CLK,
	    
	    output wire        GEPHY_MDC,
	    inout wire 	       GEPHY_MDIO,
	    input wire 	       GEPHY_INT_N,
	    input wire 	       GEPHY_PMEB,
	    output wire        GEPHY_RST_N,
    
	    output wire [2:0] LED
	    );
  
    wire RESET;
    wire nRESET;
  
    wire GCLK_LOCKED;
    wire CLK_LOCKED;
    wire CLK310M;
    wire CLK200M;
    wire CLK125M;
    wire CLK125M_90;
    wire CLK65M;
  
    wire reset_CLK200M;
    wire reset_CLK125M;
    wire reset_CLK65M;

    wire [23:0] rgb2dvi_data;
    wire rgb2dvi_en;
    wire rgb2dvi_hsync;
    wire rgb2dvi_vsync;
    wire rgb2dvi_pixel_clk;
    wire rgb2dvi_reset;

    wire [23:0] dvi2rgb_data;
    wire dvi2rgb_de;
    wire dvi2rgb_hsync;
    wire dvi2rgb_vsync;
    wire dvi2rgb_pixel_clk;
    wire dvi2rgb_serial_clk;
    wire dvi2rgb_clk_locked;
    wire dvi2rgb_reset;
  
    wire dvi2rgb_ddc_sda_i;
    wire dvi2rgb_ddc_sda_o;
    wire dvi2rgb_ddc_sda_t;
    wire dvi2rgb_ddc_scl_i;
    wire dvi2rgb_ddc_scl_o;
    wire dvi2rgb_ddc_scl_t;
    
    wire [31:0] pUdp0Send_Data;
    wire        pUdp0Send_Request;
    wire        pUdp0Send_Ack;
    wire        pUdp0Send_Enable;

    wire [31:0] pUdp1Send_Data;
    wire        pUdp1Send_Request;
    wire        pUdp1Send_Ack;
    wire        pUdp1Send_Enable;

    wire [31:0] pUdp0Receive_Data;
    wire        pUdp0Receive_Request;
    wire        pUdp0Receive_Ack;
    wire        pUdp0Receive_Enable;

    (* mark_debug = "true" *) wire [31:0] pUdp1Receive_Data;
    (* mark_debug = "true" *) wire        pUdp1Receive_Request;
    (* mark_debug = "true" *) wire        pUdp1Receive_Ack;
    (* mark_debug = "true" *) wire        pUdp1Receive_Enable;

    wire [31:0] pMIIInput_Data;
    wire        pMIIInput_Request;
    wire        pMIIInput_Ack;
    wire        pMIIInput_Enable;

    wire [31:0] pMIIOutput_Data;
    wire        pMIIOutput_Request;
    wire        pMIIOutput_Ack;
    wire        pMIIOutput_Enable;
  
    wire [15:0] status_phy;

    wire [31:0] simple_upl32_sender_data_din;
    wire        simple_upl32_sender_data_we;
    wire        simple_upl32_sender_data_full;

    wire [127:0] simple_upl32_sender_ctrl_din;
    wire         simple_upl32_sender_ctrl_we;
    wire         simple_upl32_sender_ctrl_full;

    wire SYS_CLK;
    wire sys_rst_i;

    wire init_calib_complete;
    wire ui_clk;
    wire ui_rst;

    localparam C_S_AXI_ID_WIDTH = 4;  // Width of all master and slave ID signals.
                                      // # = >= 1.
    localparam C_S_AXI_ADDR_WIDTH = 32; // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                        // M_AXI_ARADDR for all SI/MI slots.
                                        // # = 32.
    localparam C_S_AXI_DATA_WIDTH = 32; // Width of WDATA and RDATA on SI slot.
                                        // Must be <= APP_DATA_WIDTH.
                                        // # = 32, 64, 128, 256.
    localparam C_S_AXI_SUPPORTS_NARROW_BURST = 0; // Indicates whether to instatiate upsizer
                                                  // Range: 0, 1

    // Slave Interface Write Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_awid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr;
    wire [7:0] 			     s_axi_awlen;
    wire [2:0] 			     s_axi_awsize;
    wire [1:0] 			     s_axi_awburst;
    wire [0:0] 			     s_axi_awlock;
    wire [3:0] 			     s_axi_awcache;
    wire [2:0] 			     s_axi_awprot;
    wire 			     s_axi_awvalid;
    wire 			     s_axi_awready;
    wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb;
    wire 			     s_axi_wlast;
    wire 			     s_axi_wvalid;
    wire 			     s_axi_wready;
    // Slave Interface Write Response Ports
    wire 			     s_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     s_axi_bid;
    wire [1:0] 			     s_axi_bresp;
    wire 			     s_axi_bvalid;
    // Slave Interface Read Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0] 	     s_axi_arid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr;
    wire [7:0] 			     s_axi_arlen;
    wire [2:0] 			     s_axi_arsize;
    wire [1:0] 			     s_axi_arburst;
    wire [0:0] 			     s_axi_arlock;
    wire [3:0] 			     s_axi_arcache;
    wire [2:0] 			     s_axi_arprot;
    wire 			     s_axi_arvalid;
    wire 			     s_axi_arready;
    // Slave Interface Read Data Ports
    wire 			     s_axi_rready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     s_axi_rid;
    wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata;
    wire [1:0] 			     s_axi_rresp;
    wire 			     s_axi_rlast;
    wire 			     s_axi_rvalid;



//FIFO_0
    wire [C_S_AXI_ID_WIDTH-1:0]       m0_axi_awid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m0_axi_awaddr;
    wire [7:0] 			     m0_axi_awlen;
    wire [2:0] 			     m0_axi_awsize;
    wire [1:0] 			     m0_axi_awburst;
    wire [0:0] 			     m0_axi_awlock;
    wire [3:0] 			     m0_axi_awcache;
    wire [2:0] 			     m0_axi_awprot;
    wire 			     m0_axi_awvalid;
    wire 			     m0_axi_awready;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m0_axi_wdata;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] m0_axi_wstrb;
    wire 			     m0_axi_wlast;
    wire 			     m0_axi_wvalid;
    wire 			     m0_axi_wready;
    // Slave Interface Write Response Ports
    wire 			     m0_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m0_axi_bid;
    wire [1:0] 			     m0_axi_bresp;
    wire 			     m0_axi_bvalid;
    // Slave Interface Read Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m0_axi_arid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m0_axi_araddr;
    wire [7:0] 			     m0_axi_arlen;
    wire [2:0] 			     m0_axi_arsize;
    wire [1:0] 			     m0_axi_arburst;
    wire [0:0] 			     m0_axi_arlock;
    wire [3:0] 			     m0_axi_arcache;
    wire [2:0] 			     m0_axi_arprot;
    wire 			     m0_axi_arvalid;
    wire 			     m0_axi_arready;
    // Slave Interface Read Data Ports
    wire 			     m0_axi_rready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m0_axi_rid;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m0_axi_rdata;
    wire [1:0] 			     m0_axi_rresp;
    wire 			     m0_axi_rlast;
    wire 			     m0_axi_rvalid;

	wire [32+4-1:0]		data_in0;// data + strb
	wire				data_we0;
	wire [32+8-1:0]		ctrl_in0;// len + addr
	wire				ctrl_we0;

	wire				kick0;
	wire				busy0;
	wire [31:0]			read_num0;
	wire [31:0]			read_addr0;
		
	wire [31:0]			buf_dout0;
	wire				buf_we0;

//FIFO 1
	wire [C_S_AXI_ID_WIDTH-1:0]       m1_axi_awid;
    (* mark_debug = "true" *)wire [C_S_AXI_ADDR_WIDTH-1:0]     m1_axi_awaddr;
    (* mark_debug = "true" *)wire [7:0] 			     m1_axi_awlen;
    (* mark_debug = "true" *)wire [2:0] 			     m1_axi_awsize;
    wire [1:0] 			     m1_axi_awburst;
    wire [0:0] 			     m1_axi_awlock;
    wire [3:0] 			     m1_axi_awcache;
    wire [2:0] 			     m1_axi_awprot;
    (* mark_debug = "true" *)wire 			     m1_axi_awvalid;
    (* mark_debug = "true" *)wire 			     m1_axi_awready;
    (* mark_debug = "true" *)wire [C_S_AXI_DATA_WIDTH-1:0]     m1_axi_wdata;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] m1_axi_wstrb;
    (* mark_debug = "true" *)wire 			     m1_axi_wlast;
    (* mark_debug = "true" *)wire 			     m1_axi_wvalid;
    (* mark_debug = "true" *)wire 			     m1_axi_wready;
    // Slave Interface Write Response Ports
    wire 			     m1_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m1_axi_bid;
    wire [1:0] 			     m1_axi_bresp;
    wire 			     m1_axi_bvalid;
    // Slave Interface Read Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m1_axi_arid;
    (* mark_debug = "true" *)wire [C_S_AXI_ADDR_WIDTH-1:0]     m1_axi_araddr;
    (* mark_debug = "true" *)wire [7:0] 			     m1_axi_arlen;
    (* mark_debug = "true" *)wire [2:0] 			     m1_axi_arsize;
    wire [1:0] 			     m1_axi_arburst;
    wire [0:0] 			     m1_axi_arlock;
    wire [3:0] 			     m1_axi_arcache;
    wire [2:0] 			     m1_axi_arprot;
    (* mark_debug = "true" *)wire 			     m1_axi_arvalid;
    (* mark_debug = "true" *)wire 			     m1_axi_arready;
    // Slave Interface Read Data Ports
    (* mark_debug = "true" *)wire 			     m1_axi_rready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m1_axi_rid;
(* mark_debug = "true" *)    wire [C_S_AXI_DATA_WIDTH-1:0]     m1_axi_rdata;
    wire [1:0] 			     m1_axi_rresp;
    (* mark_debug = "true" *)wire 			     m1_axi_rlast;
    wire 			     m1_axi_rvalid;


	(* mark_debug = "true" *)wire [32+4-1:0]		data_in1;// data + strb
	(* mark_debug = "true" *)wire				data_we1;
	(* mark_debug = "true" *)wire [32+8-1:0]		ctrl_in1;// len + addr
	(* mark_debug = "true" *)wire				ctrl_we1;

	(* mark_debug = "true" *)wire				kick1;
	(* mark_debug = "true" *)wire				busy1;
	(* mark_debug = "true" *)wire [31:0]			read_num1;
	(* mark_debug = "true" *)wire [31:0]			read_addr1;
		
	(* mark_debug = "true" *)wire [31:0]			buf_dout1;
	(* mark_debug = "true" *)wire				buf_we1;

	(* mark_debug = "true" *)wire				capture_sig;
	(* mark_debug = "true" *)wire				capture_rtn;
	(* mark_debug = "true" *)wire				capture_done;

	wire	FIFO_1st_end;

//FIFO 2
	wire [C_S_AXI_ID_WIDTH-1:0]       m2_axi_awid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m2_axi_awaddr;
    wire [7:0] 			     m2_axi_awlen;
    wire [2:0] 			     m2_axi_awsize;
    wire [1:0] 			     m2_axi_awburst;
    wire [0:0] 			     m2_axi_awlock;
    wire [3:0] 			     m2_axi_awcache;
    wire [2:0] 			     m2_axi_awprot;
    wire 			     m2_axi_awvalid;
    wire 			     m2_axi_awready;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m2_axi_wdata;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] m2_axi_wstrb;
    wire 			     m2_axi_wlast;
    wire 			     m2_axi_wvalid;
    wire 			     m2_axi_wready;
    // Slave Interface Write Response Ports
    wire 			     m2_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m2_axi_bid;
    wire [1:0] 			     m2_axi_bresp;
    wire 			     m2_axi_bvalid;
    // Slave Interface Read Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m2_axi_arid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m2_axi_araddr;
    wire [7:0] 			     m2_axi_arlen;
    wire [2:0] 			     m2_axi_arsize;
    wire [1:0] 			     m2_axi_arburst;
    wire [0:0] 			     m2_axi_arlock;
    wire [3:0] 			     m2_axi_arcache;
    wire [2:0] 			     m2_axi_arprot;
    wire 			     m2_axi_arvalid;
    wire 			     m2_axi_arready;
    // Slave Interface Read Data Ports
    wire 			     m2_axi_rready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m2_axi_rid;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m2_axi_rdata;
    wire [1:0] 			     m2_axi_rresp;
    wire 			     m2_axi_rlast;
    wire 			     m2_axi_rvalid;

	wire [32+4-1:0]		data_in2;// data + strb
	wire				data_we2;
	wire [32+8-1:0]		ctrl_in2;// len + addr
	wire				ctrl_we2;

	wire				kick2;
	wire				busy2;
	wire [31:0]			read_num2;
	wire [31:0]			read_addr2;
		
	wire [31:0]			buf_dout2;
	wire				buf_we2;

    wire [11:0] 	       device_temp;
    
    assign nRESET = sys_rst;
    assign RESET  = ~nRESET;

    assign TMDS_RX_OUT_EN = 1'b0;
    assign TMDS_RX_HPD    = 1'b1;

    assign TMDS_TX_OUT_EN = 1'b1;
    assign TMDS_TX_SCL    = 1'b1;
    assign TMDS_TX_SDA    = 1'b1;

    IBUFDS u_ibufds(.O(SYS_CLK),
		    .I(SYS_CLK_P),
		    .IB(SYS_CLK_N));

    clk_wiz_0 u_clk_wiz_0(.clk_out1(CLK310M),
			  .clk_out2(),
			  .locked(GCLK_LOCKED),
			  .reset(RESET),
			  .clk_in1(SYS_CLK)
			  );

    clk_wiz_1 u_clk_wiz_1(.clk_out1(CLK200M),
			  .clk_out2(CLK125M),
			  .clk_out3(CLK125M_90),
			  .clk_out4(CLK65M),
			  .reset(RESET),
			  .locked(CLK_LOCKED),
			  .clk_in1(SYS_CLK));

    reset_counter#(.RESET_COUNT(1000))
    RESET_COUNTER_200M(.clk(CLK200M), .reset_i(RESET), .reset_o(reset_CLK200M));
    reset_counter#(.RESET_COUNT(1000))
    RESET_COUNTER_125M(.clk(CLK125M), .reset_i(RESET), .reset_o(reset_CLK125M));
    reset_counter#(.RESET_COUNT(1000))
    RESET_COUNTER_65M(.clk(CLK65M), .reset_i(RESET), .reset_o(reset_CLK65M));
    
    heartbeat#(.INDEX(24))
    HEARTBEAT_65M(.clk(CLK200M), .reset(reset_CLK200M), .q(LED[2]));
    heartbeat#(.INDEX(24))
    HEARTBEAT_PIXEL_CLK(.clk(rgb2dvi_pixel_clk), .reset(rgb2dvi_reset), .q(LED[1]));
    assign LED[0] = 1'b0;

    //
    // DVI RX/TX
    //
    rgb2dvi#(
	     .kClkRange(2) // MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)
	     )
    U_RGB2DVI(
	      // DVI 1.0 TMDS video interface
	      .TMDS_Clk_p(TMDS_TX_Clk_p),
	      .TMDS_Clk_n(TMDS_TX_Clk_n),
	      .TMDS_Data_p(TMDS_TX_Data_p),
	      .TMDS_Data_n(TMDS_TX_Data_n),

	      // Auxiliary signals 
	      .aRst(rgb2dvi_reset),
	      .aRst_n(~rgb2dvi_reset),

	      // Video in
	      .vid_pData(rgb2dvi_data),
	      .vid_pVDE(rgb2dvi_en),
	      .vid_pHSync(rgb2dvi_hsync),
	      .vid_pVSync(rgb2dvi_vsync),
	      .PixelClk(rgb2dvi_pixel_clk),
      
	      // Video in
	      .SerialClk(1'b0)
	      );
  
    assign rgb2dvi_data = dvi2rgb_data;
    assign rgb2dvi_en = dvi2rgb_de;
    assign rgb2dvi_hsync = dvi2rgb_hsync;
    assign rgb2dvi_vsync = dvi2rgb_vsync;
    assign rgb2dvi_pixel_clk = dvi2rgb_pixel_clk;

    reset_counter#(.RESET_COUNT(120000000))
    RESET_RGB2DVI(.clk(rgb2dvi_pixel_clk), .reset_i(~CLK_LOCKED), .reset_o(rgb2dvi_reset));

    dvi2rgb#(
	     .kEmulateDDC(1'b1),    // will emulate a DDC EEPROM with basic EDID, if set to yes 
	     .kRstActiveHigh(1'b1), // true, if active-high; false, if active-low
	     .kAddBUFG(1'b1),       // true, if PixelClk should be re-buffered with BUFG 
	     .kClkRange(2),         // MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)
	     .kEdidFileName("900p_edid.data"),  // Select EDID file to use
	     // 7-series specific
	     .kIDLY_TapValuePs(78), // delay in ps per tap
	     .kIDLY_TapWidth(5)     // number of bits for IDELAYE2 tap counter   
	     )
    U_DVI2RGB(
	      // DVI 1.0 TMDS video interface
	      .TMDS_Clk_p(TMDS_RX_Clk_p),
	      .TMDS_Clk_n(TMDS_RX_Clk_n),
	      .TMDS_Data_p(TMDS_RX_Data_p),
	      .TMDS_Data_n(TMDS_RX_Data_n),

	      // Auxiliary signals 
	      .RefClk(CLK200M),
	      .aRst(reset_CLK200M),
	      .aRst_n(~reset_CLK200M),

	      // Video out
	      .vid_pData(dvi2rgb_data),
	      .vid_pVDE(dvi2rgb_de),
	      .vid_pHSync(dvi2rgb_hsync),
	      .vid_pVSync(dvi2rgb_vsync),
	      .PixelClk(dvi2rgb_pixel_clk),

	      .SerialClk(dvi2rgb_serial_clk),
	      .aPixelClkLckd(dvi2rgb_clk_locked),

	      // Optional DDC port
	      .DDC_SDA_I(dvi2rgb_ddc_sda_i),
	      .DDC_SDA_O(dvi2rgb_ddc_sda_o),
	      .DDC_SDA_T(dvi2rgb_ddc_sda_t),
	      .DDC_SCL_I(dvi2rgb_ddc_scl_i),
	      .DDC_SCL_O(dvi2rgb_ddc_scl_o),
	      .DDC_SCL_T(dvi2rgb_ddc_scl_t),

	      .pRst(reset_CLK200M),
	      .pRst_n(~reset_CLK200M)
	      );
    reset_counter#(.RESET_COUNT(100))
    DVI2RGB_RESET_COUNTER(.clk(dvi2rgb_pixel_clk), .reset_i(~CLK_LOCKED), .reset_o(dvi2rgb_reset));

    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_scl(.O(dvi2rgb_ddc_scl_i), .IO(TMDS_RX_SCL), .I(dvi2rgb_ddc_scl_o), .T(dvi2rgb_ddc_scl_t));

    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_sda(.O(dvi2rgb_ddc_sda_i), .IO(TMDS_RX_SDA), .I(dvi2rgb_ddc_sda_o), .T(dvi2rgb_ddc_sda_t));
  
    e7udpip_rgmii_artix7 u_e7udpip(
				   // GMII PHY
				   .GEPHY_RST_N(GEPHY_RST_N),
				   .GEPHY_MAC_CLK(CLK125M),
				   .GEPHY_MAC_CLK90(CLK125M_90),
				   // TX out
				   .GEPHY_TD(GEPHY_TD),
				   .GEPHY_TXEN_ER(GEPHY_TXEN_ER),
				   .GEPHY_TCK(GEPHY_TCK),
				   // RX in
				   .GEPHY_RD(GEPHY_RD),
				   .GEPHY_RCK(GEPHY_RCK),
				   .GEPHY_RXDV_ER(GEPHY_RXDV_ER),

				   .GEPHY_MDC(GEPHY_MDC),
				   .GEPHY_MDIO(GEPHY_MDIO),
				   .GEPHY_INT_N(GEPHY_INT_N),

				   // Asynchronous Reset
				   .Reset_n(CLK_LOCKED),
				   
				   // UPL interface
				   .pUPLGlobalClk(CLK125M),

				   // UDP tx input
				   .pUdp0Send_Data   (pUdp0Send_Data),
				   .pUdp0Send_Request(pUdp0Send_Request),
				   .pUdp0Send_Ack    (pUdp0Send_Ack),
				   .pUdp0Send_Enable (pUdp0Send_Enable),

				   .pUdp1Send_Data   (pUdp1Send_Data),
				   .pUdp1Send_Request(pUdp1Send_Request),
				   .pUdp1Send_Ack    (pUdp1Send_Ack),
				   .pUdp1Send_Enable (pUdp1Send_Enable),

				   // UDP rx output
				   .pUdp0Receive_Data   (pUdp0Receive_Data),
				   .pUdp0Receive_Request(pUdp0Receive_Request),
				   .pUdp0Receive_Ack    (pUdp0Receive_Ack),
				   .pUdp0Receive_Enable (pUdp0Receive_Enable),

				   .pUdp1Receive_Data   (pUdp1Receive_Data),
				   .pUdp1Receive_Request(pUdp1Receive_Request),
				   .pUdp1Receive_Ack    (pUdp1Receive_Ack),
				   .pUdp1Receive_Enable (pUdp1Receive_Enable),

				   // MII interface
				   .pMIIInput_Data    (pMIIInput_Data),
				   .pMIIInput_Request (pMIIInput_Request),
				   .pMIIInput_Ack     (pMIIInput_Ack),
				   .pMIIInput_Enable  (pMIIInput_Enable),

				   .pMIIOutput_Data   (pMIIOutput_Data),
				   .pMIIOutput_Request(pMIIOutput_Request),
				   .pMIIOutput_Ack    (pMIIOutput_Ack),
				   .pMIIOutput_Enable (pMIIOutput_Enable),

				   // Setup
				   .pMyIpAddr       (32'h0a000003),
				   .pMyMacAddr      (48'h001b1affffff),
				   .pMyNetmask      (32'hff000000),
				   .pDefaultGateway (32'h0a0000fe),
				   .pTargetIPAddr   (32'h0a000001),
				   .pMyUdpPort0     (16'h4000),
				   .pMyUdpPort1     (16'h4001),
				   .pPHYAddr        (5'b00001),
				   .pPHYMode        (4'b1000),
				   .pConfig_Core    (32'h00000000),

				   .pStatus_RxByteCount             (),
				   .pStatus_RxPacketCount           (),
				   .pStatus_RxErrorPacketCount      (),
				   .pStatus_RxDropPacketCount       (),
				   .pStatus_RxARPRequestPacketCount (),
				   .pStatus_RxARPReplyPacketCount   (),
				   .pStatus_RxICMPPacketCount       (),
				   .pStatus_RxUDP0PacketCount       (),
				   .pStatus_RxUDP1PacketCount       (),
				   .pStatus_RxIPErrorPacketCount    (),
				   .pStatus_RxUDPErrorPacketCount   (),

				   .pStatus_TxByteCount             (),
				   .pStatus_TxPacketCount           (),
				   .pStatus_TxARPRequestPacketCount (),
				   .pStatus_TxARPReplyPacketCount   (),
				   .pStatus_TxICMPReplyPacketCount  (),
				   .pStatus_TxUDP0PacketCount       (),
				   .pStatus_TxUDP1PacketCount       (),
				   .pStatus_TxMulticastPacketCount  (),

				   .pStatus_Phy(status_phy)
				   );

    //assign pUdp0Send_Data    = pUdp0Receive_Data;
    //assign pUdp0Send_Request = pUdp0Receive_Request;
    //assign pUdp0Receive_Ack  = pUdp0Send_Ack;
    //assign pUdp0Send_Enable  = pUdp0Receive_Enable;

    assign pUdp1Send_Data    = pUdp1Receive_Data;
    assign pUdp1Send_Request = pUdp1Receive_Request;
    assign pUdp1Receive_Ack  = pUdp1Send_Ack;
    assign pUdp1Send_Enable  = pUdp1Receive_Enable;

    assign pMIIInput_Data = 32'h00000000;
    assign pMIIInput_Request = 1'b0;
    assign pMIIInput_Enable = 1'b0;
    assign pMIIOutput_Ack = 1'b1;

rgb2dram rgb2dram_inst (
		.clk(dvi2rgb_pixel_clk),
		.rst(dvi2rgb_reset),
		//DRAM
		.data_in(data_in0),
		.data_we(data_we0),
		.ctrl_in(ctrl_in0),
		.ctrl_we(ctrl_we0),
		//VIDEO
		.vid_clk(dvi2rgb_pixel_clk),
		.hsync(dvi2rgb_hsync),
		.vsync_n(dvi2rgb_vsync),
		.de(dvi2rgb_de),
		.rgb_data(dvi2rgb_data),
		//capture
		.capture_sig(capture_sig),
		.capture_rtn(capture_rtn),
		.capture_done(capture_done)
	);

udp_axi udp_axi(
		.clk(CLK125M),
		.fifoclk(ui_clk),
		.rst(reset_CLK125M),
		.r_req(pUdp0Receive_Request),
		.r_enable(pUdp0Receive_Enable),
		.r_ack(pUdp0Receive_Ack),
		.r_data(pUdp0Receive_Data),
		.w_req(pUdp0Send_Request),
		.w_enable(pUdp0Send_Enable),
		.w_ack(pUdp0Send_Ack),
		.w_data(pUdp0Send_Data),
		//DRAM READ
		.kick(kick0),
		.busy(busy0),
		.read_num(read_num0),
		.read_addr(read_addr0),
		.buf_dout(buf_dout0),
		.buf_we(buf_we0),
		//Capture
		.capture_sig(capture_sig),
		.capture_rtn(capture_rtn)
	);

dram_copy #(
		.FILTER("grayscale")
	) u_dram_copy(
		.CLK(ui_clk),
		.RST(ui_rst),
		.START(capture_done),
		.END(FIFO_1st_end),
		.kick(kick1),
		.busy(busy1),
		.read_num(read_num1),
		.read_addr(read_addr1),
		.buf_dout(buf_dout1),
		.buf_we(buf_we1),
		.data_in(data_in1),
		.data_we(data_we1),
		.ctrl_in(ctrl_in1),
		.ctrl_we(ctrl_we1)
	);
dram_copy #(
		.READ_BASE_ADDR(32'h100_0000),
		.WRITE_BASE_ADDR(32'h200_0000)
	) u_dram_copy2 (
		.CLK(ui_clk),
		.RST(ui_rst),
		.START(FIFO_1st_end),
		.kick(kick2),
		.busy(busy2),
		.read_num(read_num2),
		.read_addr(read_addr2),
		.buf_dout(buf_dout2),
		.buf_we(buf_we2),
		.data_in(data_in2),
		.data_we(data_we2),
		.ctrl_in(ctrl_in2),
		.ctrl_we(ctrl_we2)
	);


fifo_to_axi4m u_fifo_to_axi4m_0(
		.clk(dvi2rgb_pixel_clk),
		.reset(dvi2rgb_reset),

		.data_in(data_in0),
		.data_we(data_we0),
		.ctrl_in(ctrl_in0),
		.ctrl_we(ctrl_we0),

		.m_axi_clk(ui_clk),
		.m_axi_rst(ui_rst),

		.m_axi_awid(m0_axi_awid),
		.m_axi_awaddr(m0_axi_awaddr),
		.m_axi_awlen(m0_axi_awlen),
		.m_axi_awsize(m0_axi_awsize),
		.m_axi_awburst(m0_axi_awburst),
		.m_axi_awlock(m0_axi_awlock),
		.m_axi_awcache(m0_axi_awcache),
		.m_axi_awprot(m0_axi_awprot),
		.m_axi_awvalid(m0_axi_awvalid),
		.m_axi_awready(m0_axi_awready),

		.m_axi_wdata(m0_axi_wdata),
		.m_axi_wstrb(m0_axi_wstrb),
		.m_axi_wlast(m0_axi_wlast),
		.m_axi_wvalid(m0_axi_wvalid),
		.m_axi_wready(m0_axi_wready),
		
		.m_axi_bready(m0_axi_bready),
		.m_axi_bid(m0_axi_bid),
		.m_axi_bresp(m0_axi_bresp),
		.m_axi_bvalid(m0_axi_bvalid)
	);

axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
	u_axi4m_to_fifo_0(
		.clk(ui_clk),
		.reset(ui_rst),
		
		.kick(kick0),
		.busy(busy0),
		.read_num(read_num0),
		.read_addr(read_addr0),
		
		.m_axi_arid(m0_axi_arid),
		.m_axi_araddr(m0_axi_araddr),
		.m_axi_arlen(m0_axi_arlen),
		.m_axi_arsize(m0_axi_arsize),
		.m_axi_arburst(m0_axi_arburst),
		.m_axi_arlock(m0_axi_arlock),
		.m_axi_arcache(m0_axi_arcache),
		.m_axi_arprot(m0_axi_arprot),
		.m_axi_arvalid(m0_axi_arvalid),
		.m_axi_arready(m0_axi_arready),
		
		.m_axi_rready(m0_axi_rready),
		.m_axi_rid(m0_axi_rid),
		.m_axi_rdata(m0_axi_rdata),
		.m_axi_rresp(m0_axi_rresp),
		.m_axi_rlast(m0_axi_rlast),
		.m_axi_rvalid(m0_axi_rvalid),
		
		.buf_dout(buf_dout0),
		.buf_we(buf_we0)
	);

fifo_to_axi4m u_fifo_to_axi4m_1(
		.clk(ui_clk),
		.reset(ui_rst),

		.data_in(data_in1),
		.data_we(data_we1),
		.ctrl_in(ctrl_in1),
		.ctrl_we(ctrl_we1),

		.m_axi_clk(ui_clk),
		.m_axi_rst(ui_rst),

		.m_axi_awid(m1_axi_awid),
		.m_axi_awaddr(m1_axi_awaddr),
		.m_axi_awlen(m1_axi_awlen),
		.m_axi_awsize(m1_axi_awsize),
		.m_axi_awburst(m1_axi_awburst),
		.m_axi_awlock(m1_axi_awlock),
		.m_axi_awcache(m1_axi_awcache),
		.m_axi_awprot(m1_axi_awprot),
		.m_axi_awvalid(m1_axi_awvalid),
		.m_axi_awready(m1_axi_awready),

		.m_axi_wdata(m1_axi_wdata),
		.m_axi_wstrb(m1_axi_wstrb),
		.m_axi_wlast(m1_axi_wlast),
		.m_axi_wvalid(m1_axi_wvalid),
		.m_axi_wready(m1_axi_wready),
		
		.m_axi_bready(m1_axi_bready),
		.m_axi_bid(m1_axi_bid),
		.m_axi_bresp(m1_axi_bresp),
		.m_axi_bvalid(m1_axi_bvalid)
	);

axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
	u_axi4m_to_fifo_1(
		.clk(ui_clk),
		.reset(ui_rst),
		
		.kick(kick1),
		.busy(busy1),
		.read_num(read_num1),
		.read_addr(read_addr1),
		
		.m_axi_arid(m1_axi_arid),
		.m_axi_araddr(m1_axi_araddr),
		.m_axi_arlen(m1_axi_arlen),
		.m_axi_arsize(m1_axi_arsize),
		.m_axi_arburst(m1_axi_arburst),
		.m_axi_arlock(m1_axi_arlock),
		.m_axi_arcache(m1_axi_arcache),
		.m_axi_arprot(m1_axi_arprot),
		.m_axi_arvalid(m1_axi_arvalid),
		.m_axi_arready(m1_axi_arready),
		
		.m_axi_rready(m1_axi_rready),
		.m_axi_rid(m1_axi_rid),
		.m_axi_rdata(m1_axi_rdata),
		.m_axi_rresp(m1_axi_rresp),
		.m_axi_rlast(m1_axi_rlast),
		.m_axi_rvalid(m1_axi_rvalid),
		
		.buf_dout(buf_dout1),
		.buf_we(buf_we1)
	);

fifo_to_axi4m u_fifo_to_axi4m_2(
		.clk(ui_clk),
		.reset(ui_rst),

		.data_in(data_in2),
		.data_we(data_we2),
		.ctrl_in(ctrl_in2),
		.ctrl_we(ctrl_we2),

		.m_axi_clk(ui_clk),
		.m_axi_rst(ui_rst),

		.m_axi_awid(m2_axi_awid),
		.m_axi_awaddr(m2_axi_awaddr),
		.m_axi_awlen(m2_axi_awlen),
		.m_axi_awsize(m2_axi_awsize),
		.m_axi_awburst(m2_axi_awburst),
		.m_axi_awlock(m2_axi_awlock),
		.m_axi_awcache(m2_axi_awcache),
		.m_axi_awprot(m2_axi_awprot),
		.m_axi_awvalid(m2_axi_awvalid),
		.m_axi_awready(m2_axi_awready),

		.m_axi_wdata(m2_axi_wdata),
		.m_axi_wstrb(m2_axi_wstrb),
		.m_axi_wlast(m2_axi_wlast),
		.m_axi_wvalid(m2_axi_wvalid),
		.m_axi_wready(m2_axi_wready),
		
		.m_axi_bready(m2_axi_bready),
		.m_axi_bid(m2_axi_bid),
		.m_axi_bresp(m2_axi_bresp),
		.m_axi_bvalid(m2_axi_bvalid)
	);

axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
	u_axi4m_to_fifo_2(
		.clk(ui_clk),
		.reset(ui_rst),
		
		.kick(kick2),
		.busy(busy2),
		.read_num(read_num2),
		.read_addr(read_addr2),
		
		.m_axi_arid(m2_axi_arid),
		.m_axi_araddr(m2_axi_araddr),
		.m_axi_arlen(m2_axi_arlen),
		.m_axi_arsize(m2_axi_arsize),
		.m_axi_arburst(m2_axi_arburst),
		.m_axi_arlock(m2_axi_arlock),
		.m_axi_arcache(m2_axi_arcache),
		.m_axi_arprot(m2_axi_arprot),
		.m_axi_arvalid(m2_axi_arvalid),
		.m_axi_arready(m2_axi_arready),
		
		.m_axi_rready(m2_axi_rready),
		.m_axi_rid(m2_axi_rid),
		.m_axi_rdata(m2_axi_rdata),
		.m_axi_rresp(m2_axi_rresp),
		.m_axi_rlast(m2_axi_rlast),
		.m_axi_rvalid(m2_axi_rvalid),
		
		.buf_dout(buf_dout2),
		.buf_we(buf_we2)
	);

	axi_interconnect u_axi_interconnect(
    .INTERCONNECT_ACLK(ui_clk),
    .INTERCONNECT_ARESETN(~ui_rst),
    .S00_AXI_ACLK(ui_clk),
    .S00_AXI_AWID(m0_axi_awid),
    .S00_AXI_AWADDR(m0_axi_awaddr),
    .S00_AXI_AWLEN(m0_axi_awlen),
    .S00_AXI_AWSIZE(m0_axi_awsize),
    .S00_AXI_AWBURST(m0_axi_awburst),
    .S00_AXI_AWLOCK(m0_axi_awlock),
    .S00_AXI_AWCACHE(m0_axi_awcache),
    .S00_AXI_AWPROT(m0_axi_awprot),
    .S00_AXI_AWQOS(4'h0),
    .S00_AXI_AWVALID(m0_axi_awvalid),
    .S00_AXI_AWREADY(m0_axi_awready),
    .S00_AXI_WDATA(m0_axi_wdata),
    .S00_AXI_WSTRB(m0_axi_wstrb),
    .S00_AXI_WLAST(m0_axi_wlast),
    .S00_AXI_WVALID(m0_axi_wvalid),
    .S00_AXI_WREADY(m0_axi_wready),
    .S00_AXI_BID(m0_axi_bid),
    .S00_AXI_BRESP(m0_axi_bresp),
    .S00_AXI_BVALID(m0_axi_bvalid),
    .S00_AXI_BREADY(m0_axi_bready),
    .S00_AXI_ARID(m0_axi_arid),
    .S00_AXI_ARADDR(m0_axi_araddr),
    .S00_AXI_ARLEN(m0_axi_arlen),
    .S00_AXI_ARSIZE(m0_axi_arsize),
    .S00_AXI_ARBURST(m0_axi_arburst),
    .S00_AXI_ARLOCK(m0_axi_arlock),
    .S00_AXI_ARCACHE(m0_axi_arcache),
    .S00_AXI_ARPROT(m0_axi_arprot),
    .S00_AXI_ARQOS(4'h0),
    .S00_AXI_ARVALID(m0_axi_arvalid),
    .S00_AXI_ARREADY(m0_axi_arready),
    .S00_AXI_RID(m0_axi_rid),
    .S00_AXI_RDATA(m0_axi_rdata),
    .S00_AXI_RRESP(m0_axi_rresp),
    .S00_AXI_RLAST(m0_axi_rlast),
    .S00_AXI_RVALID(m0_axi_rvalid),
    .S00_AXI_RREADY(m0_axi_rready),
    .S01_AXI_ACLK(ui_clk),
    .S01_AXI_AWID(m1_axi_awid),
    .S01_AXI_AWADDR(m1_axi_awaddr),
    .S01_AXI_AWLEN(m1_axi_awlen),
    .S01_AXI_AWSIZE(m1_axi_awsize),
    .S01_AXI_AWBURST(m1_axi_awburst),
    .S01_AXI_AWLOCK(m1_axi_awlock),
    .S01_AXI_AWCACHE(m1_axi_awcache),
    .S01_AXI_AWPROT(m1_axi_awprot),
    .S01_AXI_AWQOS(4'h0),
    .S01_AXI_AWVALID(m1_axi_awvalid),
    .S01_AXI_AWREADY(m1_axi_awready),
    .S01_AXI_WDATA(m1_axi_wdata),
    .S01_AXI_WSTRB(m1_axi_wstrb),
    .S01_AXI_WLAST(m1_axi_wlast),
    .S01_AXI_WVALID(m1_axi_wvalid),
    .S01_AXI_WREADY(m1_axi_wready),
    .S01_AXI_BID(m1_axi_bid),
    .S01_AXI_BRESP(m1_axi_bresp),
    .S01_AXI_BVALID(m1_axi_bvalid),
    .S01_AXI_BREADY(m1_axi_bready),
    .S01_AXI_ARID(m1_axi_arid),
    .S01_AXI_ARADDR(m1_axi_araddr),
    .S01_AXI_ARLEN(m1_axi_arlen),
    .S01_AXI_ARSIZE(m1_axi_arsize),
    .S01_AXI_ARBURST(m1_axi_arburst),
    .S01_AXI_ARLOCK(m1_axi_arlock),
    .S01_AXI_ARCACHE(m1_axi_arcache),
    .S01_AXI_ARPROT(m1_axi_arprot),
    .S01_AXI_ARQOS(4'h0),
    .S01_AXI_ARVALID(m1_axi_arvalid),
    .S01_AXI_ARREADY(m1_axi_arready),
    .S01_AXI_RID(m1_axi_rid),
    .S01_AXI_RDATA(m1_axi_rdata),
    .S01_AXI_RRESP(m1_axi_rresp),
    .S01_AXI_RLAST(m1_axi_rlast),
    .S01_AXI_RVALID(m1_axi_rvalid),
    .S01_AXI_RREADY(m1_axi_rready),
    .S02_AXI_ACLK(ui_clk),
    .S02_AXI_AWID(m2_axi_awid),
    .S02_AXI_AWADDR(m2_axi_awaddr),
    .S02_AXI_AWLEN(m2_axi_awlen),
    .S02_AXI_AWSIZE(m2_axi_awsize),
    .S02_AXI_AWBURST(m2_axi_awburst),
    .S02_AXI_AWLOCK(m2_axi_awlock),
    .S02_AXI_AWCACHE(m2_axi_awcache),
    .S02_AXI_AWPROT(m2_axi_awprot),
    .S02_AXI_AWQOS(4'h0),
    .S02_AXI_AWVALID(m2_axi_awvalid),
    .S02_AXI_AWREADY(m2_axi_awready),
    .S02_AXI_WDATA(m2_axi_wdata),
    .S02_AXI_WSTRB(m2_axi_wstrb),
    .S02_AXI_WLAST(m2_axi_wlast),
    .S02_AXI_WVALID(m2_axi_wvalid),
    .S02_AXI_WREADY(m2_axi_wready),
    .S02_AXI_BID(m2_axi_bid),
    .S02_AXI_BRESP(m2_axi_bresp),
    .S02_AXI_BVALID(m2_axi_bvalid),
    .S02_AXI_BREADY(m2_axi_bready),
    .S02_AXI_ARID(m2_axi_arid),
    .S02_AXI_ARADDR(m2_axi_araddr),
    .S02_AXI_ARLEN(m2_axi_arlen),
    .S02_AXI_ARSIZE(m2_axi_arsize),
    .S02_AXI_ARBURST(m2_axi_arburst),
    .S02_AXI_ARLOCK(m2_axi_arlock),
    .S02_AXI_ARCACHE(m2_axi_arcache),
    .S02_AXI_ARPROT(m2_axi_arprot),
    .S02_AXI_ARQOS(4'h0),
    .S02_AXI_ARVALID(m2_axi_arvalid),
    .S02_AXI_ARREADY(m2_axi_arready),
    .S02_AXI_RID(m2_axi_rid),
    .S02_AXI_RDATA(m2_axi_rdata),
    .S02_AXI_RRESP(m2_axi_rresp),
    .S02_AXI_RLAST(m2_axi_rlast),
    .S02_AXI_RVALID(m2_axi_rvalid),
    .S02_AXI_RREADY(m2_axi_rready),
    .M00_AXI_ACLK(ui_clk),
    .M00_AXI_AWID(s_axi_awid),
    .M00_AXI_AWADDR(s_axi_awaddr),
    .M00_AXI_AWLEN(s_axi_awlen),
    .M00_AXI_AWSIZE(s_axi_awsize),
    .M00_AXI_AWBURST(s_axi_awburst),
    .M00_AXI_AWLOCK(s_axi_awlock),
    .M00_AXI_AWCACHE(s_axi_awcache),
    .M00_AXI_AWPROT(s_axi_awprot),
    .M00_AXI_AWQOS(4'h0),
    .M00_AXI_AWVALID(s_axi_awvalid),
    .M00_AXI_AWREADY(s_axi_awready),
    .M00_AXI_WDATA(s_axi_wdata),
    .M00_AXI_WSTRB(s_axi_wstrb),
    .M00_AXI_WLAST(s_axi_wlast),
    .M00_AXI_WVALID(s_axi_wvalid),
    .M00_AXI_WREADY(s_axi_wready),
    .M00_AXI_BID(s_axi_bid),
    .M00_AXI_BRESP(s_axi_bresp),
    .M00_AXI_BVALID(s_axi_bvalid),
    .M00_AXI_BREADY(s_axi_bready),
    .M00_AXI_ARID(s_axi_arid),
    .M00_AXI_ARADDR(s_axi_araddr),
    .M00_AXI_ARLEN(s_axi_arlen),
    .M00_AXI_ARSIZE(s_axi_arsize),
    .M00_AXI_ARBURST(s_axi_arburst),
    .M00_AXI_ARLOCK(s_axi_arlock),
    .M00_AXI_ARCACHE(s_axi_arcache),
    .M00_AXI_ARPROT(s_axi_arprot),
    .M00_AXI_ARQOS(4'h0),
    .M00_AXI_ARVALID(s_axi_arvalid),
    .M00_AXI_ARREADY(s_axi_arready),
    .M00_AXI_RID(s_axi_rid),
    .M00_AXI_RDATA(s_axi_rdata),
    .M00_AXI_RRESP(s_axi_rresp),
    .M00_AXI_RLAST(s_axi_rlast),
    .M00_AXI_RVALID(s_axi_rvalid),
    .M00_AXI_RREADY(s_axi_rready)
	);

   mig_7series_0 u_mig_7series_0(.ddr3_addr(ddr3_addr),
				 .ddr3_ba(ddr3_ba),
				 .ddr3_cas_n(ddr3_cas_n),
				 .ddr3_ck_n(ddr3_ck_n),
				 .ddr3_ck_p(ddr3_ck_p),
				 .ddr3_cke(ddr3_cke),
				 .ddr3_ras_n(ddr3_ras_n),
				 .ddr3_we_n(ddr3_we_n),
				 .ddr3_dq(ddr3_dq),
				 .ddr3_dqs_n(ddr3_dqs_n),
				 .ddr3_dqs_p(ddr3_dqs_p),
				 .ddr3_reset_n(ddr3_reset_n),
				 .init_calib_complete(init_calib_complete),
				 
				 .ddr3_cs_n(ddr3_cs_n),
				 .ddr3_dm(ddr3_dm),
				 .ddr3_odt(ddr3_odt),

				 .ui_clk(ui_clk),
				 .ui_clk_sync_rst(ui_rst),

				 .mmcm_locked(),
				 .aresetn(1'b1),
				 .app_sr_req(1'b0),
				 .app_ref_req(1'b0),
				 .app_zq_req(),
				 .app_sr_active(),
				 .app_ref_ack(),
				 .app_zq_ack(),
				 
				 .s_axi_awid(s_axi_awid),
				 .s_axi_awaddr(s_axi_awaddr),
				 .s_axi_awlen(s_axi_awlen),
				 .s_axi_awsize (s_axi_awsize),
				 .s_axi_awburst(s_axi_awburst),
				 .s_axi_awlock (s_axi_awlock),
				 .s_axi_awcache(s_axi_awcache),
				 .s_axi_awprot (s_axi_awprot),
				 .s_axi_awqos  ("0000"),
				 .s_axi_awvalid(s_axi_awvalid),
				 .s_axi_awready(s_axi_awready),
				 
				 .s_axi_wdata(s_axi_wdata),
				 .s_axi_wstrb(s_axi_wstrb),
				 .s_axi_wlast(s_axi_wlast),
				 .s_axi_wvalid(s_axi_wvalid),
				 .s_axi_wready(s_axi_wready),
				 .s_axi_bid(s_axi_bid),
				 .s_axi_bresp(s_axi_bresp),
				 .s_axi_bvalid(s_axi_bvalid),
				 .s_axi_bready(s_axi_bready),
				 
				 .s_axi_arid   (s_axi_arid),
				 .s_axi_araddr (s_axi_araddr),
				 .s_axi_arlen  (s_axi_arlen),
				 .s_axi_arsize (s_axi_arsize),
				 .s_axi_arburst(s_axi_arburst),
				 .s_axi_arlock (s_axi_arlock),
				 .s_axi_arcache(s_axi_arcache),
				 .s_axi_arprot (s_axi_arprot),
				 .s_axi_arqos  ("0000"),
				 .s_axi_arvalid(s_axi_arvalid),
				 .s_axi_arready(s_axi_arready),
				 
				 .s_axi_rid   (s_axi_rid),
				 .s_axi_rdata (s_axi_rdata),
				 .s_axi_rresp (s_axi_rresp),
				 .s_axi_rlast (s_axi_rlast),
				 .s_axi_rvalid(s_axi_rvalid),
				 .s_axi_rready(s_axi_rready),
				 
				 //  System Clock Ports
				 .sys_clk_i(CLK310M),
				 // Reference Clock Ports
				 .clk_ref_i(CLK200M),
				 .device_temp(device_temp),
				 .sys_rst(sys_rst_i)
				 );
    assign sys_rst_i = CLK_LOCKED;

endmodule // top

`default_nettype wire
