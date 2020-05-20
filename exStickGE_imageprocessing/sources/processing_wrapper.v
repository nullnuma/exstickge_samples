module processing_wrapper(
	input wire CLK,
	input wire RST,

	(* mark_debug = "true" *)input wire READ_LINE_DONE,
	input wire [11:0] READ_POSY,
	output wire IN_DE,
	input [31:0] IN_DATA,

	output wire WRITE_LINE_DONE,
	output wire OUT_DE,
	output [31:0] OUT_DATA
);

	localparam WIDHT = 12'd1600;
	(* mark_debug = "true" *)reg KICK;
	(* mark_debug = "true" *)reg [11:0] POSX;
	(* mark_debug = "true" *)reg [11:0] POSY;
	(* mark_debug = "true" *)reg [11:0] WPOSX;

	assign OUT_DATA[7:0] = 8'hff;

	assign WRITE_LINE_DONE = WPOSX == WIDHT;
	always @(posedge CLK) begin
		if(RST)
			KICK <= 1'b0;
		else if(READ_LINE_DONE)
			KICK <= 1'b1;
		else if(POSX == WIDHT - 12'h1)
			KICK <= 1'b0;
	end

	always @(posedge CLK) begin
		if(RST)
			POSX <= 12'h0;
		else if(IN_DE)
			POSX <= POSX + 12'h1;
		else if(POSX == WIDHT)
			POSX <= 12'h0;
	end
	always @(posedge CLK) begin
		if(RST)
			POSY <= 12'h0;
		else if(READ_LINE_DONE)
			POSY <= READ_POSY;
	end
	always @(posedge CLK) begin
		if(RST)
			WPOSX <= 12'h0;
		else if(OUT_DE)
			WPOSX <= WPOSX + 12'h1;
		else if(WPOSX == WIDHT)
			WPOSX <= 12'h0;
	end

	grayscale u_grayscale(
		.CLK(CLK),
		.RST(RST),
		.POSX(POSX),
		.POSY(POSY),
		.READY(KICK),
		.RDEN(IN_DE),
		.IN_R(IN_DATA[31:24]),
		.IN_G(IN_DATA[23:16]),
		.IN_B(IN_DATA[15:8]),
		.WREN(OUT_DE),
		.OUT_R(OUT_DATA[31:24]),
		.OUT_G(OUT_DATA[23:16]),
		.OUT_B(OUT_DATA[15:8])
	);

endmodule