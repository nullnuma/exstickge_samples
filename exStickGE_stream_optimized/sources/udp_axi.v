`timescale 1ns / 1ps
`default_nettype none

module udp_axi(
	input wire clk,
	input wire fifoclk,
	input wire rst,
	input wire r_req,
	input wire r_enable,
	output wire r_ack,
	input wire [31:0] r_data,
	(* mark_debug = "true" *)output wire w_req,
	(* mark_debug = "true" *)output reg w_enable,
	(* mark_debug = "true" *)input wire w_ack,
	(* mark_debug = "true" *)output reg [31:0] w_data,
	//DRAM READ
	(* mark_debug = "true" *)output reg kick,
	(* mark_debug = "true" *)input wire busy,
	(* mark_debug = "true" *)output reg [31:0] read_num,
	(* mark_debug = "true" *)output reg [31:0] read_addr,
	(* mark_debug = "true" *)input wire [31:0] buf_dout,
	(* mark_debug = "true" *)input wire buf_we,

	output reg frame_select
);
	wire rst_sig;
	assign rst_sig = rst || state_axi == s_axi_rst;

	localparam ADDR_WIDTH = 32;

	localparam WRITE = 1'b1;
	localparam READ = 1'b0;

	(* mark_debug = "true" *)reg [3:0] state_udp;
	localparam s_idle = 0;
	localparam s_header = 1;
	localparam s_addr = 2;
	localparam s_write_size = 3;
	localparam s_write_fifowait = 4;
	localparam s_write_uplwait = 5;
	localparam s_write_header = 6;
	localparam s_write_info = 7;
	localparam s_write = 8;
	localparam s_frameswitch = 9;
	localparam s_read = 10;
	localparam s_read_wait = 11;

	(* mark_debug = "true" *)reg [2:0] state_axi;
	localparam s_axi_idle = 0;
	localparam s_axi_kick_pre = 1;
	localparam s_axi_kick = 2;
	localparam s_axi_fifowait = 3;
	localparam s_axi_frameswitch = 4;
	localparam s_axi_framewait = 5;
	localparam s_axi_rst = 6;

	localparam OFFSET_END = 32'h15F900;//1600 * 900;

	wire [31:0] BASEADDR = (frame_select)?32'h100_0000:32'h0;
	reg [31:0] r_data_reg;

	reg [31:0] header_reg[0:3];

	(* mark_debug = "true" *)reg [31:0] offset;
	(* mark_debug = "true" *)wire [31:0] offset_read;
	reg [ADDR_WIDTH-1:0] cnt;
	reg [2:0] header_cnt;

	assign r_ack = 1'b1;
	assign w_req = (state_udp == s_write_uplwait);

	wire [31:0] data_out;
	(* mark_debug = "true" *)wire fifo_full;

	(* mark_debug = "true" *)wire [10:0] fifo_cnt;

	wire interval_ok;

	fifo_dataread_2048 fifo(
		.wr_clk(fifoclk),
		.rd_clk(clk),
		.rst(rst_sig),
		//.full(),
		.din(buf_dout),
		.wr_en(buf_we),
		//.empty(),
		.dout(data_out),
		.rd_en(state_udp == s_write),
		.rd_data_count(fifo_cnt),
		.prog_full(fifo_full)
	);

	(* mark_debug = "true" *)wire test_wren = (state_axi == s_axi_kick && busy);
	(* mark_debug = "true" *)wire test_rden = (state_udp == s_write_info);
	(* mark_debug = "true" *)wire [7:0] fifo_offset_cnt;
	fifo_dataoffset fifo_offset(
		.clk(clk),
		.srst(rst_sig),
		.din(offset),
		.wr_en(state_axi == s_axi_kick && busy),
		.dout(offset_read),
		.data_count(fifo_offset_cnt),
		.rd_en(state_udp == s_write_info)
	);

	always @ (posedge clk) begin
		if(rst_sig)
			state_udp <= s_idle;
		else
			case (state_udp)
				s_idle:
					if(r_enable)
						state_udp <= s_header;
					else if(interval_ok)
						state_udp <= s_write_fifowait;
				s_header:
					if(header_cnt == 3'b011)
						state_udp <= s_addr;
				s_addr:
					state_udp <= s_read;//@TODO 間隔変更等
				s_write_fifowait:
					if((fifo_cnt + 11'h2) >= read_num[10:0])
						state_udp <= s_write_uplwait;
				s_write_uplwait:
					if(w_ack == 1'b1 && busy == 1'b0)
						state_udp <= s_write_header;
				s_write_header:
					if(header_cnt == 3'b011)
						state_udp <= s_write_info;
				s_write_info://送信
					state_udp <= s_write;
				s_write://送信
					if(cnt == read_num - 32'h1)
						state_udp <= s_idle;
				s_read:
					state_udp <= s_read_wait;
				s_read_wait:
					if(r_enable == 1'b0)
						state_udp <= s_idle;
				s_frameswitch:
					state_udp <= s_idle;
				default: state_udp <= s_idle;
			endcase
	end
	
	always @(posedge clk) begin
		if(rst)
			state_axi <= s_axi_idle;
		else
			case (state_axi)
				s_axi_idle: begin
					if(offset == OFFSET_END)
						state_axi <= s_axi_frameswitch;
					else if(busy == 1'b0 && fifo_full == 1'b0)
						state_axi <= s_axi_kick_pre;
				end
				s_axi_kick_pre:
					state_axi <= s_axi_kick;
				s_axi_kick: begin
					if(busy)
						state_axi <= s_axi_fifowait;
				end
				s_axi_fifowait: begin
					if(busy == 1'b0)
						state_axi <= s_axi_idle;
				end
				s_axi_frameswitch:
					state_axi <= s_axi_framewait;
				s_axi_framewait:
					if(fifo_cnt < 32'd62 && state_udp == s_write_fifowait)
						state_axi <= s_axi_rst;
				s_axi_rst:
					state_axi <= s_axi_idle;
				default: state_axi <= s_axi_idle;
			endcase
	end

	always @ (posedge clk) begin
		r_data_reg <= r_data;
	end

	//ヘッダ用カウンタ
	always @ (posedge clk) begin
		if(state_udp == s_header || state_udp == s_write_header)
			header_cnt <= header_cnt + 3'b001;
		else
			header_cnt <= 3'b000;
	end

	//データ書込カウンタ
	always @ (posedge clk) begin
		if(rst_sig)
			cnt <= {ADDR_WIDTH{1'b0}};
		else if(state_udp == s_idle)
			cnt <= {ADDR_WIDTH{1'b0}};
		else if(state_udp == s_write)
			cnt <= cnt + {{ADDR_WIDTH-1{1'b0}},1'b1};
	end

	//カウンタ設定
	always @ (posedge clk) begin
		if(state_axi == s_axi_kick_pre) begin
			read_num <= 32'h40;
		end
	end

	//offsetカウンタ
	always @(posedge clk) begin
		if(rst_sig || state_axi == s_axi_frameswitch)
			offset <= 32'h0;
		else if(state_axi == s_axi_kick && busy)
			offset <= offset + 32'h40;//64x4
	end

	//UDPパケットヘッダ
	always @ (posedge clk) begin
		if(state_udp == s_header)
			//UDPパケットヘッダ
			header_reg[header_cnt] <= r_data_reg;
		else if(state_udp == s_write_uplwait)
			//UDPパケットサイズ設定
			header_reg[3] <= (read_num * 4) + 4;
	end

	//イネーブル信号
	always @ (posedge clk) begin
		if(state_udp == s_write || state_udp == s_write_header || state_udp == s_write_info)
			w_enable <= 1'b1;
		else
			w_enable <= 1'b0;
	end

	//データ入出力
	always @ (posedge clk) begin
		if(state_udp == s_write_header)
			case (header_cnt)
				3'h0: w_data <= 32'h0a000003;//dst
				3'h1: w_data <= 32'h0a000001;//src
				3'h2: w_data <= 32'h40004000;//portport
				3'h3: w_data <= 32'h00000104;//size
				default: w_data <= 32'h0;
			endcase
		else if(state_udp == s_write_info) begin
			w_data[ADDR_WIDTH-1] <= 1'h0;
			w_data[ADDR_WIDTH-2:0] <= offset_read[30:0];
		end else if(state_udp == s_write)
			w_data <= data_out;
	end

	//DRAMから読み込む制御
	always @ (posedge clk) begin
		if(state_axi == s_axi_kick_pre)
			read_addr <= (offset<<2) + BASEADDR;
	end
	always @ (posedge clk) begin
		if(rst_sig)
			kick <= 1'b0;
		else if(state_axi == s_axi_kick)
			kick <= 1'b1;
		else
			kick <= 1'b0;
	end

	//パラメータ
	reg [7:0] p_interval;
	always @(posedge clk) begin
		if(rst_sig) begin
			p_interval <= 8'h0;
		end else if(state_udp == s_read) begin
			case (r_data_reg[31:24])
				8'h0: begin//送信速度
					p_interval <= r_data_reg[23:16];
				end
				default: p_interval <= p_interval;
			endcase
		end
	end

	wire [15:0] probe;
	vio_0 u_vio0(
		.clk(clk),
		.probe_out0(probe)
	);
	reg [31:0] interval_cnt;
	wire [31:0] interval_val = {9'h0,p_interval,probe};
	assign interval_ok = interval_cnt >= interval_val;
	always @(posedge clk) begin
		if(rst_sig || state_udp == s_write)
			interval_cnt <= 32'h0;
		else if(interval_cnt < interval_val)
			interval_cnt <= interval_cnt + 32'h1;		
	end

	always @(posedge clk) begin
		if(state_axi == s_axi_frameswitch)
			frame_select <= ~frame_select;
	end

endmodule
`default_nettype wire