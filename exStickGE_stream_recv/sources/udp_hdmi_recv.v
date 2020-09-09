`timescale 1ns / 1ps
`default_nettype none

module udp_hdmi_recv(
	input wire clk,
	input wire fifoclk,
	input wire rst,
	input wire r_req,
	input wire r_enable,
	output wire r_ack,
	input wire [31:0] r_data,
	output wire w_req,
	output wire w_enable,
	input wire w_ack,
	output reg [31:0] w_data,
	//DRAM WRITE
	output wire [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	output wire data_we,
	output wire [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	output wire ctrl_we,

	output reg frame_select
);

	localparam ADDR_WIDTH = 32;

	localparam WRITE = 1'b1;
	localparam READ = 1'b0;

	reg [3:0] state;
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
			offset <= r_data_reg;
			end_cnt <= ((header_reg[3]+32'h3)>>2) - 32'h2;//切り上げしてヘッダとカウンタ分を1ずつ引く
		end
	end

	//UDPパケットヘッダ
	always @ (posedge clk) begin
		if(state == s_header)
			//UDPパケットヘッダ
			header_reg[header_cnt] <= r_data_reg;
	end

	//DRAMに書き込む制御
	reg [2:0] ctrl_state;
	localparam s_ctrl_idle = 0;
	localparam s_ctrl_accept = 1;
	localparam s_ctrl_write = 2;
	
	always @(posedge clk) begin
		if(rst)
			ctrl_state <= s_ctrl_idle;
		else
			case (ctrl_state)
				s_ctrl_idle:
					if(state == s_read_accept)
						ctrl_state <= s_ctrl_accept;
				s_ctrl_accept: ctrl_state <= s_ctrl_write;
				s_ctrl_write: begin
					if(ctrl_len_buf <= 32'd64)
						ctrl_state <= s_ctrl_idle;
				end
				default: ctrl_state <= s_ctrl_idle;
			endcase
	end

	reg [31:0] offset_buf;
	reg [31:0] ctrl_len_buf;
	wire [7:0] ctrl_len;

	assign ctrl_in = {ctrl_len,offset_buf << 2};
	assign ctrl_we = (ctrl_state == s_ctrl_write);
	assign ctrl_len = (ctrl_len_buf > 32'd64)?8'd64:ctrl_len_buf[7:0];

	wire [31:0] frame_addr;
	assign frame_addr = ((frame_select)?32'h0:32'h80_0000);

	always @(posedge clk) begin
		if(rst)
			offset_buf <= 32'h0;
		else if(state == s_read_accept)
			offset_buf <= offset + frame_addr;
		else if(ctrl_state ==s_ctrl_write)
			offset_buf <= offset_buf + 32'd64;
	end
	always @(posedge clk) begin
		if(rst)
			frame_select <= 1'b0;
		else if(state == s_addr && r_data_reg == 32'h0)
			frame_select <= ~frame_select;
	end

	always @(posedge clk) begin
		if(rst)
			ctrl_len_buf <= 32'h0;
		else if(state == s_read_accept)
			ctrl_len_buf <= cnt;
		else if(ctrl_state == s_ctrl_write)
			ctrl_len_buf <= ctrl_len_buf - 32'd64;
	end
	
endmodule
`default_nettype wire