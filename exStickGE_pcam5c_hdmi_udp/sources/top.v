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
	    inout wire 	       GPIO26,
	    inout wire 	       GPIO27,
	    inout wire 	       GPIO30,
	    inout wire 	       GPIO31,
	    //inout wire 	       GPIO32,
	    //inout wire 	       GPIO33,
	    inout wire 	       GPIO34,
	    inout wire 	       GPIO35,

	    inout wire 	       GPIO44,
	    inout wire 	       GPIO45,
	    inout wire 	       GPIO46,
	    inout wire 	       GPIO47,
	    inout wire 	       GPIO50,
	    inout wire 	       GPIO51,
	    inout wire 	       GPIO52,
	    inout wire 	       GPIO53,

	    inout wire 	       GPIO66,
	    inout wire 	       GPIO67,
	    inout wire 	       GPIO70,
	    inout wire 	       GPIO71,
	    inout wire 	       GPIO72,
	    inout wire 	       GPIO73,
	    inout wire 	       GPIO74,
	    inout wire 	       GPIO75,

	    input wire			HDMI0_D0_P,
	    input wire			HDMI0_D0_N,
	    input wire			HDMI0_D1_P,
	    input wire			HDMI0_D1_N,
	    input wire			HDMI0_D2_P,
	    input wire			HDMI0_D2_N,
	    inout wire			HDMI0_SCL,
	    inout wire			HDMI0_SDA,
	    input wire			HDMI0_CLK_P,
	    input wire			HDMI0_CLK_N,
		output wire			HDMI0_HPD,
		output wire			HDMI0_OUT_EN,

	    output wire			HDMI1_D0_P,
	    output wire			HDMI1_D0_N,
	    output wire			HDMI1_D1_P,
	    output wire			HDMI1_D1_N,
	    output wire			HDMI1_D2_P,
	    output wire			HDMI1_D2_N,
	    output wire			HDMI1_SCL,
	    inout wire			HDMI1_SDA,
	    output wire			HDMI1_CLK_P,
	    output wire			HDMI1_CLK_N,

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

	    input wire MIPI2_LP_LANE0_P,
	    input wire MIPI2_LP_LANE0_N,
	    input wire MIPI2_LP_LANE1_P,
	    input wire MIPI2_LP_LANE1_N,
	    input wire MIPI2_LP_CLK_P,
	    input wire MIPI2_LP_CLK_N,

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

	localparam USE_900P = 1;

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

	
	wire [C_S_AXI_ID_WIDTH-1:0]       m0_axi_awid;
	wire [C_S_AXI_ADDR_WIDTH-1:0]     m0_axi_awaddr;
	wire [7:0]				m0_axi_awlen;
	wire [2:0]				m0_axi_awsize;
	wire [1:0]				m0_axi_awburst;
	wire [0:0]				m0_axi_awlock;
	wire [3:0]				m0_axi_awcache;
	wire [2:0]				m0_axi_awprot;
	wire				m0_axi_awvalid;
	wire				m0_axi_awready;
	wire [C_S_AXI_DATA_WIDTH-1:0]     m0_axi_wdata;
	wire [(C_S_AXI_DATA_WIDTH/8)-1:0] m0_axi_wstrb;
	wire				m0_axi_wlast;
	wire				m0_axi_wvalid;
	wire				m0_axi_wready;
	// Slave Interface Write Response Ports
	wire				m0_axi_bready;
	wire [C_S_AXI_ID_WIDTH-1:0] 	     m0_axi_bid;
	wire [1:0]				m0_axi_bresp;
	wire				m0_axi_bvalid;
	// Slave Interface Read Address Ports
	wire [C_S_AXI_ID_WIDTH-1:0] 	     m0_axi_arid;
	wire [C_S_AXI_ADDR_WIDTH-1:0]     m0_axi_araddr;
	wire [7:0]				m0_axi_arlen;
	wire [2:0]				m0_axi_arsize;
	wire [1:0]				m0_axi_arburst;
	wire [0:0]				m0_axi_arlock;
	wire [3:0]				m0_axi_arcache;
	wire [2:0]				m0_axi_arprot;
	wire				m0_axi_arvalid;
	wire				m0_axi_arready;
	// Slave Interface Read Data Ports
	wire				m0_axi_rready;
	wire [C_S_AXI_ID_WIDTH-1:0] 	     m0_axi_rid;
	wire [C_S_AXI_DATA_WIDTH-1:0]     m0_axi_rdata;
	wire [1:0]				m0_axi_rresp;
	wire				m0_axi_rlast;
	wire				m0_axi_rvalid;

//FIFO 1
	wire [C_S_AXI_ID_WIDTH-1:0]       m1_axi_awid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m1_axi_awaddr;
    wire [7:0]				m1_axi_awlen;
    wire [2:0]				m1_axi_awsize;
    wire [1:0]				m1_axi_awburst;
    wire [0:0]				m1_axi_awlock;
    wire [3:0]				m1_axi_awcache;
    wire [2:0]				m1_axi_awprot;
    wire				m1_axi_awvalid;
    wire				m1_axi_awready;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m1_axi_wdata;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] m1_axi_wstrb;
    wire				m1_axi_wlast;
    wire				m1_axi_wvalid;
    wire				m1_axi_wready;
    // Slave Interface Write Response Ports
    wire				m1_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m1_axi_bid;
    wire [1:0]				m1_axi_bresp;
    wire				m1_axi_bvalid;
    // Slave Interface Read Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m1_axi_arid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m1_axi_araddr;
    wire [7:0]				m1_axi_arlen;
    wire [2:0]				m1_axi_arsize;
    wire [1:0]				m1_axi_arburst;
    wire [0:0]				m1_axi_arlock;
    wire [3:0]				m1_axi_arcache;
    wire [2:0]				m1_axi_arprot;
    wire				m1_axi_arvalid;
    wire				m1_axi_arready;
    // Slave Interface Read Data Ports
    wire				m1_axi_rready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m1_axi_rid;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m1_axi_rdata;
    wire [1:0]				m1_axi_rresp;
    wire				m1_axi_rlast;
    wire				m1_axi_rvalid;

//FIFO 2
	wire [C_S_AXI_ID_WIDTH-1:0]       m2_axi_awid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m2_axi_awaddr;
    wire [7:0]				m2_axi_awlen;
    wire [2:0]				m2_axi_awsize;
    wire [1:0]				m2_axi_awburst;
    wire [0:0]				m2_axi_awlock;
    wire [3:0]				m2_axi_awcache;
    wire [2:0]				m2_axi_awprot;
    wire				m2_axi_awvalid;
    wire				m2_axi_awready;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m2_axi_wdata;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] m2_axi_wstrb;
    wire				m2_axi_wlast;
    wire				m2_axi_wvalid;
    wire				m2_axi_wready;
    // Slave Interface Write Response Ports
    wire				m2_axi_bready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m2_axi_bid;
    wire [1:0]				m2_axi_bresp;
    wire				m2_axi_bvalid;
    // Slave Interface Read Address Ports
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m2_axi_arid;
    wire [C_S_AXI_ADDR_WIDTH-1:0]     m2_axi_araddr;
    wire [7:0]				m2_axi_arlen;
    wire [2:0]				m2_axi_arsize;
    wire [1:0]				m2_axi_arburst;
    wire [0:0]				m2_axi_arlock;
    wire [3:0]				m2_axi_arcache;
    wire [2:0]				m2_axi_arprot;
    wire				m2_axi_arvalid;
    wire				m2_axi_arready;
    // Slave Interface Read Data Ports
    wire				m2_axi_rready;
    wire [C_S_AXI_ID_WIDTH-1:0] 	     m2_axi_rid;
    wire [C_S_AXI_DATA_WIDTH-1:0]     m2_axi_rdata;
    wire [1:0]				m2_axi_rresp;
    wire				m2_axi_rlast;
    wire				m2_axi_rvalid;



    wire [0:0] 			     probe0;
    wire [58:0] 		     probe1;
    wire [58:0] 		     probe2;
    wire [38:0] 		     probe3;
    wire [7:0] 			     probe4;
    wire [40:0] 		     probe5;
    wire [32:0] 		     probe6;

    wire [32+4-1:0] 		     vio_data_in;  // data + strb
    wire 			     vio_data_we;
    wire [32+8-1:0] 		     vio_ctrl_in; // len + addr
    wire 			     vio_ctrl_we;

    wire 			     vio_kick;
    wire 			     vio_busy;
    wire [31:0] 		     vio_read_num;
    wire [31:0] 		     vio_read_addr;
    
    wire [31:0] 		     buf_dout;
    wire 			     buf_we;

    reg 			     vio_data_we_d;
    reg 			     vio_data_we_trig;
    reg 			     vio_ctrl_we_d;
    reg 			     vio_ctrl_we_trig;
    reg 			     vio_kick_d;
    reg 			     vio_kick_trig;

//DVI
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
	wire [32+4-1:0]		data_in;// data + strb
	wire				data_we;
	wire [32+8-1:0]		ctrl_in;// len + addr
	wire				ctrl_we;

	wire				kick;
	wire				busy;
	wire [31:0]			read_num;
	wire [31:0]			read_addr;

//Pic Combine
	//PIP Data DRAM READ
	wire pip_kick;
	wire pip_busy;
	wire [31:0] pip_read_num;
	wire [31:0] pip_read_addr;
	wire [31:0] pip_buf_dout;
	wire pip_buf_we;
	//Background Data DRAM READ
	wire back_kick;
	wire back_busy;
	wire [31:0] back_read_num;
	wire [31:0] back_read_addr;
	wire [31:0] back_buf_dout;
	wire back_buf_we;
	//DRAM WRITE
	wire [32+4-1:0] combine_data_in;//strb[35:32] + data[31:0]
	wire combine_data_we;
	wire [32+8-1:0] combine_ctrl_in;//len[39:32] + addr[31:0]
	wire combine_ctrl_we;
    
    assign GPIO26 = 0;
    assign GPIO27 = 0;
    assign GPIO30 = 0;
    assign GPIO31 = 0;
    //assign GPIO32 = 0;
    //assign GPIO33 = 0;
    assign GPIO34 = 0;
    assign GPIO35 = 0;

    assign GPIO44 = 0;
    assign GPIO45 = 0;
    assign GPIO46 = 0;
    assign GPIO47 = 0;
    assign GPIO50 = 0;
    assign GPIO51 = 0;
    assign GPIO52 = 0;
    assign GPIO53 = 0;

    assign GPIO66 = 0;
    assign GPIO67 = 0;
    assign GPIO70 = 0;
    assign GPIO71 = 0;
    assign GPIO72 = 0;
    assign GPIO73 = 0;
    assign GPIO74 = 0;
    assign GPIO75 = 0;

    assign PMOD = 4'h0;
    
    assign LED0 = status_phy[0];
    assign LED1 = init_calib_complete;
    assign LED2 = pUdp0Receive_Enable || pUdp1Receive_Enable;

	assign HDMI0_OUT_EN = 1'b0;
	assign HDMI0_HPD = 1'b1;

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

// S0 R(udp_axi)		W(Pcam)
// S1 R(Combine_Pcam)	W(DVI)
// S2 R(Combine_DVI)	W(Combine)

	axi_interconnect_M1S3 u_axi_interconnect_M1S3(
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
	assign GEPHY_RST_N = locked_0 && sys_rst_n;
    
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

    // assign pUdp0Send_Data    = pUdp0Receive_Data;
    // assign pUdp0Send_Request = pUdp0Receive_Request;
    // assign pUdp0Receive_Ack  = pUdp0Send_Ack;
    // assign pUdp0Send_Enable  = pUdp0Receive_Enable;

    assign pUdp1Send_Data    = pUdp1Receive_Data;
    assign pUdp1Send_Request = pUdp1Receive_Request;
    assign pUdp1Receive_Ack  = pUdp1Send_Ack;
    assign pUdp1Send_Enable  = pUdp1Receive_Enable;

    assign pMIIInput_Data    = 32'h00000000;
    assign pMIIInput_Request = 1'b0;
    assign pMIIInput_Enable  = 1'b0;

    assign pMIIOutput_Ack = 1'b1;

    wire [32+4-1:0] fifo_to_axi4m_data_in;
    wire fifo_to_axi4m_data_we;
    wire [32+8-1:0] fifo_to_axi4m_ctrl_in;
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

    wire axi4m_to_fifo_kick, axi4m_to_fifo_busy;
    wire [31:0] axi4m_to_fifo_read_num;
    wire [31:0] axi4m_to_fifo_read_addr;
    
    axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
    u_axi4m_to_fifo(.clk(ui_clk),
		    .reset(ui_rst),
	
		    .kick(axi4m_to_fifo_kick),
		    .busy(axi4m_to_fifo_busy),
		    .read_num(axi4m_to_fifo_read_num),
		    .read_addr(axi4m_to_fifo_read_addr),
	
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
				       //.dlyctrl_rdy_out(dlyctrl_rdy_out),
				       .rxbyteclkhs(rxbyteclkhs),
				       .system_rst_out(system_rst_out),
				       .csirxss_csi_irq(csirxss_csi_irq),
				       .video_aclk(ui_clk),
				       .video_aresetn(~ui_rst),
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


    // A logic High on the T pin disables the output buffer
    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_mipi1_sda(.O(mipi1_sda_i), .IO(MIPI1_SDA), .I(mipi1_sda_o), .T(mipi1_sda_t));
    
    reg [31:0] sccb_state;

    always @(posedge clk125M) begin
	if(reset125M == 1) begin
            sccb_state     <= 0;
            sccb1_init_req <= 0;
            MIPI1_PWUP     <= 0;
	end else begin
            case(sccb_state)
		125000 : begin // 1ms
		    MIPI1_PWUP <= 1;
		    sccb_state <= sccb_state + 1;
		end
		250000 : begin // 2ms
		    sccb1_init_req <= 1;
		    sccb_state <= sccb_state + 1;
		end
		250001 : begin
		    sccb1_init_req <= 0;
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
    AXI_BayerToRGB_i(.axis_aclk(ui_clk),
		     .axis_aresetn(~ui_rst),
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


    wire gamma_correction_tready;
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
    AXI_GammaCorrection_i(.axis_aclk(ui_clk),
			  .axis_aresetn(~ui_rst),
	
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

			  .axi_lite_aclk(ui_clk),
			  .axi_lite_aresetn(~ui_rst),
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

    wire [32+4-1:0] user_data_in;
    wire user_data_we;
    wire [32+8-1:0] user_ctrl_in;
    wire user_ctrl_we;
    wire capture_sig;
    wire capture_rtn;
	reg capture_sig_dvi;
	wire capture_rtn_dvi;

    udp_axi udp_axi(
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
		    .kick(axi4m_to_fifo_kick),
		    .busy(axi4m_to_fifo_busy),
		    .read_num(axi4m_to_fifo_read_num),
		    .read_addr(axi4m_to_fifo_read_addr),
		    .buf_dout(buf_dout),
		    .buf_we(buf_we),
		    //Capture
		    .capture_sig(capture_sig),
		    .capture_rtn(capture_rtn)
		    );
    
    videoaxis2dram #(.WIDTH(32'd640)) u_videoaxis2dram
    (.clk(ui_clk),
		   .rst(ui_rst),
		   //DRAM WRITE
		   .data_in(user_data_in),
		   .data_we(user_data_we),
		   .ctrl_in(user_ctrl_in), //len[39:32] + addr[31:0]
		   .ctrl_we(user_ctrl_we),
		   //VIDEO
		   .vid_clk(ui_clk),
		   .s_axis_tuser(gamma_correction_tuser), // Start of Frame
		   .s_axis_tlast(gamma_correction_tlast), // End of Line
		   .s_axis_tvalid(gamma_correction_tvalid),
		   .s_axis_tdata(gamma_correction_tdata),
		   //.s_axis_tdata(24'h00FF00),
		   .s_axis_tready(gamma_correction_tready),
		   //Capture
		   .capture_sig(capture_sig),
		   .capture_rtn(capture_rtn)
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

    ila_1 u_ila_1(.clk(ui_clk),
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


    //
    // DVI RX/TX
    //
    rgb2dvi#(
		.kClkRange(2) // MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)
		)
    U_RGB2DVI(
		 // DVI 1.0 TMDS video interface
		 .TMDS_Clk_p(HDMI1_CLK_P),
		 .TMDS_Clk_n(HDMI1_CLK_N),
		 .TMDS_Data_p({HDMI1_D2_P, HDMI1_D1_P, HDMI1_D0_P}),
		 .TMDS_Data_n({HDMI1_D2_N, HDMI1_D1_N, HDMI1_D0_N}),

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
    RESET_RGB2DVI(.clk(rgb2dvi_pixel_clk), .reset_i(~dvi2rgb_clk_locked), .reset_o(rgb2dvi_reset));
    reset_counter#(.RESET_COUNT(100))
    DVI2RGB_RESET_COUNTER(.clk(dvi2rgb_pixel_clk), .reset_i(~dvi2rgb_clk_locked), .reset_o(dvi2rgb_reset));

    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_scl(.O(dvi2rgb_ddc_scl_i), .IO(HDMI0_SCL), .I(dvi2rgb_ddc_scl_o), .T(dvi2rgb_ddc_scl_t));

    IOBUF#(.DRIVE(12), .IOSTANDARD("DEFAULT"), .SLEW("SLOW"))
    i_sda(.O(dvi2rgb_ddc_sda_i), .IO(HDMI0_SDA), .I(dvi2rgb_ddc_sda_o), .T(dvi2rgb_ddc_sda_t));
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
		 .TMDS_Clk_p(HDMI0_CLK_P),
		 .TMDS_Clk_n(HDMI0_CLK_N),
		 .TMDS_Data_p({HDMI0_D2_P, HDMI0_D1_P, HDMI0_D0_P}),
		 .TMDS_Data_n({HDMI0_D2_N, HDMI0_D1_N, HDMI0_D0_N}),

		 // Auxiliary signals 
		 .RefClk(clk200M),
		 .aRst(reset200M),
		 .aRst_n(~reset200M),

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

		 .pRst(reset200M),
		 .pRst_n(~reset200M)
		 );

	reg [1:0] capture_rtn_edge;
	always @(posedge ui_clk) begin
		capture_rtn_edge <= {capture_rtn_edge[0], capture_rtn};
	end
	always @(posedge ui_clk) begin
		if(dvi2rgb_reset)
			capture_sig_dvi <= 1'b0;
		else if(capture_rtn_edge == 2'b10)
			capture_sig_dvi <= 1'b1;
		else if(capture_rtn_dvi == 1'b1)
			capture_sig_dvi <= 1'b0;
	end

	rgb2dram #(
		.USE_900P(USE_900P),
		.ADDR_OFFSET(32'h1000_000)
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
		.capture_sig(capture_sig_dvi),
		.capture_rtn(capture_rtn_dvi)
	);
	fifo_to_axi4m u_fifo_to_axi4m_div(
			.clk(dvi2rgb_pixel_clk),
			.reset(dvi2rgb_reset),

			.data_in(data_in),
			.data_we(data_we),
			.ctrl_in(ctrl_in),
			.ctrl_we(ctrl_we),

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

	reg [1:0] capture_rtn_dvi_edge;
	always @(posedge ui_clk) begin
		capture_rtn_dvi_edge <= {capture_rtn_dvi_edge[0],capture_rtn_dvi};
	end
//Pic Combine Process
	pic_combine #(
		.WRITE_BASE_ADDR(32'h0200_0000)
	) u_piccombine(
		.CLK(ui_clk),
		.RST(ui_rst),
		.START(capture_rtn_dvi_edge == 2'b10),
		//.END(),
		//PIP Read
		.pip_kick(pip_kick),
		.pip_busy(pip_busy),
		.pip_read_num(pip_read_num),
		.pip_read_addr(pip_read_addr),
		.pip_buf_dout(pip_buf_dout),
		.pip_buf_we(pip_buf_we),
		//Background Read
		.back_kick(back_kick),
		.back_busy(back_busy),
		.back_read_num(back_read_num),
		.back_read_addr(back_read_addr),
		.back_buf_dout(back_buf_dout),
		.back_buf_we(back_buf_we),
		//Write
		.data_in(combine_data_in),
		.data_we(combine_data_we),
		.ctrl_in(combine_ctrl_in),
		.ctrl_we(combine_ctrl_we)
	);


	axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
	u_axi4m_to_fifo_pip(
		.clk(ui_clk),
		.reset(ui_rst),

		.kick(pip_kick),
		.busy(pip_busy),
		.read_num(pip_read_num),
		.read_addr(pip_read_addr),

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

		.buf_dout(pip_buf_dout),
		.buf_we(pip_buf_we)
		);

	axi4m_to_fifo#(.C_M_AXI_ID_WIDTH(4), .C_M_AXI_ADDR_WIDTH(32), .C_M_AXI_DATA_WIDTH(32))
	u_axi4m_to_fifo_back(
		.clk(ui_clk),
		.reset(ui_rst),

		.kick(back_kick),
		.busy(back_busy),
		.read_num(back_read_num),
		.read_addr(back_read_addr),

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

		.buf_dout(back_buf_dout),
		.buf_we(back_buf_we)
		);

  fifo_to_axi4m u_fifo_combine_writer(
			.clk(ui_clk),
			.reset(ui_rst),

			.data_in(combine_data_in),
			.data_we(combine_data_we),
			.ctrl_in(combine_ctrl_in),
			.ctrl_we(combine_ctrl_we),

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

endmodule // top

`default_nettype wire
