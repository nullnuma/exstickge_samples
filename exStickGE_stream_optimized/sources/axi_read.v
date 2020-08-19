module axi_read(
	input wire	CLK,
	input wire	RST,
	
	// Master Interface Read Address
	output wire [C_AXI_THREAD_ID_WIDTH-1:0]		AXI_ARID,
	output wire [C_AXI_ADDR_WIDTH-1:0]			AXI_ARADDR,
	output wire [8-1:0]							AXI_ARLEN,
	output wire [3-1:0]							AXI_ARSIZE,
	output wire [2-1:0]							AXI_ARBURST,
	output wire									AXI_ARLOCK,
	output wire [4-1:0]							AXI_ARCACHE,
	output wire [3-1:0]							AXI_ARPROT,
	output wire [4-1:0]							AXI_ARQOS,
	output wire									AXI_ARUSER,
	output wire									AXI_ARVALID,
	input  wire									AXI_ARREADY,
	// Master Interface Read Data
	input  wire [C_AXI_THREAD_ID_WIDTH-1:0]		AXI_RID,
	input  wire [C_AXI_DATA_WIDTH-1:0]			AXI_RDATA,
	input  wire [2-1:0]							AXI_RRESP,
	input  wire									AXI_RLAST,
	input  wire	[C_AXI_DATA_WIDTH/8-1:0]		AXI_RUSER,
	input  wire									AXI_RVALID,
	output wire									AXI_RREADY
);


endmodule