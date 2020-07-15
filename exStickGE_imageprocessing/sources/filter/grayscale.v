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
	reg [15:0] tmp_R;
	reg [15:0] tmp_G;
	reg [15:0] tmp_B;
	always @(posedge CLK) begin
		tmp_R <= IN_R * 8'd77;
		tmp_G <= IN_G * 8'd150;
		tmp_B <= IN_B * 8'd28;
	end
	wire [15:0] GRAY = tmp_R + tmp_G + tmp_B;
	always @(posedge CLK) begin
		OUT_R <= GRAY[15:8];
		OUT_G <= GRAY[15:8];
		OUT_B <= GRAY[15:8];
	end
	
	reg RDEN_tmp;
	always @(posedge CLK) begin
		RDEN_tmp <= READY;
	end
	always @(posedge CLK) begin
		WREN <= RDEN_tmp;
	end
endmodule