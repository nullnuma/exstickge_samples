module template(
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

endmodule