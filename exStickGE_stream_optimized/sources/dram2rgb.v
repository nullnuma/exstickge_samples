`default_nettype none
module dram2rgb #(
	parameter AMOUNT_OF_ONCE = 32'd64
)(
	input wire clk,
	input wire rst,
	//DRAM READ
	output wire kick,
	input wire busy,
	output wire [31:0] read_num,
	output wire [31:0] read_addr,
	input wire [31:0] buf_dout,
	input wire buf_we,
	input wire buf_clk,

	input wire frame_select,
	input wire ready,
	output wire final,

	//FIFO OUT
	input wire rgb_rd,
	input wire addr_rd,
	output wire [31:0] rgb_out,
	output wire [31:0] addr_out,
	output wire [10:0] rgb_cnt
);
//ADDR
	localparam OFFSET_END = 32'd1440000;//1600x900
	reg [31:0] base_addr;
	reg [31:0] offset;
	reg [1:0] busy_clk;
	wire busy_clk_sig = busy_clk[1];

//RGB FIFO
	wire rgb_full;
	reg [7:0] buf_cnt;
	reg [7:0] buf_cnt_clk [0:1];
	reg fifo_rst = 1'b0;

	wire rgb_wr_busy;
	wire rgb_rd_busy;

//State
	reg [3:0] state;
	localparam s_rst = 0;
	localparam s_rst_wait = 1;
	localparam s_idle = 2;
	localparam s_kick = 3;
	localparam s_fifo_wait = 4;
	localparam s_end = 5;

	always@(posedge clk) begin
		fifo_rst <= (state == s_rst) || rst;
	end

	fifo_dataread_4000 fifo(
		.wr_clk(buf_clk),
		.rd_clk(clk),
		.rst(fifo_rst),
		//.full(),
		.din(buf_dout),
		.wr_en(buf_we),
		//.empty(),
		.dout(rgb_out),
		.rd_en(rgb_rd),
		.rd_data_count(rgb_cnt),
		.prog_full(rgb_full),

		.wr_rst_busy(rgb_wr_busy),
		.rd_rst_busy(rgb_rd_busy)
	);
	always @(posedge buf_clk) begin
		if(state == s_kick)
			buf_cnt <= 8'h0;
		else if(buf_we)
			buf_cnt <= buf_cnt + 8'h1;
	end
	always @(posedge clk) begin
		buf_cnt_clk[0] <= buf_cnt;
		buf_cnt_clk[1] <= buf_cnt_clk[0];
	end
	always @(posedge clk) begin
		busy_clk <= {busy_clk[0],busy};
	end

	wire [5:0] addr_cnt;//remove
	fifo_dataoffset fifo_addr(
		.clk(clk),
		.srst(rst),
		.din(offset),
		.wr_en(state == s_kick && busy_clk_sig),
		.dout(addr_out),
		.data_count(addr_cnt),
		.rd_en(addr_rd)
	);

	always @(posedge clk) begin
		if(rst)
			base_addr <= (frame_select)? 32'h0:32'h100_0000;
	end

	always @(posedge clk) begin
		if(state == s_rst)
			offset <= 32'h0;
		else if(state == s_kick && busy_clk_sig)
			offset <= offset + AMOUNT_OF_ONCE;
	end

	assign read_num = AMOUNT_OF_ONCE;
	assign read_addr = (offset << 2) + base_addr;
	assign kick = state == s_kick;
	assign ready = ~(state == s_rst || state == s_rst_wait);
	assign final = state == s_end;

	always @(posedge clk) begin
		if(rst)
			state <= s_rst;
		else
			case (state)
				s_rst: state <= s_rst_wait;
				s_rst_wait: begin
					state <= s_idle;
				end
				s_idle: begin
					if(busy_clk_sig == 1'b0 && rgb_full == 1'b0)
						state <= s_kick;
				end
				s_kick: begin
					if(busy_clk_sig)
						state <= s_fifo_wait;
				end
				s_fifo_wait: begin
					if(buf_cnt_clk[1] == 8'd64) begin
						if(offset == OFFSET_END)
							state <= s_end;
						else
							state <= s_idle;
					end
				end
				s_end: state <= s_end;
				default: state <= s_rst;
			endcase
	end

endmodule