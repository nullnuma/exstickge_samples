`timescale 1ns / 1ps
`default_nettype none

module udp_hdmi_recv(
	input wire clk,
	input wire fifoclk,
	input wire rst,
	(* mark_debug = "true" *)input wire r_req,
	(* mark_debug = "true" *)input wire r_enable,
	(* mark_debug = "true" *)output wire r_ack,
	(* mark_debug = "true" *)input wire [31:0] r_data,
	(* mark_debug = "true" *)output wire w_req,
	(* mark_debug = "true" *)output wire w_enable,
	(* mark_debug = "true" *)input wire w_ack,
	(* mark_debug = "true" *)output reg [31:0] w_data,
	//DRAM WRITE
	(* mark_debug = "true" *)output wire [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	(* mark_debug = "true" *)output wire data_we,
	(* mark_debug = "true" *)output reg [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	(* mark_debug = "true" *)output reg ctrl_we
);

	localparam ADDR_WIDTH = 32;

	localparam WRITE = 1'b1;
	localparam READ = 1'b0;

	(* mark_debug = "true" *)reg [3:0] state;
	localparam s_idle = 0;
	localparam s_header = 1;
	localparam s_addr = 2;
	localparam s_read = 3;
	localparam s_read_accept = 4;
	localparam s_read_wait = 5;

	reg [31:0] r_data_reg;

	reg [31:0] header_reg[0:3];

	reg [ADDR_WIDTH-1:0] offset;
	reg [ADDR_WIDTH-1:0] cnt;
	reg [ADDR_WIDTH-1:0] end_cnt;
	reg [2:0] header_cnt;

	assign r_ack = 1'b1;
	assign w_req = 1'b0;
	assign w_enable = 1'b0;

	wire [31:0] data_out;

	assign data_in = {4'b1111,r_data_reg};
	assign data_we = (state == s_read);

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
					state <= s_read;
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
		if(state == s_header)
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
		else if(state == s_read)
			cnt <= cnt + {{ADDR_WIDTH-1{1'b0}},1'b1};
	end

	//カウンタ設定
	always @ (posedge clk) begin
		if(state == s_addr) begin
			offset <= r_data_reg;//{2'h0, r_data_reg[31:2]};
			end_cnt <= ((header_reg[3]+32'h3)>>2);//切り上げしてヘッダとカウンタ分を1ずつ引く
		end
	end

	//UDPパケットヘッダ
	always @ (posedge clk) begin
		if(state == s_header)
			//UDPパケットヘッダ
			header_reg[header_cnt] <= r_data_reg;
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


endmodule
`default_nettype wire