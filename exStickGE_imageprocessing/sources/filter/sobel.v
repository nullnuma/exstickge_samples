module sobel(
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

	reg [2:0] state;
	localparam s_RST = 0;
	localparam s_WAIT = 1;
	localparam s_FIRSTLINE = 2;
	localparam s_CALCLINE = 3;

	always @(posedge CLK) begin
		if(RST)
			state <= s_RST;
		else
			case (state)
				s_RST:  state <= s_WAIT;
				s_WAIT: begin
					if(READY) begin
						if(POSY == 12'h0)
							state <= s_FIRSTLINE;
						else
							state <= s_CALCLINE;
					end
				end
				default: state <= s_RST;
			endcase
	end

	wire [7:0] before_R;
	wire [7:0] before_G;
	wire [7:0] before_B;
	wire [7:0] middle_R;
	wire [7:0] middle_G;
	wire [7:0] middle_B;
	wire [7:0] after_R;
	wire [7:0] after_G;
	wire [7:0] after_B;
	(* mark_debug = "true" *)wire signed [15:0] RESULT_R;
	(* mark_debug = "true" *)wire signed [15:0] RESULT_G;
	(* mark_debug = "true" *)wire signed [15:0] RESULT_B;

	assign before_R = IN_R;
	assign before_G = IN_G;
	assign before_B = IN_B;
	sobel_line_fifo fifo_before (
		.clk(CLK),
		.srst(RST),
		.din({before_R,before_G,before_B}),
		.wr_en(RDEN),
		.dout({middle_R,middle_G,middle_B}),
		.rd_en(RDEN && POSY != 12'h0)
	);
	sobel_line_fifo fifo_middle (
		.clk(CLK),
		.srst(RST),
		.din({middle_R,middle_G,middle_B}),
		.wr_en(RDEN && POSY != 12'h0),
		.dout({after_R,after_G,after_B}),
		.rd_en(RDEN && POSY != 12'h0 && POSY != 12'h1)
	);

	(* mark_debug = "true" *)reg [7:0] TMP_R [0:8];
	(* mark_debug = "true" *)reg [7:0] TMP_G [0:8];
	(* mark_debug = "true" *)reg [7:0] TMP_B [0:8];
	always @(posedge CLK) begin
		if(RST) begin
				TMP_R[0] <= 8'h0;
				TMP_R[1] <= 8'h0;
				TMP_R[2] <= 8'h0;
				TMP_R[3] <= 8'h0;
				TMP_R[4] <= 8'h0;
				TMP_R[5] <= 8'h0;
				TMP_R[6] <= 8'h0;
				TMP_R[7] <= 8'h0;
				TMP_R[8] <= 8'h0;
				TMP_R[0] <= 8'h0;
				TMP_G[1] <= 8'h0;
				TMP_G[2] <= 8'h0;
				TMP_G[3] <= 8'h0;
				TMP_G[4] <= 8'h0;
				TMP_G[5] <= 8'h0;
				TMP_G[6] <= 8'h0;
				TMP_G[7] <= 8'h0;
				TMP_G[8] <= 8'h0;
				TMP_B[0] <= 8'h0;
				TMP_B[1] <= 8'h0;
				TMP_B[2] <= 8'h0;
				TMP_B[3] <= 8'h0;
				TMP_B[4] <= 8'h0;
				TMP_B[5] <= 8'h0;
				TMP_B[6] <= 8'h0;
				TMP_B[7] <= 8'h0;
				TMP_B[8] <= 8'h0;
		end else if(RDEN) begin
			TMP_R[0] <= before_R;
			TMP_R[1] <= TMP_R[0];
			TMP_R[2] <= TMP_R[1];
			TMP_R[3] <= middle_R;
			TMP_R[4] <= TMP_R[3];
			TMP_R[5] <= TMP_R[4];
			TMP_R[6] <= after_R;
			TMP_R[7] <= TMP_R[6];
			TMP_R[8] <= TMP_R[7];
			TMP_G[0] <= before_G;
			TMP_G[1] <= TMP_G[0];
			TMP_G[2] <= TMP_G[1];
			TMP_G[3] <= middle_G;
			TMP_G[4] <= TMP_G[3];
			TMP_G[5] <= TMP_G[4];
			TMP_G[6] <= after_G;
			TMP_G[7] <= TMP_G[6];
			TMP_G[8] <= TMP_G[7];
			TMP_B[0] <= before_B;
			TMP_B[1] <= TMP_B[0];
			TMP_B[2] <= TMP_B[1];
			TMP_B[3] <= middle_B;
			TMP_B[4] <= TMP_B[3];
			TMP_B[5] <= TMP_B[4];
			TMP_B[6] <= after_B;
			TMP_B[7] <= TMP_B[6];
			TMP_B[8] <= TMP_B[7];
		end
	end

	assign RESULT_R = -$signed({10'h0,TMP_R[0]}) + $signed({10'h0,TMP_R[2]}) -$signed({9'h0,TMP_R[3],1'h0}) + $signed({9'h0,TMP_R[5],1'h0}) - $signed({10'h0,TMP_R[6]}) + $signed({10'h0,TMP_R[8]});
	assign RESULT_G = -$signed({10'h0,TMP_G[0]}) + $signed({10'h0,TMP_G[2]}) -$signed({9'h0,TMP_G[3],1'h0}) + $signed({9'h0,TMP_G[5],1'h0}) - $signed({10'h0,TMP_G[6]}) + $signed({10'h0,TMP_G[8]});
	assign RESULT_B = -$signed({10'h0,TMP_B[0]}) + $signed({10'h0,TMP_B[2]}) -$signed({9'h0,TMP_B[3],1'h0}) + $signed({9'h0,TMP_B[5],1'h0}) - $signed({10'h0,TMP_B[6]}) + $signed({10'h0,TMP_B[8]});

	wire [7:0] CLIP_R = (RESULT_R<0)?8'h0:((RESULT_R>255)?8'hff:RESULT_R[7:0]);
	wire [7:0] CLIP_G = (RESULT_G<0)?8'h0:((RESULT_G>255)?8'hff:RESULT_G[7:0]);
	wire [7:0] CLIP_B = (RESULT_B<0)?8'h0:((RESULT_B>255)?8'hff:RESULT_B[7:0]);

	always @(posedge CLK) begin
		OUT_R <= (POSY >12'h1 && POSY < 12'h898 && POSX > 12'h1 && POSX < 12'h1598)?CLIP_R:8'h00;
		OUT_G <= (POSY >12'h1 && POSY < 12'h898 && POSX > 12'h1 && POSX < 12'h1598)?CLIP_G:8'h00;
		OUT_B <= (POSY >12'h1 && POSY < 12'h898 && POSX > 12'h1 && POSX < 12'h1598)?CLIP_B:8'h00;
	end
	
	assign RDEN = READY;
	always @(posedge CLK) begin
		WREN <= RDEN;
	end
endmodule