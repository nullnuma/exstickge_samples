`default_nettype none

module top (
		// DDR3
		inout wire [7:0]	ddr3_dq,
		inout wire [0:0]	ddr3_dqs_p,
		inout wire [0:0]	ddr3_dqs_n,
	
		// Outputs
		output wire [13:0]	ddr3_addr,
		output wire [2:0]	ddr3_ba,
		output wire			ddr3_ras_n,
		output wire			ddr3_cas_n,
		output wire			ddr3_we_n,
		output wire			ddr3_reset_n,
		output wire [0:0]	ddr3_ck_p,
		output wire [0:0]	ddr3_ck_n,
		output wire [0:0]	ddr3_cke,
		output wire [0:0]	ddr3_cs_n,
		output wire [0:0]	ddr3_dm,
		output wire [0:0]	ddr3_odt,
	
		// ETHER PHY
		output wire [3:0]	GEPHY_TD,
		output wire			GEPHY_TXEN_ER,
		output wire			GEPHY_TCK,
		input wire [3:0]	GEPHY_RD,
		input wire			GEPHY_RCK,
		input wire			GEPHY_RXDV_ER,
		input wire			GEPHY_MAC_CLK,
		
		output wire			GEPHY_MDC,
		inout wire			GEPHY_MDIO,
		input wire			GEPHY_INT_N,
		input wire			GEPHY_PMEB,
		output wire			GEPHY_RST_N,
	
		// GPIO
		inout wire			GPIO00,
		inout wire			GPIO01,
		inout wire			GPIO02,
		inout wire			GPIO03,
		inout wire			GPIO04,
		inout wire			GPIO05,
		inout wire			GPIO06,
		inout wire			GPIO07,
		inout wire			GPIO10,
		inout wire			GPIO11,
		inout wire			GPIO12,
		inout wire			GPIO13,
	
		inout wire			GPIO14,
		inout wire			GPIO15,
	
		inout wire			GPIO20,
		inout wire			GPIO21,
		inout wire			GPIO22,
		inout wire			GPIO23,
		inout wire			GPIO24,
		inout wire			GPIO25,
		inout wire			GPIO26,
		inout wire			GPIO27,
		inout wire			GPIO30,
		inout wire			GPIO31,
		inout wire			GPIO32,
		inout wire			GPIO33,
		inout wire			GPIO34,
		inout wire			GPIO35,
		
		inout wire			GPIO40,
		inout wire			GPIO41,
		inout wire			GPIO42,
		inout wire			GPIO43,
		inout wire			GPIO44,
		inout wire			GPIO45,
		inout wire			GPIO46,
		inout wire			GPIO47,
		inout wire			GPIO50,
		inout wire			GPIO51,
		inout wire			GPIO52,
		inout wire			GPIO53,
	
		inout wire			GPIO54,
		inout wire			GPIO55,
	
		inout wire			GPIO60,
		inout wire			GPIO61,
		inout wire			GPIO62,
		inout wire			GPIO63,
		inout wire			GPIO64,
		inout wire			GPIO65,
		inout wire			GPIO66,
		inout wire			GPIO67,
		inout wire			GPIO70,
		inout wire			GPIO71,
		inout wire			GPIO72,
		inout wire			GPIO73,
		inout wire			GPIO74,
		inout wire			GPIO75,
	
		output wire			HDMI0_D0_P,
		output wire			HDMI0_D0_N,
		output wire			HDMI0_D1_P,
		output wire			HDMI0_D1_N,
		output wire			HDMI0_D2_P,
		output wire			HDMI0_D2_N,
		inout wire			HDMI0_SCL,
		inout wire			HDMI0_SDA,
		output wire			HDMI0_CLK_P,
		output wire			HDMI0_CLK_N,
	
		inout wire			HDMI1_D0_P,
		inout wire			HDMI1_D0_N,
		inout wire			HDMI1_D1_P,
		inout wire			HDMI1_D1_N,
		inout wire			HDMI1_D2_P,
		inout wire			HDMI1_D2_N,
		inout wire			HDMI1_SCL,
		inout wire			HDMI1_SDA,
		inout wire			HDMI1_CLK_P,
		inout wire			HDMI1_CLK_N,
	
		inout wire [3:0]	PMOD,
	
		// DEBUG
		output wire			LED0,
		output wire			LED1,
		output wire			LED2,
	
		// Single-ended system clock
		input wire			sys_clk_p,
		input wire			sys_clk_n,
		input wire			sys_rst_n
		);

wire			sys_clk;
wire			sys_rst;

wire			clk200M;
wire			clk125M;
wire			clk125M_90;
wire			clk310M;
wire			clk_vga;
wire			clk_tx;
wire			locked_0;
wire			locked_1;

wire			reset125M;
wire			reset200M;

wire			init_calib_complete;
wire			ui_clk;
wire			ui_rst;

wire [11:0]		device_temp;

wire [31:0]		pEtherSend0_Data;
wire			pEtherSend0_Request;
wire			pEtherSend0_Ack;
wire			pEtherSend0_Enable;

wire			pEtherReceive_Data;
wire			pEtherReceive_Request;
wire			pEtherReceive_Ack;
wire			pEtherReceive_Enable;

wire [31:0]		pUdp0Send_Data;
wire			pUdp0Send_Request;
wire			pUdp0Send_Ack;
wire			pUdp0Send_Enable;

wire [31:0]		pUdp1Send_Data;
wire			pUdp1Send_Request;
wire			pUdp1Send_Ack;
wire			pUdp1Send_Enable;

// UDP rx output
wire [31:0]		pUdp0Receive_Data;
wire			pUdp0Receive_Request;
wire			pUdp0Receive_Ack;
wire			pUdp0Receive_Enable;

wire [31:0]		pUdp1Receive_Data;
wire			pUdp1Receive_Request;
wire			pUdp1Receive_Ack;
wire			pUdp1Receive_Enable;

// MII interface
wire [31:0]		pMIIInput_Data;
wire			pMIIInput_Request;
wire			pMIIInput_Ack;
wire			pMIIInput_Enable;

wire [31:0]		pMIIOutput_Data;
wire			pMIIOutput_Request;
wire			pMIIOutput_Ack;
wire			pMIIOutput_Enable;

wire [15:0]			status_phy;

localparam C_S_AXI_ID_WIDTH = 4;	// Width of all master and slave ID signals.
									// # = >= 1.
localparam C_S_AXI_ADDR_WIDTH = 32; // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
									// M_AXI_ARADDR for all SI/MI slots.
									// # = 32.
localparam C_S_AXI_DATA_WIDTH = 32; // Width of WDATA and RDATA on SI slot.
									// Must be <= APP_DATA_WIDTH.
									// # = 32, 64, 128, 256.
localparam C_S_AXI_SUPPORTS_NARROW_BURST = 0;	// Indicates whether to instatiate upsizer
												// Range: 0, 1

// Slave Interface Write Address Ports
wire [C_S_AXI_ID_WIDTH-1:0]			s_axi_awid;
wire [C_S_AXI_ADDR_WIDTH-1:0]		s_axi_awaddr;
wire [7:0]			s_axi_awlen;
wire [2:0]			s_axi_awsize;
wire [1:0]			s_axi_awburst;
wire [0:0]			s_axi_awlock;
wire [3:0]			s_axi_awcache;
wire [2:0]			s_axi_awprot;
wire				s_axi_awvalid;
wire				s_axi_awready;
wire [C_S_AXI_DATA_WIDTH-1:0]		s_axi_wdata;
wire [(C_S_AXI_DATA_WIDTH/8)-1:0]	s_axi_wstrb;
wire			s_axi_wlast;
wire			s_axi_wvalid;
wire			s_axi_wready;
// Slave Interface Write Response Ports
wire			s_axi_bready;
wire [C_S_AXI_ID_WIDTH-1:0]			s_axi_bid;
wire [1:0]			s_axi_bresp;
wire			s_axi_bvalid;
// Slave Interface Read Address Ports
wire [C_S_AXI_ID_WIDTH-1:0]			s_axi_arid;
wire [C_S_AXI_ADDR_WIDTH-1:0]		s_axi_araddr;
wire [7:0]			s_axi_arlen;
wire [2:0]			s_axi_arsize;
wire [1:0]			s_axi_arburst;
wire [0:0]			s_axi_arlock;
wire [3:0]			s_axi_arcache;
wire [2:0]			s_axi_arprot;
wire				s_axi_arvalid;
wire				s_axi_arready;
// Slave Interface Read Data Ports
wire				s_axi_rready;
wire [C_S_AXI_ID_WIDTH-1:0]		s_axi_rid;
wire [C_S_AXI_DATA_WIDTH-1:0]	s_axi_rdata;
wire [1:0]			s_axi_rresp;
wire				s_axi_rlast;
wire				s_axi_rvalid;

wire [32+4-1:0]		data_in;// data + strb
wire				data_we;
wire [32+8-1:0]		ctrl_in;// len + addr
wire				ctrl_we;

wire				kick;
wire				busy;
wire [31:0]			read_num;
wire [31:0]			read_addr;
	
wire [31:0]			buf_dout;
wire				buf_we;

assign GPIO00 = 1'b0;
assign GPIO01 = 1'b0;
assign GPIO02 = 1'b0;
assign GPIO03 = 1'b0;
assign GPIO04 = 1'b0;
assign GPIO05 = 1'b0;
assign GPIO06 = 1'b0;
assign GPIO07 = 1'b0;
assign GPIO10 = 1'b0;
assign GPIO11 = 1'b0;
assign GPIO12 = 1'b0;
assign GPIO13 = 1'b0;

assign GPIO14 = 1'b0;
assign GPIO15 = 1'b0;

assign GPIO20 = 1'b0;
assign GPIO21 = 1'b0;
assign GPIO22 = 1'b0;
assign GPIO23 = 1'b0;
assign GPIO24 = 1'b0;
assign GPIO25 = 1'b0;
assign GPIO26 = 1'b0;
assign GPIO27 = 1'b0;
assign GPIO30 = 1'b0;
assign GPIO31 = 1'b0;
assign GPIO32 = 1'b0;
assign GPIO33 = 1'b0;
assign GPIO34 = 1'b0;
assign GPIO35 = 1'b1; // HDMI(cn2) enable out

assign GPIO40 = 1'b0;
assign GPIO41 = 1'b0;
assign GPIO42 = 1'b0;
assign GPIO43 = 1'b0;
assign GPIO44 = 1'b0;
assign GPIO45 = 1'b0;
assign GPIO46 = 1'b0;
assign GPIO47 = 1'b0;
assign GPIO50 = 1'b0;
assign GPIO51 = 1'b0;
assign GPIO52 = 1'b0;
assign GPIO53 = 1'b0;

assign GPIO54 = 1'b0;
assign GPIO55 = 1'b0;

assign GPIO60 = 1'b0;
assign GPIO61 = 1'b0;
assign GPIO62 = 1'b0;
assign GPIO63 = 1'b0;
assign GPIO64 = 1'b0;
assign GPIO65 = 1'b0;
assign GPIO66 = 1'b0;
assign GPIO67 = 1'b0;
assign GPIO70 = 1'b0;
assign GPIO71 = 1'b0;
assign GPIO72 = 1'b0;
assign GPIO73 = 1'b0;
assign GPIO74 = 1'b0;
assign GPIO75 = 1'b0;

assign HDMI0_SCL  = 1'b0;
assign HDMI0_SDA  = 1'b0;

assign HDMI1_D0_P = 1'b0;
assign HDMI1_D0_N = 1'b0;
assign HDMI1_D1_P = 1'b0;
assign HDMI1_D1_N = 1'b0;
assign HDMI1_D2_P = 1'b0;
assign HDMI1_D2_N = 1'b0;
assign HDMI1_SCL  = 1'b0;
assign HDMI1_SDA  = 1'b0;
assign HDMI1_CLK_P = 1'b0;
assign HDMI1_CLK_N = 1'b0;

assign PMOD = 4'h0;

assign LED0 = status_phy[0];
assign LED1 = init_calib_complete;
assign LED2 = pUdp0Receive_Enable || pUdp1Receive_Enable;

assign sys_rst = ~sys_rst_n;

IBUFDS sys_clk_buf(.I(sys_clk_p),
			.IB(sys_clk_n),
			.O(sys_clk));

clk_wiz_0 clk_wiz_0_i(.clk_out1(clk310M),
			.reset(sys_rst),
			.locked(locked_0),
			.clk_in1(sys_clk));

clk_wiz_1 clk_wiz_1_i(.clk_out1(clk200M),
			.clk_out2(clk125M),
			.clk_out3(clk125M_90),
			.reset(sys_rst),
			.locked(locked_1),
			.clk_in1(GEPHY_MAC_CLK));
clk_wiz_2 clk_wiz_2_i(.clk_out1(clk_tx),
			.clk_out2(clk_vga),
			.reset(sys_rst),
			.clk_in1(sys_clk));

resetgen resetgen_i_0(.clk(clk125M), .reset_in(~locked_1), .reset_out(reset125M));
resetgen resetgen_i_1(.clk(clk200M), .reset_in(~locked_1), .reset_out(reset200M));

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
				.sys_clk_i(clk310M),
				// Reference Clock Ports
				.clk_ref_i(clk200M),
				.device_temp(device_temp),
				.sys_rst(locked_1 && sys_rst_n)
				);

assign GEPHY_RST_N = locked_0 && sys_rst_n;
idelayctrl_wrapper#(.CLK_PERIOD(5))(.clk(clk200M), .reset(reset200M), .ready());

e7udpip_rgmii_artix7
u_e7udpip(
		// GMII PHY
		.GEPHY_RST_N		(),
		.GEPHY_MAC_CLK		(clk125M),
		.GEPHY_MAC_CLK90	(clk125M_90),
		// TX out
		.GEPHY_TD			(GEPHY_TD),
		.GEPHY_TXEN_ER		(GEPHY_TXEN_ER),
		.GEPHY_TCK			(GEPHY_TCK),
		// RX in
		.GEPHY_RD			(GEPHY_RD),
		.GEPHY_RCK			(GEPHY_RCK),
		.GEPHY_RXDV_ER		(GEPHY_RXDV_ER),
		
		.GEPHY_MDC			(GEPHY_MDC),
		.GEPHY_MDIO			(GEPHY_MDIO),
		.GEPHY_INT_N		(GEPHY_INT_N),
		
		// Asynchronous Reset
		.Reset_n			(~reset125M),
	
		// UPL interface
		.pUPLGlobalClk		(ui_clk),
		
		// UDP tx input
		.pUdp0Send_Data		(pUdp0Send_Data),
		.pUdp0Send_Request	(pUdp0Send_Request),
		.pUdp0Send_Ack		(pUdp0Send_Ack),
		.pUdp0Send_Enable	(pUdp0Send_Enable),
		
		.pUdp1Send_Data		(pUdp1Send_Data),
		.pUdp1Send_Request	(pUdp1Send_Request),
		.pUdp1Send_Ack		(pUdp1Send_Ack),
		.pUdp1Send_Enable	(pUdp1Send_Enable),
		
		// UDP rx output
		.pUdp0Receive_Data	(pUdp0Receive_Data),
		.pUdp0Receive_Request(pUdp0Receive_Request),
		.pUdp0Receive_Ack	(pUdp0Receive_Ack),
		.pUdp0Receive_Enable(pUdp0Receive_Enable),
		
		.pUdp1Receive_Data	(pUdp1Receive_Data),
		.pUdp1Receive_Request(pUdp1Receive_Request),
		.pUdp1Receive_Ack	(pUdp1Receive_Ack),
		.pUdp1Receive_Enable(pUdp1Receive_Enable),
		
		// MII interface
		.pMIIInput_Data		(pMIIInput_Data),
		.pMIIInput_Request	(pMIIInput_Request),
		.pMIIInput_Ack		(pMIIInput_Ack),
		.pMIIInput_Enable	(pMIIInput_Enable),
		
		.pMIIOutput_Data	(pMIIOutput_Data),
		.pMIIOutput_Request	(pMIIOutput_Request),
		.pMIIOutput_Ack		(pMIIOutput_Ack),
		.pMIIOutput_Enable	(pMIIOutput_Enable),
		
		// Setup
		.pMyIpAddr			(32'h0a000003),
		.pMyMacAddr			(48'h001b1affffff),
		.pMyNetmask			(32'hff000000),
		.pDefaultGateway	(32'h0a0000fe),
		.pTargetIPAddr		(32'h0a000001),
		.pMyUdpPort0		(16'h4000),
		.pMyUdpPort1		(16'h4001),
		.pPHYAddr			(5'b00001),
		.pPHYMode			(4'b1000),
		.pConfig_Core		(8'h00000000),
		
		// Status
		.pStatus_RxByteCount(),
		.pStatus_RxPacketCount(),
		.pStatus_RxErrorPacketCount(),
		.pStatus_RxDropPacketCount(),
		.pStatus_RxARPRequestPacketCount(),
		.pStatus_RxARPReplyPacketCount(),
		.pStatus_RxICMPPacketCount(),
		.pStatus_RxUDP0PacketCount(),
		.pStatus_RxUDP1PacketCount(),
		.pStatus_RxIPErrorPacketCount(),
		.pStatus_RxUDPErrorPacketCount(),
		
		.pStatus_TxByteCount(),
		.pStatus_TxPacketCount(),
		.pStatus_TxARPRequestPacketCount(),
		.pStatus_TxARPReplyPacketCount(),
		.pStatus_TxICMPReplyPacketCount(),
		.pStatus_TxUDP0PacketCount(),
		.pStatus_TxUDP1PacketCount(),
		.pStatus_TxMulticastPacketCount(),
		
		.pStatus_Phy(status_phy),
		
		.pdebug()
		);

//assign pUdp0Send_Data    = pUdp0Receive_Data;
//assign pUdp0Send_Request = pUdp0Receive_Request;
//assign pUdp0Receive_Ack  = pUdp0Send_Ack;
//assign pUdp0Send_Enable  = pUdp0Receive_Enable;

assign pUdp1Send_Data	= pUdp1Receive_Data;
assign pUdp1Send_Request= pUdp1Receive_Request;
assign pUdp1Receive_Ack	= pUdp1Send_Ack;
assign pUdp1Send_Enable	= pUdp1Receive_Enable;

assign pMIIInput_Data	= 32'h00000000;
assign pMIIInput_Request= 1'b0;
assign pMIIInput_Enable	= 1'b0;

assign pMIIOutput_Ack	= 1'b1;

fifo_to_axi4m u_fifo_to_axi4m(.clk(ui_clk),
		.reset(ui_rst),

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
u_axi4m_to_fifo(.clk(ui_clk),
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

hdmi_gen hdmi_gen(
		.clk(ui_clk),
		.fifoclk(ui_clk),
		.rst(ui_rst),
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
		//DRAM WRITE
		.data_in(data_in),
		.data_we(data_we),
		.ctrl_in(ctrl_in),
		.ctrl_we(ctrl_we),
		//HDMI
		.clk_vga(clk_vga),
		.clk_tx(clk_tx),
		.clk_to_pins_n(HDMI0_CLK_N),
		.clk_to_pins_p(HDMI0_CLK_P),
		.data_out_to_pins_n({HDMI0_D2_N,HDMI0_D1_N,HDMI0_D0_N}),
		.data_out_to_pins_p({HDMI0_D2_P,HDMI0_D1_P,HDMI0_D0_P})
	);

endmodule // top

`default_nettype wire
