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
	reg [15:0] GRAY_R; 
	reg [15:0] GRAY_G; 
	reg [15:0] GRAY_B;
	wire [15:0] GRAY = GRAY_R + GRAY_G + GRAY_B;
	always @(posedge CLK) begin
		GRAY_R <= IN_R * 8'd77;
		GRAY_G <= IN_G * 8'd150;
		GRAY_B <= IN_B * 8'd28;
		OUT_R <= GRAY[15:8];
		OUT_G <= GRAY[15:8];
		OUT_B <= GRAY[15:8];
	end
	
	assign RDEN = READY;
	reg TEMP;
	always @(posedge CLK) begin
		TEMP <= RDEN;
		WREN <= TEMP;
	end
endmodule