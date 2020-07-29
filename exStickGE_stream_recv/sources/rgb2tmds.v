module rgb2tmds #(
	parameter RESET_LEVEL = 1
)(
	reset,
	//Rise edge drive clock
	vga_clk_sig,

	dvi_de,
	dvi_blu,
	dvi_grn,
	dvi_red,
	dvi_hsync,
	dvi_vsync,
	dvi_ctl,

	data_out

);

	input wire reset;
	//Rise edge drive clock
	input wire vga_clk_sig;

	input wire dvi_de;
	input wire [7:0]dvi_blu;
	input wire [7:0]dvi_grn;
	input wire [7:0]dvi_red;
	input wire dvi_hsync;
	input wire dvi_vsync;
	input wire [3:0]dvi_ctl;

	wire [9:0]q_blu_sig;
	wire [9:0]q_grn_sig;
	wire [9:0]q_red_sig;

	tmds_encoder #(
		.RESET_LEVEL(RESET_LEVEL)
	) TMDS_B (
		.RESET(reset),
		.CK(vga_clk_sig),
		.DE(dvi_de),
		.C1(dvi_vsync),
		.C0(dvi_hsync),
		.D(dvi_blu),
		.Q(q_blu_sig)
	);
	tmds_encoder #(
		.RESET_LEVEL(RESET_LEVEL)
	) TMDS_G (
		.RESET(reset),
		.CK(vga_clk_sig),
		.DE(dvi_de),
		.C1(dvi_ctl[1]),
		.C0(dvi_ctl[0]),
		.D(dvi_grn),
		.Q(q_grn_sig)
	);
	tmds_encoder #(
		.RESET_LEVEL(RESET_LEVEL)
	) TMDS_R (
		.RESET(reset),
		.CK(vga_clk_sig),
		.DE(dvi_de),
		.C1(dvi_ctl[1]),
		.C0(dvi_ctl[0]),
		.D(dvi_red),
		.Q(q_red_sig)
	);


	output wire [29:0] data_out;
	assign data_out = {
		q_red_sig[9],
		q_grn_sig[9],
		q_blu_sig[9],
		q_red_sig[8],
		q_grn_sig[8],
		q_blu_sig[8],
		q_red_sig[7],
		q_grn_sig[7],
		q_blu_sig[7],
		q_red_sig[6],
		q_grn_sig[6],
		q_blu_sig[6],
		q_red_sig[5],
		q_grn_sig[5],
		q_blu_sig[5],
		q_red_sig[4],
		q_grn_sig[4],
		q_blu_sig[4],
		q_red_sig[3],
		q_grn_sig[3],
		q_blu_sig[3],
		q_red_sig[2],
		q_grn_sig[2],
		q_blu_sig[2],
		q_red_sig[1],
		q_grn_sig[1],
		q_blu_sig[1],
		q_red_sig[0],
		q_grn_sig[0],
		q_blu_sig[0]
	};

endmodule