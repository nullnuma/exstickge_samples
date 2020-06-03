module grayscale_hls_wrapper(
	input wire CLK,
	input wire RST,

	input wire [11:0] POSX,
	input wire [11:0] POSY,
	input wire READY,

	output wire RDEN,
	input wire [7:0] IN_R,
	input wire [7:0] IN_G,
	input wire [7:0] IN_B,

	output wire WREN, 
	output wire [7:0] OUT_R,
	output wire [7:0] OUT_G,
	output wire [7:0] OUT_B
);
	wire [31:0] out_tmp;

	assign OUT_R = out_tmp[15:8];
	assign OUT_G = out_tmp[15:8];
	assign OUT_B = out_tmp[15:8];

	grayscale_hls u_grayscale_hls(
		.ap_clk(CLK),
		.ap_rst(RST),
		.ap_start(READY),
		.ap_idle(AP_IDLE),
		.ap_ready(AP_READY),
		//Input
		.r_dout({24'h0,IN_R}),
		.g_dout({24'h0,IN_G}),
		.b_dout({24'h0,IN_B}),
		.r_empty_n(1'b1),
		.g_empty_n(1'b1),
		.b_empty_n(1'b1),
		.r_read(RDEN),
		//Output
		.sink_din(out_tmp),
		.sink_full_n(1'b1),
		.sink_write(WREN)
	);

endmodule