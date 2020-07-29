module hdmi_axi_addr#(
	parameter X_SIZE = 12'd256,
	parameter Y_SIZE = 12'd256
)(
	input wire			clk,
	input wire			rst,
	input wire			prefetch_line,
	input wire [1:0]	pixelena_edge,

	input wire			busy,
	output wire			kick,
	output reg [31:0]	read_addr,
	output wire [31:0]	read_num
);
	//1word = 1pixel, 64pixel per transaction
	localparam WORD_SIZE = 12'd64;

	localparam s_idle = 3'h0;
	localparam s_addr_issue_idle = 3'h1;
	localparam s_addr_issue = 3'h2;
	localparam s_addr_issue_wait = 3'h3;
	localparam s_next_idle = 3'h4;

	//pixel num
	reg [11:0] x_cnt;
	reg [11:0] y_cnt;
	reg [2:0] state;

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
						if(x_cnt == X_SIZE)
							state <= s_next_idle;
						else
							state <= s_addr_issue_idle;
					end
				end
				s_next_idle:
					if(y_cnt == Y_SIZE)
						state <= s_idle;
					else if(pixelena_edge == 2'b01)
						state <= s_addr_issue_idle;
				default: state <= s_idle;
			endcase
		end
	end

	always @ (posedge clk) begin
		if(rst || (state == s_idle) || (state == s_next_idle))
			x_cnt <= 12'h0;
		else if(state == s_addr_issue)
			x_cnt <= x_cnt + WORD_SIZE;
	end
	
	always @ (posedge clk) begin
		if(rst || state == s_idle)
			y_cnt <= 12'h0;
		else if((x_cnt == X_SIZE - WORD_SIZE) && (state == s_addr_issue))
			y_cnt <= y_cnt + 1;
	end

	assign kick = (state == s_addr_issue || state == s_addr_issue_wait);
	assign read_num = WORD_SIZE;

	always @ (posedge clk) begin
		if(rst)
			read_addr <= 32'h0;
		else if(state == s_addr_issue_idle)			
			read_addr <= (x_cnt * 32'h4 + y_cnt * X_SIZE *32'h4);
	end

endmodule