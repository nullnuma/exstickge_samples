module hdmi_axi_addr#(
	parameter X_SIZE = 32'd256,
	parameter Y_SIZE = 32'd256
)(
	input wire			clk,
	input wire			rst,
	input wire			prefetch_line,
	input wire [1:0]	pixelena_edge,
	input wire [31:0]	fifo_available,

	input wire			busy,
	output wire			kick,
	output wire [31:0]	read_addr,
	output wire [31:0]	read_num,

	input wire frame_select
);
	//1word = 1pixel, 64pixel per transaction
	localparam WORD_SIZE = 32'd256;
	localparam FRAME_SIZE = X_SIZE * Y_SIZE;

	localparam s_idle = 3'h0;
	localparam s_addr_issue_idle = 3'h1;
	localparam s_addr_issue = 3'h2;
	localparam s_addr_issue_wait = 3'h3;
	localparam s_next_idle = 3'h4;

	//pixel num
	(* mark_debug = "true" *)reg [2:0] state;

	reg frame_select_reg;

	reg [31:0] read_addr_offset;
	assign read_addr = read_addr_offset + ((frame_select_reg)?32'h200_0000:32'h0);

	always @ (posedge clk) begin
		if(rst) begin
			state <= s_idle;
		end else begin
			case (state)
				s_idle:
					if(prefetch_line)
						state <= s_addr_issue_idle;
				s_addr_issue_idle :
					if(busy == 1'b0)
						state <= s_addr_issue;
				s_addr_issue:
					state <= s_addr_issue_wait;
				s_addr_issue_wait: begin
					if(busy == 1'b1) begin
						if(read_addr_offset == ((FRAME_SIZE - WORD_SIZE) * 32'h4))
							state <= s_idle;
						else
							state <= s_next_idle;
					end
				end
				s_next_idle: begin
					if(fifo_available < 32'd6400)//pixelena_edge == 2'b01
						state <= s_addr_issue_idle;
				end
				default: state <= s_idle;
			endcase
		end
	end


	assign kick = (state == s_addr_issue || state == s_addr_issue_wait);
	assign read_num = WORD_SIZE;

	always @ (posedge clk) begin
		if(rst || state == s_idle)
			read_addr_offset <= 32'h0;
		else if(state == s_addr_issue_wait && busy == 1'b1)
			read_addr_offset <= read_addr_offset + WORD_SIZE * 32'h4;
	end

	always @(posedge clk) begin
		if(state == s_idle)
			frame_select_reg <= frame_select;
	end

endmodule