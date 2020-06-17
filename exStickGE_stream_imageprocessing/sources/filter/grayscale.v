module grayscale(
	input wire CLK,
	input wire RST,

	input wire [11:0] POSX,
	input wire [11:0] POSY,
	input wire READY,

	output wire RDEN,
	input wire [7:0] IN_R,
	input wire [7:0] IN_G,
	input wire [7:0] IN_B,

	output reg WREN, 
	output reg [7:0] OUT_R,
	output reg [7:0] OUT_G,
	output reg [7:0] OUT_B
);
	wire [15:0] GRAY = IN_R * 8'd77 + IN_G * 8'd150 + IN_B * 8'd28;
	always @(posedge CLK) begin
		OUT_R <= GRAY[15:8];
		OUT_G <= GRAY[15:8];
		OUT_B <= GRAY[15:8];
	end
	
	assign RDEN = READY;
	always @(posedge CLK) begin
		WREN <= RDEN;
	end
endmodule