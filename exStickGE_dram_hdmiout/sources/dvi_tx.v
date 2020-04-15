`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/02/27 21:06:20
// Design Name: 
// Module Name: dvi_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dvi_tx(
	input wire rst,
	input wire clk_vga,
	input wire clk_tx,

	input wire [7:0] d_red,
	input wire [7:0] d_green,
	input wire [7:0] d_blue,

	output wire framestart,
	output wire linestart,
	output wire prefetch_line,

	output wire hsync,
	output wire vsync,
	output wire de,

	output wire TMDS_CLOCK_N,
	output wire TMDS_CLOCK_P,
	output wire [2:0]TMDS_DATA_N,
	output wire [2:0]TMDS_DATA_P
);
	//CLOCK and RESET
	wire locked_sig;

	wire dvi_hblank_sig;
	wire dvi_vblank_sig;
	wire dvi_de_sig;
	wire [29:0]data_out;



	assign de = dvi_de_sig;


	syncgen gen (
		.video_clk(clk_vga),
		.reset(rst),
		.framestart(framestart),
		.linestart(linestart),
		.prefetch_line(prefetch_line),
		.hsync(hsync),
		.vsync(vsync),
		.hblank(dvi_hblank_sig),
		.vblank(dvi_vblank_sig)
	);

	assign dvi_de_sig = (!dvi_hblank_sig) && (!dvi_vblank_sig);

	rgb2tmds u_tmds(
		.reset(rst),
		.vga_clk_sig(clk_vga),

		.dvi_de	(dvi_de_sig),
		.dvi_blu(d_blue),
		.dvi_grn(d_green),
		.dvi_red(d_red),
		.dvi_hsync(hsync),
		.dvi_vsync(vsync),
		.dvi_ctl(4'b0000),
		.data_out(data_out)
	);

	dvi_transmitter sio(
		.data_out_from_device(data_out),
		.data_out_to_pins_p(TMDS_DATA_P),
		.data_out_to_pins_n(TMDS_DATA_N),
		.clk_to_pins_p(TMDS_CLOCK_P),
		.clk_to_pins_n(TMDS_CLOCK_N),
		.clk_in(clk_tx),
		.clk_div_in(clk_vga),
		.clk_reset(rst),
		.io_reset(rst)
	);
endmodule
