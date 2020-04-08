module hdmi_axi_addr#(
	parameter X_SIZE = 12'd256,
	parameter Y_SIZE = 12'd256
)(
	input wire			clk_vga,
	input wire			rst,
	input wire			prefetch_line,
	input wire [1:0]	pixelena_edge,

	input wire			busy,
	output wire			kick,
	output reg [31:0]	read_addr,
	output wire [31:0]	read_num
);
	localparam WORD_SIZE = 12'd64;//1word = 1pixel, 64pixel per transaction

	localparam s_idle = 2'h0;
	localparam s_addr_issue_idle = 2'h1;
	localparam s_addr_issue = 2'h2;
	localparam s_next_idle = 2'h3;

	//pixel num
	(* mark_debug = "true" *)reg [11:0] x_cnt;
	(* mark_debug = "true" *)reg [11:0] y_cnt;
	(* syn_encoding="user" *)(* mark_debug = "true" *)reg [1:0] state;
	(* mark_debug = "true" *)reg [1:0] state_d;
	always @ (posedge clk_vga) begin
		state_d <= state;
	end

	always @ (posedge clk_vga) begin
		if(rst) begin
			state <= s_idle;
		end else begin
			if(state == s_idle) begin
				if(prefetch_line)
					state <= s_addr_issue_idle;
			end else if(state == s_addr_issue_idle) begin
				if(busy == 1'b0) begin
					state <= s_addr_issue;
				end else begin
					state <= s_addr_issue_idle;
				end
			end else if(state == s_addr_issue) begin
				if(busy == 1'b1) begin
					if(x_cnt == X_SIZE)
						state <= s_next_idle;
					else
						state <= s_addr_issue_idle;
				end
			end else if(state == s_next_idle) begin
				if(y_cnt == Y_SIZE)
					state <= s_idle;
				else if(pixelena_edge == 2'b01)
					state <= s_addr_issue_idle;
			end
		end
	end

	always @ (posedge clk_vga) begin
		if(rst || (state == s_idle) || (state == s_next_idle))
			x_cnt <= 12'h0;
		else if((state == s_addr_issue) && ~busy)
			x_cnt <= x_cnt + WORD_SIZE;
	end
	
	always @ (posedge clk_vga) begin
		if(rst || state == s_idle)
			y_cnt <= 12'h0;
		else if((x_cnt == X_SIZE) && (state == s_addr_issue))// - WORD_SIZE
			y_cnt <= y_cnt + 1;
	end

	assign kick = (state == s_addr_issue);
	assign read_num = WORD_SIZE;

	//kickの瞬間をキャプチャ
	always @ (posedge clk_vga) begin
		if(rst)
			read_addr <= 32'h0;
		else if(state == s_addr_issue_idle && busy == 1'b0)			
			read_addr <= (x_cnt * 4 + y_cnt * X_SIZE *4);
	end
	//assign read_addr = (x_cnt * 4 + y_cnt * X_SIZE *4);

endmodule