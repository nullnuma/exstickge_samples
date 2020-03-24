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
	output wire w_req,
	output reg w_enable,
	input wire w_ack,
	output reg [31:0] w_data,
	//DRAM READ
	output reg kick,
	input wire busy,
	output reg [31:0] read_num,
	output reg [31:0] read_addr,
	input wire [31:0] buf_dout,
	input wire buf_we,
	//DRAM WRITE
	output wire [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	output wire data_we,
	output reg [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	output reg ctrl_we
);

	localparam ADDR_WIDTH = 32;

	localparam WRITE = 1'b1;
	localparam READ = 1'b0;

	reg [3:0] state;
	localparam s_idle = 0;
	localparam s_header = 1;
	localparam s_addr = 2;
	localparam s_write_size = 3;
	localparam s_write_wait = 4;
	localparam s_write_header = 5;
	localparam s_write_info = 6;
	localparam s_write = 7;
	localparam s_read = 8;
	localparam s_read_accept = 9;
	localparam s_read_wait = 10;

	reg [31:0] r_data_reg;

	reg [31:0] header_reg[0:3];

	reg [ADDR_WIDTH-1:0] offset;
	reg [ADDR_WIDTH-1:0] cnt;
	reg [ADDR_WIDTH-1:0] end_cnt;
	reg [2:0] header_cnt;

	assign r_ack = 1'b1;
	assign w_req = (state == s_write_wait);

	wire [31:0] data_out;

	assign data_in = {4'b1111,r_data_reg};
	assign data_we = (state == s_read);

	wire [7:0] fifo_cnt;
	wire fifo_read;
	assign fifo_read = (state == s_write_info || state == s_write)?1'b1:1'b0;

	fifo_dataread fifo(
		.rd_clk(clk),
		.wr_clk(fifoclk),
		.rst(rst),
		//.full(),
		.din(buf_dout),
		.wr_en(buf_we),
		//.empty(),
		.dout(data_out),
		.rd_en(fifo_read),
		.rd_data_count(fifo_cnt)
	);

	always @ (posedge clk) begin
		if(rst)
			state <= s_idle;
		else
			case (state)
				s_idle:
					if(r_enable)
						state <= s_header;
				s_header:
					if(header_cnt == 3'b011)
						state <= s_addr;
				s_addr:
					if(r_data_reg[0] == READ)//相手がRead自分がWrite
						state <= s_write_size;
					else
						state <= s_read;
				s_write_size:
					state <= s_write_wait;
				s_write_wait:
					if(w_ack == 1'b1 && busy == 1'b0 && fifo_cnt == read_num[7:0])
						state <= s_write_header;
				s_write_header:
					if(header_cnt == 3'b011)
						state <= s_write_info;
				s_write_info://送信
					state <= s_write;
				s_write://送信
					if(cnt == read_num - 32'h1)
						state <= s_idle;
				s_read://受信
					if(cnt == end_cnt)//受信終了時
						state <= s_read_accept;
				s_read_accept:
					state <= s_read_wait;
				s_read_wait:
					if(r_enable == 1'b0)
						state <= s_idle;
				default: state <= s_idle;
			endcase
	end

	always @ (posedge clk) begin
		r_data_reg <= r_data;
	end

	//ヘッダ用カウンタ
	always @ (posedge clk) begin
		if(state == s_header || state == s_write_header)
			header_cnt <= header_cnt + 3'b001;
		else
			header_cnt <= 3'b000;
	end

	//データ書込カウンタ
	always @ (posedge clk) begin
		if(rst)
			cnt <= {ADDR_WIDTH{1'b0}};
		else if(state == s_idle)
			cnt <= {ADDR_WIDTH{1'b0}};
		else if(state == s_write || state == s_read)
			cnt <= cnt + {{ADDR_WIDTH-1{1'b0}},1'b1};
	end

	//カウンタ設定
	always @ (posedge clk) begin
		if(state == s_addr) begin
			offset <= {1'b0,r_data_reg[ADDR_WIDTH-1:1]};
			end_cnt <= ((header_reg[3]+32'h3)>>2) - 32'h2;//切り上げしてヘッダとカウンタ分を1ずつ引く
		end
	end
	always @ (posedge clk) begin
		if(state == s_write_size) begin
			read_num <= r_data_reg + 32'h1;
		end
	end

	//UDPパケットヘッダ
	always @ (posedge clk) begin
		if(state == s_header)
			//UDPパケットヘッダ
			header_reg[header_cnt] <= r_data_reg;
		else if(state == s_write_wait)
			//UDPパケットサイズ設定
			header_reg[3] = (read_num * 4) + 4;
	end

	//イネーブル信号
	always @ (posedge clk) begin
		if(state == s_write || state == s_write_header || state == s_write_info)
			w_enable <= 1'b1;
		else
			w_enable <= 1'b0;
	end

	//データ入出力
	always @ (posedge clk) begin
		if(state == s_write_header)
			w_data <= header_reg[header_cnt];
		else if(state == s_write_info) begin
			//w_data <= {end_cnt,offset,1'b0};
			w_data[ADDR_WIDTH-1] <= 1'b0;
			w_data[ADDR_WIDTH-1-1:0] <= offset[ADDR_WIDTH-1-1:0];
		end else if(state == s_write)
			w_data <= data_out;
	end

	//DRAMに書き込む制御
	always @ (posedge clk) begin
		if(rst) begin
			ctrl_we <= 1'b0;
		end else if(state == s_read_accept) begin
			ctrl_in <= {cnt[7:0],offset<<2};
			ctrl_we <= 1'b1;
		end else begin
			ctrl_we <= 1'b0;
		end
	end

	//DRAMから読み込む制御
	always @ (posedge clk) begin
		if(state == s_write_size)
			read_addr <= offset<<2;
	end
	always @ (posedge clk) begin
		if(rst)
			kick <= 1'b0;
		else if(state == s_write_size && busy == 1'b0)
			kick <= 1'b1;
		else
			kick <= 1'b0;
	end


endmodule
`default_nettype wire