`default_nettype none

module top (
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
    
	    // GPIO
	    inout wire 	       GPIO32,
	    inout wire 	       GPIO33,
	    inout wire 	       GPIO34,
	    inout wire 	       GPIO35,
	    
	    inout wire 	       GPIO42,
	    inout wire 	       GPIO43,
	    inout wire 	       GPIO44,
	    inout wire 	       GPIO45,
	    inout wire 	       GPIO46,
	    inout wire 	       GPIO47,
	    inout wire 	       GPIO50,
	    inout wire 	       GPIO51,
	    inout wire 	       GPIO52,
	    inout wire 	       GPIO53,
    
	    inout wire 	       GPIO54,
	    inout wire 	       GPIO55,
    
	    inout wire 	       GPIO60,
	    inout wire 	       GPIO61,
	    inout wire 	       GPIO62,
	    inout wire 	       GPIO63,
	    inout wire 	       GPIO64,
	    inout wire 	       GPIO65,
	    inout wire 	       GPIO66,
	    inout wire 	       GPIO67,
	    inout wire 	       GPIO70,
	    inout wire 	       GPIO71,
	    inout wire 	       GPIO72,
	    inout wire 	       GPIO73,
	    inout wire 	       GPIO74,
	    inout wire 	       GPIO75,
    
	    inout wire 	       HDMI0_D0_P,
	    inout wire 	       HDMI0_D0_N,
	    inout wire 	       HDMI0_D1_P,
	    inout wire 	       HDMI0_D1_N,
	    inout wire 	       HDMI0_D2_P,
	    inout wire 	       HDMI0_D2_N,
	    inout wire 	       HDMI0_SCL,
	    inout wire 	       HDMI0_SDA,
	    inout wire 	       HDMI0_CLK_P,
	    inout wire 	       HDMI0_CLK_N,
    
	    inout wire 	       HDMI1_D0_P,
	    inout wire 	       HDMI1_D0_N,
	    inout wire 	       HDMI1_D1_P,
	    inout wire 	       HDMI1_D1_N,
	    inout wire 	       HDMI1_D2_P,
	    inout wire 	       HDMI1_D2_N,
	    inout wire 	       HDMI1_SCL,
	    inout wire 	       HDMI1_SDA,
	    inout wire 	       HDMI1_CLK_P,
	    inout wire 	       HDMI1_CLK_N,

	    // MIPI-CSI 1
	    input  wire MIPI1_LANE0_N,
	    input  wire MIPI1_LANE0_P,
	    input  wire MIPI1_LANE1_N,
	    input  wire MIPI1_LANE1_P,
	    input  wire MIPI1_CLK_N,
	    input  wire MIPI1_CLK_P,
	    output reg  MIPI1_PWUP,
	    input  wire MIPI1_NC,
	    output wire MIPI1_SCL,
	    inout  wire MIPI1_SDA,

	    input wire MIPI1_LP_LANE0_P,
	    input wire MIPI1_LP_LANE0_N,
	    input wire MIPI1_LP_LANE1_P,
	    input wire MIPI1_LP_LANE1_N,
	    input wire MIPI1_LP_CLK_P,
	    input wire MIPI1_LP_CLK_N,

	    // MIPI-CSI 2
	    input  wire MIPI2_LANE0_N,
	    input  wire MIPI2_LANE0_P,
	    input  wire MIPI2_LANE1_N,
	    input  wire MIPI2_LANE1_P,
	    input  wire MIPI2_CLK_N,
	    input  wire MIPI2_CLK_P,
	    output reg  MIPI2_PWUP,
	    input  wire MIPI2_NC,
	    output wire MIPI2_SCL,
	    inout  wire MIPI2_SDA,

	    inout wire [3:0]   PMOD,
    
	    // DEBUG
	    output wire        LED0,
	    output wire        LED1,
	    output wire        LED2,
    
	    // Single-ended system clock
	    input wire 	       sys_clk_p,
	    input wire 	       sys_clk_n,
	    input wire 	       sys_rst_n
	    );

   wire 	       sys_clk;
   wire 	       sys_rst;
   
   wire 	       clk200M;
   wire 	       clk125M;
   wire 	       clk125M_90;
   wire 	       clk310M;
   wire 	       locked_0;
   wire 	       locked_1;
   
   wire 	       reset125M;
   wire 	       reset200M;

   wire 	       init_calib_complete;
   wire 	       ui_clk;
   wire 	       ui_rst;

   wire [11:0] 	       device_temp;
  
   wire [31:0] 	       pEtherSend0_Data;
   wire 	       pEtherSend0_Request;
   wire 	       pEtherSend0_Ack;
   wire 	       pEtherSend0_Enable;

   wire 	       pEtherReceive_Data;
   wire 	       pEtherReceive_Request;
   wire 	       pEtherReceive_Ack;
   wire 	       pEtherReceive_Enable;
  
   wire [31:0] 	       pUdp0Send_Data;
   wire 	       pUdp0Send_Request;
   wire 	       pUdp0Send_Ack;
   wire 	       pUdp0Send_Enable;

   wire [31:0] 	       pUdp1Send_Data;
   wire 	       pUdp1Send_Request;
   wire 	       pUdp1Send_Ack;
   wire 	       pUdp1Send_Enable;

   // UDP rx output
   wire [31:0] 	       pUdp0Receive_Data;
   wire 	       pUdp0Receive_Request;
   wire 	       pUdp0Receive_Ack;
   wire 	       pUdp0Receive_Enable;

   wire [31:0] 	       pUdp1Receive_Data;
   wire 	       pUdp1Receive_Request;
   wire 	       pUdp1Receive_Ack;
   wire 	       pUdp1Receive_Enable;

   // MII interface
   wire [31:0] 	       pMIIInput_Data;
   wire 	       pMIIInput_Request;
   wire 	       pMIIInput_Ack;
   wire 	       pMIIInput_Enable;

   wire [31:0] 	       pMIIOutput_Data;
   wire 	       pMIIOutput_Request;
   wire 	       pMIIOutput_Ack;
   wire 	       pMIIOutput_Enable;

   wire [15:0] 	       status_phy;

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

   wire [0:0] 			     probe0;
   wire [58:0] 			     probe1;
   wire [58:0] 			     probe2;
   wire [38:0] 			     probe3;
   wire [7:0] 			     probe4;
   wire [40:0] 			     probe5;
   wire [32:0] 			     probe6;

   wire [32+4-1:0] 		     vio_data_in;  // data + strb
   wire 			     vio_data_we;
   wire [32+8-1:0] 		     vio_ctrl_in; // len + addr
   wire 			     vio_ctrl_we;

   wire 			     vio_kick;
   wire 			     vio_busy;
   wire [31:0] 			     vio_read_num;
   wire [31:0] 			     vio_read_addr;
      
   wire [31:0] 			     buf_dout;
   wire 			     buf_we;

   reg 				     vio_data_we_d;
   reg 				     vio_data_we_trig;
   reg 				     vio_ctrl_we_d;
   reg 				     vio_ctrl_we_trig;
   reg 				     vio_kick_d;
   reg 				     vio_kick_trig;
   
   assign GPIO32 = 1'b0;
   assign GPIO33 = 1'b0;
   assign GPIO34 = 1'b0;
   assign GPIO35 = 1'b0;

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

   assign HDMI0_D0_P = 1'b0;
   assign HDMI0_D0_N = 1'b0;
   assign HDMI0_D1_P = 1'b0;
   assign HDMI0_D1_N = 1'b0;
   assign HDMI0_D2_P = 1'b0;
   assign HDMI0_D2_N = 1'b0;
   assign HDMI0_SCL  = 1'b0;
   assign HDMI0_SDA  = 1'b0;
   assign HDMI0_CLK_P = 1'b0;
   assign HDMI0_CLK_N = 1'b0;
  
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
	     .GEPHY_RST_N(),
	     .GEPHY_MAC_CLK(clk125M),
	     .GEPHY_MAC_CLK90(clk125M_90),
	     // TX out
	     .GEPHY_TD     (GEPHY_TD),
	     .GEPHY_TXEN_ER(GEPHY_TXEN_ER),
	     .GEPHY_TCK    (GEPHY_TCK),
	     // RX in
	     .GEPHY_RD     (GEPHY_RD),
	     .GEPHY_RCK    (GEPHY_RCK),
	     .GEPHY_RXDV_ER(GEPHY_RXDV_ER),
	     
	     .GEPHY_MDC    (GEPHY_MDC),
	     .GEPHY_MDIO   (GEPHY_MDIO),
	     .GEPHY_INT_N  (GEPHY_INT_N),
	     
	     // Asynchronous Reset
	     .Reset_n       (~reset125M),
      
	     // UPL interface
	     .pUPLGlobalClk(ui_clk),
	     
	     // UDP tx input
	     .pUdp0Send_Data      (pUdp0Send_Data),
	     .pUdp0Send_Request   (pUdp0Send_Request),
	     .pUdp0Send_Ack       (pUdp0Send_Ack),
	     .pUdp0Send_Enable    (pUdp0Send_Enable),
	     
	     .pUdp1Send_Data      (pUdp1Send_Data),
	     .pUdp1Send_Request   (pUdp1Send_Request),
	     .pUdp1Send_Ack       (pUdp1Send_Ack),
	     .pUdp1Send_Enable    (pUdp1Send_Enable),
	     
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
	     .pMIIInput_Data      (pMIIInput_Data),
	     .pMIIInput_Request   (pMIIInput_Request),
	     .pMIIInput_Ack       (pMIIInput_Ack),
	     .pMIIInput_Enable    (pMIIInput_Enable),
	     
	     .pMIIOutput_Data     (pMIIOutput_Data),
	     .pMIIOutput_Request  (pMIIOutput_Request),
	     .pMIIOutput_Ack      (pMIIOutput_Ack),
	     .pMIIOutput_Enable   (pMIIOutput_Enable),
	     
	     // Setup
	     .pMyIpAddr      (32'h0a000003),
	     .pMyMacAddr     (48'h001b1affffff),
	     .pMyNetmask     (32'hff000000),
	     .pDefaultGateway(32'h0a0000fe),
	     .pTargetIPAddr  (32'h0a000001),
	     .pMyUdpPort0    (16'h4000),
	     .pMyUdpPort1    (16'h4001),
	     .pPHYAddr       (5'b00001),
	     .pPHYMode       (4'b1000),
	     .pConfig_Core   (8'h00000000),
	     
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

   assign pUdp0Send_Data    = pUdp0Receive_Data;
   assign pUdp0Send_Request = pUdp0Receive_Request;
   assign pUdp0Receive_Ack  = pUdp0Send_Ack;
   assign pUdp0Send_Enable  = pUdp0Receive_Enable;

   assign pUdp1Send_Data    = pUdp1Receive_Data;
   assign pUdp1Send_Request = pUdp1Receive_Request;
   assign pUdp1Receive_Ack  = pUdp1Send_Ack;
   assign pUdp1Send_Enable  = pUdp1Receive_Enable;

   assign pMIIInput_Data    = 32'h00000000;
   assign pMIIInput_Request = 1'b0;
   assign pMIIInput_Enable  = 1'b0;

   assign pMIIOutput_Ack = 1'b1;

    wire [31:0] fifo_to_axi4m_data_in;
    wire fifo_to_axi4m_data_we;
    wire [31:0] fifo_to_axi4m_ctrl_in;
    wire fifo_to_axi4m_ctrl_we;
    wire fifo_to_axi4m_data_full;
    wire fifo_to_axi4m_ctrl_full;

   fifo_to_axi4m u_fifo_to_axi4m(.clk(ui_clk),
				 .reset(ui_rst),

				 .data_in(fifo_to_axi4m_data_in),
				 .data_we(fifo_to_axi4m_data_we),
				 .data_in_full(fifo_to_axi4m_data_full),
				 .ctrl_in(fifo_to_axi4m_ctrl_in),
				 .ctrl_we(fifo_to_axi4m_ctrl_we),
				 .ctrl_in_full(fifo_to_axi4m_ctrl_full),

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
		   
		   .kick(vio_kick_trig),
		   .busy(vio_busy),
		   .read_num(vio_read_num),
		   .read_addr(vio_read_addr),
		   
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

    wire dlyctrl_rdy_out;
    wire rxbyteclkhs;
    wire system_rst_out;
    wire csirxss_csi_irq;

    wire [7:0] csirxss_s_axi_araddr;
    wire csirxss_s_axi_arready;
    wire csirxss_s_axi_arvalid;
    wire [7:0] csirxss_s_axi_awaddr;
    wire csirxss_s_axi_awready;
    wire csirxss_s_axi_awvalid;
    wire csirxss_s_axi_bready;
    wire csirxss_s_axi_bresp;
    wire csirxss_s_axi_bvalid;
    wire [31:0] csirxss_s_axi_rdata;
    wire csirxss_s_axi_rready;
    wire csirxss_s_axi_rresp;
    wire csirxss_s_axi_rvalid;
    wire [31:0] csirxss_s_axi_wdata;
    wire csirxss_s_axi_wready;
    wire [3:0] csirxss_s_axi_wstrb;
    wire csirxss_s_axi_wvalid;

    wire [39:0] video_out_tdata;
    wire [9:0] video_out_tdest;
    wire video_out_tlast;
    wire video_out_tready;
    wire [0:0] video_out_tuser;
    wire video_out_tvalid;

    mipi_csi2_rx_subsystem_0 mipi_rx_i(
				       .lite_aclk(clk125M),
				       .lite_aresetn(~reset125M),
				       .dphy_clk_200M(clk200M),
				       .dlyctrl_rdy_out(dlyctrl_rdy_out),
				       .rxbyteclkhs(rxbyteclkhs),
				       .system_rst_out(system_rst_out),
				       .csirxss_csi_irq(csirxss_csi_irq),
				       .video_aclk(clk200M),
				       .video_aresetn(~reset200M),
				       .csirxss_s_axi_araddr(csirxss_s_axi_araddr),
				       .csirxss_s_axi_arready(csirxss_s_axi_arready),
				       .csirxss_s_axi_arvalid(csirxss_s_axi_arvalid),
				       .csirxss_s_axi_awaddr(csirxss_s_axi_awaddr),
				       .csirxss_s_axi_awready(csirxss_s_axi_awready),
				       .csirxss_s_axi_awvalid(csirxss_s_axi_awvalid),
				       .csirxss_s_axi_bready(csirxss_s_axi_bready),
				       .csirxss_s_axi_bresp(csirxss_s_axi_bresp),
				       .csirxss_s_axi_bvalid(csirxss_s_axi_bvalid),
				       .csirxss_s_axi_rdata(csirxss_s_axi_rdata),
				       .csirxss_s_axi_rready(csirxss_s_axi_rready),
				       .csirxss_s_axi_rresp(csirxss_s_axi_rresp),
				       .csirxss_s_axi_rvalid(csirxss_s_axi_rvalid),
				       .csirxss_s_axi_wdata(csirxss_s_axi_wdata),
				       .csirxss_s_axi_wready(csirxss_s_axi_wready),
				       .csirxss_s_axi_wstrb(csirxss_s_axi_wstrb),
				       .csirxss_s_axi_wvalid(csirxss_s_axi_wvalid),
				       .video_out_tdata(video_out_tdata),
				       .video_out_tdest(video_out_tdest),
				       .video_out_tlast(video_out_tlast),
				       .video_out_tready(video_out_tready),
				       .video_out_tuser(video_out_tuser),
				       .video_out_tvalid(video_out_tvalid),

				       .mipi_phy_if_clk_hs_n(MIPI1_CLK_N),
				       .mipi_phy_if_clk_hs_p(MIPI1_CLK_P),
				       .mipi_phy_if_clk_lp_n(MIPI1_LP_CLK_N),
				       .mipi_phy_if_clk_lp_p(MIPI1_LP_CLK_P),
				       .mipi_phy_if_data_hs_n({MIPI1_LANE1_N, MIPI1_LANE0_N}),
				       .mipi_phy_if_data_hs_p({MIPI1_LANE1_P, MIPI1_LANE0_P}),
				       .mipi_phy_if_data_lp_n({MIPI1_LP_LANE1_N, MIPI1_LP_LANE0_N}),
				       .mipi_phy_if_data_lp_p({MIPI1_LP_LANE1_P, MIPI1_LP_LANE0_P})
				       );

    reg sccb1_init_req;
    wire sccb1_init_done, sccb1_init_err, sccb1_init_busy;
    wire [7:0] sccb1_debug;
    wire mipi1_sda_i, mipi1_sda_o, mipi1_sda_t;
    wire sccb1_time_1ms = 1'b1;
    wire sccb1_set_mode = 2'b00;

    init_sccb_top MIPI_SCCB1(.pClk(clk125M),
			     .pReset(reset125M),
			     .time_1ms(sccb1_time_1ms),
			     .set_mode(sccb1_set_mode),
			     .init_req(sccb1_init_req),
			     .init_done(sccb1_init_done),
			     .init_err(sccb1_init_err),
			     .I2CIO_BUSY(sccb1_init_busy),
			     .I2CIO_SIC(MIPI1_SCL),
			     .I2CIO_SID_I(mipi1_sda_i),
			     .I2CIO_SID_O(mipi1_sda_o),
			     .I2CIO_SID_D(mipi1_sda_t),
			     .debug(sccb1_debug)
			     );
  
    reg sccb2_init_req;
    wire sccb2_init_done, sccb2_init_err, sccb2_init_busy;
    wire [7:0] sccb2_debug;
    wire mipi2_sda_i, mipi2_sda_o, mipi2_sda_t;
    wire sccb2_time_1ms = 1'b1;
    wire sccb2_set_mode = 2'b00;

    init_sccb_top MIPI_SCCB2(.pClk(clk125M),
			     .pReset(reset125M),
			     .time_1ms(sccb2_time_1ms),
			     .set_mode(sccb2_set_mode),
			     .init_req(sccb2_init_req),
			     .init_done(sccb2_init_done),
			     .init_err(sccb2_init_err),
			     .I2CIO_BUSY(sccb2_init_busy),
			     .I2CIO_SIC(MIPI2_SCL),
			     .I2CIO_SID_I(mipi2_sda_i),
			     .I2CIO_SID_O(mipi2_sda_o),
			     .I2CIO_SID_D(mipi2_sda_t),
			     .debug(sccb2_debug)
			     );

    // A logic High on the T pin disables the output buffer
    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_mipi1_sda(.O(mipi1_sda_i), .IO(MIPI1_SDA), .I(mipi1_sda_o), .T(mipi1_sda_t));
  
    // A logic High on the T pin disables the output buffer
    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_mipi2_sda(.O(mipi2_sda_i), .IO(MIPI2_SDA), .I(mipi2_sda_o), .T(mipi2_sda_t));

    reg [31:0] sccb_state;

    always @(posedge clk125M) begin
	if(reset125M == 1) begin
            sccb_state     <= 0;
            sccb1_init_req <= 0;
            sccb2_init_req <= 0;
            MIPI1_PWUP     <= 0;
            MIPI2_PWUP     <= 0;
	end else begin
            case(sccb_state)
		125000 : begin // 1ms
		    MIPI1_PWUP <= 1;
		    MIPI2_PWUP <= 1;
		    sccb_state <= sccb_state + 1;
		end
		250000 : begin // 2ms
		    sccb1_init_req <= 1;
		    sccb2_init_req <= 1;
		    sccb_state <= sccb_state + 1;
		end
		250001 : begin
		    sccb1_init_req <= 0;
		    sccb2_init_req <= 0;
		    if(sccb1_init_done == 1) begin
			sccb_state <= sccb_state + 1;
		    end
		end
		250002 : begin
		end
		default: begin
		    sccb_state <= sccb_state + 1;
		end
	    endcase // case (sccb_state)
        end
    end

    wire rgb_out_tready;
    wire [31:0] rgb_out_tdata;
    wire rgb_out_tvalid;
    wire rgb_out_tuser;
    wire rgb_out_tlast;

    AXI_BayerToRGB#(.kAXI_InputDataWidth(40),
		    .kBayerWidth(10),
		    .kAXI_OutputDataWidth(32),
		    .kMaxSamplesPerClock(4))
    AXI_BayerToRGB_i(.axis_aclk(clk200M),
		     .axis_aresetn(~reset200M),
		     .s_axis_video_tready(video_out_tready),
		     .s_axis_video_tdata(video_out_tdata),
		     .s_axis_video_tvalid(video_out_tvalid),
		     .s_axis_video_tuser(video_out_tuser),
		     .s_axis_video_tlast(video_out_tlast),
	  
		     .m_axis_video_tready(rgb_out_tready),
		     .m_axis_video_tdata(rgb_out_tdata),
		     .m_axis_video_tvalid(rgb_out_tvalid),
		     .m_axis_video_tuser(rgb_out_tuser),
		     .m_axis_video_tlast(rgb_out_tlast)
		     );

    reg gamma_correction_tready = 1'b1;
    wire [23:0] gamma_correction_tdata;
    wire gamma_correction_tvalid;
    wire gamma_correction_tuser;
    wire gamma_correction_tlast;

    wire [2:0]  gamma_correction_awaddr;
    wire [2:0]  gamma_correction_awprot;
    reg         gamma_correction_awvalid = 0;
    wire        gamma_correction_awready;
    wire [31:0] gamma_correction_wdata;
    wire [3:0]  gamma_correction_wstrb;
    wire        gamma_correction_wvalid;
    wire        gamma_correction_wready;
    wire [1:0]  gamma_correction_bresp;
    wire        gamma_correction_bvalid;
    reg         gamma_correction_bready = 1;
    wire [2:0]  gamma_correction_araddr;
    wire        gamma_correction_arprot;
    reg         gamma_correction_arvalid = 0;
    wire        gamma_correction_arready;
    wire [31:0] gamma_correction_rdata;
    wire        gamma_correction_rresp;
    wire        gamma_correction_rvalid;
    reg         gamma_correction_rready = 1;

    AXI_GammaCorrection#(.kAXI_InputDataWidth(32),
			 .kAXI_OutputDataWidth(24),
			 .C_S_AXI_DATA_WIDTH(32),
			 .C_S_AXI_ADDR_WIDTH(3))
    AXI_GammaCorrection_i(.axis_aclk(clk200M),
			  .axis_aresetn(~reset200M),
			  
			  .s_axis_video_tready(rgb_out_tready),
			  .s_axis_video_tdata(rgb_out_tdata),
			  .s_axis_video_tvalid(rgb_out_tvalid),
			  .s_axis_video_tuser(rgb_out_tuser),
			  .s_axis_video_tlast(rgb_out_tlast),
			  .m_axis_video_tready(gamma_correction_tready),
			  .m_axis_video_tdata(gamma_correction_tdata),
			  .m_axis_video_tvalid(gamma_correction_tvalid),
			  .m_axis_video_tuser(gamma_correction_tuser),
			  .m_axis_video_tlast(gamma_correction_tlast),

			  .axi_lite_aclk(clk200M),
			  .axi_lite_aresetn(~reset200M),
			  .S_AXI_AWADDR(gamma_correction_awaddr),
			  .S_AXI_AWPROT(gamma_correction_awprot),
			  .S_AXI_AWVALID(gamma_correction_awvalid),
			  .S_AXI_AWREADY(gamma_correction_awready),
			  .S_AXI_WDATA(gamma_correction_wdata),
			  .S_AXI_WSTRB(gamma_correction_wstrb),
			  .S_AXI_WVALID(gamma_correction_wvalid),
			  .S_AXI_WREADY(gamma_correction_wready),
			  .S_AXI_BRESP(gamma_correction_bresp),
			  .S_AXI_BVALID(gamma_correction_bvalid),
			  .S_AXI_BREADY(gamma_correction_bready),
			  .S_AXI_ARADDR(gamma_correction_araddr),
			  .S_AXI_ARPROT(gamma_correction_arprot),
			  .S_AXI_ARVALID(gamma_correction_arvalid),
			  .S_AXI_ARREADY(gamma_correction_arready),
			  .S_AXI_RDATA(gamma_correction_rdata),
			  .S_AXI_RRESP(gamma_correction_rresp),
			  .S_AXI_RVALID(gamma_correction_rvalid),
			  .S_AXI_RREADY(gamma_correction_rready)
			  );

  
   assign probe0[0] = init_calib_complete;
   assign probe1 = {s_axi_awid, s_axi_awaddr, s_axi_awlen, s_axi_awsize,
		    s_axi_awburst, s_axi_awlock, s_axi_awcache, s_axi_awprot,
		    s_axi_awvalid, s_axi_awready};
   assign probe2 = {s_axi_arid, s_axi_araddr, s_axi_arlen, s_axi_awsize,
		    s_axi_arburst, s_axi_arlock, s_axi_arcache, s_axi_awprot,
		    s_axi_arvalid, s_axi_arready};
   assign probe3 = {s_axi_wdata, s_axi_wstrb, s_axi_wlast,
		    s_axi_wvalid, s_axi_wready};
   assign probe4 = {s_axi_bready, s_axi_bid, s_axi_bresp, s_axi_bvalid};
   assign probe5 = {s_axi_rready, s_axi_rid, s_axi_rdata,
		    s_axi_rresp, s_axi_rlast, s_axi_rvalid};
   assign probe6 = {buf_we, buf_dout};
  
   ila_0 u_ila_0(.clk(ui_clk),
		 .probe0(probe0),
		 .probe1(probe1),
		 .probe2(probe2),
		 .probe3(probe3),
		 .probe4(probe4),
		 .probe5(probe5),
		 .probe6(probe6)
		 );

    ila_1 u_ila_1(.clk(clk200M),
		  .probe0(video_out_tdata),
		  .probe1(video_out_tdest),
		  .probe2({video_out_tlast, video_out_tuser[0], video_out_tvalid}),
		  .probe3({gamma_correction_tlast, gamma_correction_tuser, gamma_correction_tvalid, gamma_correction_tready}),
		  .probe4(gamma_correction_tdata)
		  );
    
    ila_2 u_ila_2(.clk(clk125M),
		  .probe0(sccb_state),
		  .probe1({sccb1_init_done, sccb1_init_err, sccb1_init_busy, sccb1_debug})
		  );

   always @(posedge ui_clk) begin
      vio_data_we_d <= vio_data_we;
      if(vio_data_we_d == 1'b0 && vio_data_we == 1'b1)
        vio_data_we_trig <= 1'b1;
      else
        vio_data_we_trig <= 1'b0;
      
      vio_ctrl_we_d <= vio_ctrl_we;
      if(vio_ctrl_we_d == 1'b0 && vio_ctrl_we == 1'b1)
        vio_ctrl_we_trig <= 1'b1;
      else
        vio_ctrl_we_trig <= 1'b0;
      
      vio_kick_d <= vio_kick;
      if(vio_kick_d == 1'b0 && vio_kick == 1'b1)
        vio_kick_trig <= 1'b1;
      else
        vio_kick_trig <= 1'b0;
   end

    wire [0:0] vio_user;
    reg [0:0] vio_user_d;
    reg [31:0] user_data_in;
    reg user_data_we;
    reg [31:0] user_ctrl_in;
    reg user_ctrl_we;

   vio_0 u_vio_0(.clk(ui_clk),
		 .probe_in0(vio_busy),
		 .probe_out0(vio_data_in),
		 .probe_out1(vio_data_we),
		 .probe_out2(vio_ctrl_in),
		 .probe_out3(vio_ctrl_we),
		 .probe_out4(vio_kick),
		 .probe_out5(vio_read_num),
		 .probe_out6(vio_read_addr),
		 .probe_out7(vio_user));

    assign fifo_to_axi4m_data_in = user_data_we == 1 ? user_data_in : vio_data_in;
    assign fifo_to_axi4m_data_we = user_data_we | vio_data_we_trig;
    assign fifo_to_axi4m_ctrl_in = user_ctrl_we == 1 ? user_ctrl_in : vio_ctrl_in;
    assign fifo_to_axi4m_ctrl_we = user_ctrl_we | vio_ctrl_we_trig;

    reg [7:0] user_state_counter;
    reg [31:0] user_x_counter;
    reg [31:0] user_y_counter;
    reg [31:0] user_p_counter;
    always @(posedge ui_clk) begin
	if(ui_rst == 1) begin
	    user_state_counter <= 0;
	    user_data_we <= 0;
	    user_ctrl_we <= 0;
	    vio_user_d <= 0;
	    user_x_counter <= 0;
	    user_y_counter <= 0;
	    user_p_counter <= 0;
	end else begin
	    vio_user_d <= vio_user;
	    case(user_state_counter)
		0: begin
		    if(vio_user_d[0] == 0 && vio_user[0] == 1) begin
			user_state_counter <= user_state_counter + 1;
			user_p_counter <= 0;
		    end
		    user_data_we <= 0;
		    user_ctrl_we <= 0;
		end
		1: begin
		    if(fifo_to_axi4m_data_full == 0) begin
			if(user_p_counter + 1 == 64) begin
			    user_state_counter <= user_state_counter + 1;
			    user_p_counter <= 0;
			end else begin
			    user_p_counter <= user_p_counter + 1;
			end
			user_data_we <= 1;
			user_data_in <= 32'hFFFFFFFF;
		    end else begin
			user_data_we <= 0;
		    end
		    user_ctrl_we <= 0;
		end
		2: begin
		    user_data_we <= 0;
		    if(fifo_to_axi4m_ctrl_full == 0) begin
			user_ctrl_we <= 1;
			user_ctrl_in <= {8'd64, {10'd0, user_y_counter[7:0], user_x_counter[7:0], 6'd0}};
			if(user_x_counter + 1 == 256) begin
			    if(user_y_counter + 1 == 256) begin
				user_state_counter <= user_state_counter + 1;
			    end else begin
				user_state_counter <= 1;
				user_x_counter <= 0;
				user_y_counter <= user_y_counter + 1;
			    end
			end else begin
			    user_state_counter <= 1;
			    user_x_counter <= user_x_counter + 1;
			end
		    end else begin
			user_ctrl_we <= 0;
		    end
		end
		default: begin
		    user_state_counter <= 0;
		end
	    endcase // case (user_state_counter)
	end
    end

    wire axi4lite_kick;
    wire axi4lite_busy;
    wire axi4lite_we;
    wire [31:0] axi4lite_addr;
    wire [31:0] axi4lite_din;
    wire axi4lite_valid;
    wire [31:0] axi4lite_q;

    axi4_lite_reader axi4_lite_reader_i(
					.clk(clk125M),
					.reset(reset125M),
			
					.kick(axi4lite_kick),
					.busy(axi4lite_busy),
					.we(axi4lite_we),
					.addr(axi4lite_addr),
					.din(axi4lite_din),
					.valid(axi4lite_valid),
					.q(axi4lite_q),

					.m_axi_araddr(csirxss_s_axi_araddr[7:0]),
					.m_axi_arready(csirxss_s_axi_arready),
					.m_axi_arvalid(csirxss_s_axi_arvalid),
					.m_axi_awaddr(csirxss_s_axi_awaddr[7:0]),
					.m_axi_awready(csirxss_s_axi_awready),
					.m_axi_awvalid(csirxss_s_axi_awvalid),
					.m_axi_bready(csirxss_s_axi_bready),
					.m_axi_bresp(csirxss_s_axi_bresp),
					.m_axi_bvalid(csirxss_s_axi_bvalid),
					.m_axi_rdata(csirxss_s_axi_rdata),
					.m_axi_rready(csirxss_s_axi_rready),
					.m_axi_rresp(csirxss_s_axi_rresp),
					.m_axi_rvalid(csirxss_s_axi_rvalid),
					.m_axi_wdata(csirxss_s_axi_wdata),
					.m_axi_wready(csirxss_s_axi_wready),
					.m_axi_wstrb(csirxss_s_axi_wstrb),
					.m_axi_wvalid(csirxss_s_axi_wvalid));

   vio_1 u_vio_1(.clk(clk125M),
		 .probe_in0(axi4lite_busy),
		 .probe_in1(axi4lite_valid),
		 .probe_in2(axi4lite_q),
		 .probe_out0(axi4lite_kick),
		 .probe_out1(axi4lite_we),
		 .probe_out2(axi4lite_addr),
		 .probe_out3(axi4lite_din)
		 );

    ila_3 u_ila_3(.clk(clk125M),
		  .probe0({csirxss_s_axi_araddr, csirxss_s_axi_arvalid, csirxss_s_axi_arready}),
		  .probe1({csirxss_s_axi_awaddr, csirxss_s_axi_awvalid, csirxss_s_axi_awready}),
		  .probe2({csirxss_s_axi_bready, csirxss_s_axi_bresp, csirxss_s_axi_bvalid}),
		  .probe3({csirxss_s_axi_rdata, csirxss_s_axi_rready, csirxss_s_axi_rresp, csirxss_s_axi_rvalid}),
		  .probe4({csirxss_s_axi_wdata, csirxss_s_axi_wready, csirxss_s_axi_wstrb, csirxss_s_axi_wvalid})
		  );

endmodule // top

`default_nettype wire
