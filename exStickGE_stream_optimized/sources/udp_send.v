module udp_send(
	input wire clk,
	input wire buf_clk,
	input wire rst,

//UDP
	input wire r_req,
	input wire r_enable,
	output wire r_ack,
	input wire [31:0] r_data,
	output wire w_req,
	output reg w_enable,
	input wire w_ack,
	output reg [31:0] w_data,

//DRAM READ
	output wire kick,
	input wire busy,
	output wire [31:0] read_num,
	output wire [31:0] read_addr,
	input wire [31:0] buf_dout,
	input wire buf_we,

	output reg frame_select
);

	localparam ADDR_WIDTH = 32;
	localparam AMOUNT_OF_ONCE = 32'd256;

	wire rgb_rd;
	wire addr_rd;
	wire [31:0] rgb_out;
	wire [31:0] addr_out;
	wire [10:0] rgb_cnt;
	wire fifo_ready;
	wire fifo_final;
	wire dram2rgb_rst = rst || (state == s_frameswitch);
	dram2rgb #(
		.AMOUNT_OF_ONCE(AMOUNT_OF_ONCE)
	) u_dram2rgb(
		.clk(clk),
		.rst(dram2rgb_rst),
	//DRAM READ
		.buf_clk(buf_clk),
		.kick(kick),
		.busy(busy),
		.read_num(read_num),
		.read_addr(read_addr),
		.buf_dout(buf_dout),
		.buf_we(buf_we),

		.frame_select(frame_select),
		.ready(fifo_ready),
		.final(fifo_final),

	//FIFO OUT
		.rgb_rd(rgb_rd),
		.addr_rd(addr_rd),
		.rgb_out(rgb_out),
		.addr_out(addr_out),
		.rgb_cnt(rgb_cnt)
	);

	localparam WRITE = 1'b1;
	localparam READ = 1'b0;
	
	wire interval_ok;

	reg [3:0] state;
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
	
	reg [31:0] r_data_reg;

	reg [31:0] header_reg[0:3];

	reg [ADDR_WIDTH-1:0] cnt;
	reg [2:0] header_cnt;

	assign r_ack = 1'b1;
	assign w_req = (state == s_write_uplwait);

	assign rgb_rd = (state == s_write);
	assign addr_rd = (state == s_write_info);

always @ (posedge clk) begin
		if(rst)
			state <= s_idle;
		else
			case (state)
				s_idle:
					if(r_enable)
						state <= s_header;
					else if(rgb_cnt == 32'h0 && fifo_final)
						state <= s_frameswitch;
					else if(interval_ok)
						state <= s_write_size;
				s_header:
					if(header_cnt == 3'b011)
						state <= s_addr;
				s_addr:
					state <= s_read;
				s_write_size:
					state <= s_write_fifowait;
				s_write_fifowait:
					if(rgb_cnt >= (AMOUNT_OF_ONCE - 32'h2))
						state <= s_write_uplwait;
				s_write_uplwait:
					if(w_ack == 1'b1 && busy == 1'b0)
						state <= s_write_header;
				s_write_header:
					if(header_cnt == 3'b011)
						state <= s_write_info;
				s_write_info://送信
					state <= s_write;
				s_write://送信
					if(cnt == read_num - 32'h1)
						state <= s_idle;
				s_read:
					state <= s_read_wait;
				s_read_wait:
					if(r_enable == 1'b0)
						state <= s_idle;
				s_frameswitch:
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
		else if(state == s_write)
			cnt <= cnt + {{ADDR_WIDTH-1{1'b0}},1'b1};
	end

	//UDPパケットヘッダ
	always @ (posedge clk) begin
		if(state == s_header)
			//UDPパケットヘッダ
			header_reg[header_cnt] <= r_data_reg;
		else if(state == s_write_uplwait)
			//UDPパケットサイズ設定
			header_reg[3] <= (read_num * 4) + 4;
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
			case (header_cnt)
				3'h0: w_data <= 32'h0a000003;//dst
				3'h1: w_data <= 32'h0a000001;//src
				3'h2: w_data <= 32'h40004000;//portport
				3'h3: w_data <= ((AMOUNT_OF_ONCE << 2) + 32'h4);//size
				default: w_data <= 32'h0;
			endcase
		else if(state == s_write_info) begin
			w_data[ADDR_WIDTH-1] <= 1'b0;
			w_data[ADDR_WIDTH-1-1:0] <= addr_out[ADDR_WIDTH-1-1:0];
		end else if(state == s_write)
			w_data <= rgb_out;
	end

	//パラメータ
	reg [7:0] p_interval;
	always @(posedge clk) begin
		if(rst) begin
			p_interval <= 8'h0;
		end else if(state == s_read) begin
			case (r_data_reg[31:24])
				8'h0: begin//送信速度
					p_interval <= r_data_reg[23:16];
				end
				default: p_interval <= p_interval;
			endcase
		end
	end

	wire [15:0] probe;
	vio_limitter u_vio_limitter(
		.clk(clk),
		.probe_out0(probe)
	);
	reg [31:0] interval_cnt;
	wire [31:0] interval_val = {9'h0,p_interval,probe};
	assign interval_ok = interval_cnt >= interval_val;
	always @(posedge clk) begin
		if(rst || state == s_write)
			interval_cnt <= 32'h0;
		else if(interval_cnt < interval_val)
			interval_cnt <= interval_cnt + 32'h1;		
	end

	always @(posedge clk) begin
		if(rst)
			frame_select <= 1'b0;
		else if(state == s_frameswitch)
			frame_select <= ~frame_select;
	end
endmodule