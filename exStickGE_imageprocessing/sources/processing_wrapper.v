module processing_wrapper(
	input wire CLK,
	input wire RST,

	input wire READ_LINE_DONE,
	output wire IN_DE,
	input [31:0] IN_DATA,

	output wire WRITE_LINE_DONE,
	output wire OUT_DE,
	output [31:0] OUT_DATA
);

	localparam WIDHT = 12'd1600;
	reg KICK;
	reg [11:0] CNT;

	assign IN_DATA = OUT_DATA;
	assign IN_DE = KICK;
	assign OUT_DE = IN_DE;
	assign WRITE_LINE_DONE = CNT == WIDHT - 12'h1;
	always @(posedge CLK) begin
		if(RST)
			KICK <= 1'b0;
		else if(READ_LINE_DONE)
			KICK <= 1'b1;
		else if(CNT == WIDHT - 12'h1)
			KICK <= 1'b0;
	end

	always @(posedge CLK) begin
		if(RST)
			CNT <= 12'h0;
		else if(KICK)
			CNT <= CNT + 12'h1;
		else
			CNT <= 12'h0;
	end


endmodule