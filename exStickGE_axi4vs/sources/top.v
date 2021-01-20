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
  
	localparam USE_900P = 1;
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

    (* mark_debug = "true" *) wire [23:0] dvi2rgb_data;
    (* mark_debug = "true" *) wire dvi2rgb_de;
    (* mark_debug = "true" *) wire dvi2rgb_hsync;
    (* mark_debug = "true" *) wire dvi2rgb_vsync;
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

    (* mark_debug = "true" *) wire [31:0] simple_upl32_sender_data_din;
    (* mark_debug = "true" *) wire        simple_upl32_sender_data_we;
    (* mark_debug = "true" *) wire        simple_upl32_sender_data_full;

    (* mark_debug = "true" *) wire [127:0] simple_upl32_sender_ctrl_din;
    (* mark_debug = "true" *) wire         simple_upl32_sender_ctrl_we;
    (* mark_debug = "true" *) wire         simple_upl32_sender_ctrl_full;

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
    (* mark_debug = "true" *)wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_awid;
    (* mark_debug = "true" *)wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr;
    (* mark_debug = "true" *)wire [7:0] 			     s_axi_awlen;
    (* mark_debug = "true" *)wire [2:0] 			     s_axi_awsize;
    (* mark_debug = "true" *)wire [1:0] 			     s_axi_awburst;
    (* mark_debug = "true" *)wire [0:0] 			     s_axi_awlock;
    (* mark_debug = "true" *)wire [3:0] 			     s_axi_awcache;
    (* mark_debug = "true" *)wire [2:0] 			     s_axi_awprot;
    (* mark_debug = "true" *)wire 			     s_axi_awvalid;
    (* mark_debug = "true" *)wire 			     s_axi_awready;
    (* mark_debug = "true" *)wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata;
    (* mark_debug = "true" *)wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb;
    (* mark_debug = "true" *)wire 			     s_axi_wlast;
    (* mark_debug = "true" *)wire 			     s_axi_wvalid;
    (* mark_debug = "true" *)wire 			     s_axi_wready;
    // Slave Interface Write Response Ports
    (* mark_debug = "true" *)wire 			     s_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     s_axi_bid;
    (* mark_debug = "true" *)wire [1:0] 			     s_axi_bresp;
    (* mark_debug = "true" *)wire 			     s_axi_bvalid;
    // Slave Interface Read Address Ports
    (* mark_debug = "true" *)wire [C_S_AXI_ID_WIDTH-1:0] 	     s_axi_arid;
    (* mark_debug = "true" *)wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr;
    (* mark_debug = "true" *)wire [7:0] 			     s_axi_arlen;
    (* mark_debug = "true" *)wire [2:0] 			     s_axi_arsize;
    (* mark_debug = "true" *)wire [1:0] 			     s_axi_arburst;
    (* mark_debug = "true" *)wire [0:0] 			     s_axi_arlock;
    (* mark_debug = "true" *)wire [3:0] 			     s_axi_arcache;
    (* mark_debug = "true" *)wire [2:0] 			     s_axi_arprot;
    (* mark_debug = "true" *)wire 			     s_axi_arvalid;
    (* mark_debug = "true" *)wire 			     s_axi_arready;
    // Slave Interface Read Data Ports
    (* mark_debug = "true" *)wire 			     s_axi_rready;
    (* mark_debug = "true" *)wire [C_S_AXI_ID_WIDTH-1:0] 	     s_axi_rid;
    (* mark_debug = "true" *)wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata;
    (* mark_debug = "true" *)wire [1:0] 			     s_axi_rresp;
    (* mark_debug = "true" *)wire 			     s_axi_rlast;
    (* mark_debug = "true" *)wire 			     s_axi_rvalid;

	(* mark_debug = "true" *)wire [32+4-1:0]		data_in;// data + strb
	(* mark_debug = "true" *)wire				data_we;
	(* mark_debug = "true" *)wire [32+8-1:0]		ctrl_in;// len + addr
	(* mark_debug = "true" *)wire				ctrl_we;

	(* mark_debug = "true" *)wire				kick;
	(* mark_debug = "true" *)wire				busy;
	(* mark_debug = "true" *)wire [31:0]			read_num;
	(* mark_debug = "true" *)wire [31:0]			read_addr;
		
	wire [31:0]			buf_dout;
	wire				buf_we;

	wire				capture_sig;
	wire				capture_rtn;

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
	     .kEdidFileName((USE_900P == 1)?"900p_edid.data":"720p_edid.data"),  // Select EDID file to use
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

rgb2dram #(
	.USE_900P(USE_900P)
) rgb2dram_inst (
		.clk(dvi2rgb_pixel_clk),
		.rst(dvi2rgb_reset),
		//DRAM
		.data_in(data_in),
		.data_we(data_we),
		.ctrl_in(ctrl_in),
		.ctrl_we(ctrl_we),
		//VIDEO
		.vid_clk(dvi2rgb_pixel_clk),
		.hsync(dvi2rgb_hsync),
		.vsync_n(dvi2rgb_vsync),
		.de(dvi2rgb_de),
		.rgb_data(dvi2rgb_data),
		//capture
		.capture_sig(capture_sig),
		.capture_rtn(capture_rtn)
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
		.kick(kick),
		.busy(busy),
		.read_num(read_num),
		.read_addr(read_addr),
		.buf_dout(buf_dout),
		.buf_we(buf_we),
		//Capture
		.capture_sig(capture_sig),
		.capture_rtn(capture_rtn)
	);


fifo_to_axi4m u_fifo_to_axi4m(
		.clk(dvi2rgb_pixel_clk),
		.reset(dvi2rgb_reset),

		.data_in(data_in),
		.data_we(data_we),
		.ctrl_in(ctrl_in),
		.ctrl_we(ctrl_we),

		.m_axi_clk(ui_clk),
		.m_axi_rst(ui_rst),

		.m_axi_awid(s_axi_awid),
		.m_axi_awaddr(s_axi_awaddr),
		.m_axi_awlen(s_axi_awlen),
		.m_axi_awsize(s_axi_awsize),
		.m_axi_awburst(s_axi_awburst),
		.m_axi_awlock(s_axi_awlock),
		.m_axi_awcache(s_axi_awcache),
		.m_axi_awprot(s_axi_awprot),
		.m_axi_awvalid(s_axi_awvalid),
		.m_axi_awready(s_axi_awready),

		.m_axi_wdata(s_axi_wdata),
		.m_axi_wstrb(s_axi_wstrb),
		.m_axi_wlast(s_axi_wlast),
		.m_axi_wvalid(s_axi_wvalid),
		.m_axi_wready(s_axi_wready),
		
		.m_axi_bready(s_axi_bready),
		.m_axi_bid(s_axi_bid),
		.m_axi_bresp(s_axi_bresp),
		.m_axi_bvalid(s_axi_bvalid)
	);

axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
	u_axi4m_to_fifo(
		.clk(ui_clk),
		.reset(ui_rst),
		
		.kick(kick),
		.busy(busy),
		.read_num(read_num),
		.read_addr(read_addr),
		
		.m_axi_arid(s_axi_arid),
		.m_axi_araddr(s_axi_araddr),
		.m_axi_arlen(s_axi_arlen),
		.m_axi_arsize(s_axi_arsize),
		.m_axi_arburst(s_axi_arburst),
		.m_axi_arlock(s_axi_arlock),
		.m_axi_arcache(s_axi_arcache),
		.m_axi_arprot(s_axi_arprot),
		.m_axi_arvalid(s_axi_arvalid),
		.m_axi_arready(s_axi_arready),
		
		.m_axi_rready(s_axi_rready),
		.m_axi_rid(s_axi_rid),
		.m_axi_rdata(s_axi_rdata),
		.m_axi_rresp(s_axi_rresp),
		.m_axi_rlast(s_axi_rlast),
		.m_axi_rvalid(s_axi_rvalid),
		
		.buf_dout(buf_dout),
		.buf_we(buf_we)
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

	rgb2videoaxis u_rgb2videoaxis(
		.vid_clk(dvi2rgb_pixel_clk),
		.rst(dvi2rgb_reset),
		//VIDEO
		.hsync(dvi2rgb_hsync),
		.vsync_n(dvi2rgb_vsync),
		.de(dvi2rgb_de),
		.rgb_data(dvi2rgb_data)
		);

endmodule // top

`default_nettype wire
