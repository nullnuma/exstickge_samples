`timescale 1ns / 1ps
`default_nettype none
module hdmi_gen(
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
	output wire [31:0] w_data,
	//DRAM READ
	output wire kick,
	input wire busy,
	output wire [31:0] read_num,
	output wire [31:0] read_addr,
	input wire [31:0] buf_dout,
	input wire buf_we,
	//DRAM WRITE
	output wire [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	output wire data_we,
	output wire [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	output wire ctrl_we,
	//HDMI
	input wire clk_vga,
	input wire clk_tx,
	output wire clk_to_pins_n,
	output wire clk_to_pins_p,
	output wire [2:0] data_out_to_pins_n,
	output wire [2:0] data_out_to_pins_p
);
	
	localparam X_SIZE = 32'd1600;
	localparam Y_SIZE = 32'd900;


	reg [11:0] x;
	reg [11:0] y;
	wire framestart;
	wire linestart;
	wire prefetch_line;
	reg [1:0] pixelena_edge;
	wire de;
	wire [23:0]dataout;
	wire img_de;
	assign img_de = (x<X_SIZE && y<Y_SIZE) && de;
	wire [11:0] fifo_cnt;


	reg [1:0] rst_vga_ff;
	always @( posedge clk_vga ) begin
		rst_vga_ff <= { rst_vga_ff[0], rst };
	end
	wire rst_vga = rst_vga_ff[1];

	hdmi_axi_addr #(
		.X_SIZE(X_SIZE),
		.Y_SIZE(Y_SIZE)
	) hdmi_axi_addr (
		.clk(clk),
		.rst(rst),
		.prefetch_line(prefetch_line),
		.pixelena_edge(pixelena_edge),
		.fifo_available(fifo_available),

		.kick(kick),
		.busy(busy),
		.read_addr(read_addr),
		.read_num(read_num)
	);
	udp_hdmi_recv udp_hdmi_recv(
		.clk(clk),
		.fifoclk(fifoclk),
		.rst(rst),
		.r_req(r_req),
		.r_enable(r_enable),
		.r_ack(r_ack),
		.r_data(r_data),
		.w_req(w_req),
		.w_enable(w_enable),
		.w_ack(w_ack),
		.w_data(w_data),
		//DRAM WRITE
		.data_in(data_in),
		.data_we(data_we),
		.ctrl_in(ctrl_in),
		.ctrl_we(ctrl_we)
	);


	fifo_dataread fifo(
		.wr_clk(clk),
		.rst(rst || framestart),
		//.full(),
		.din(buf_dout[31:8]),
		.wr_en(buf_we),
		//.empty(),
		.rd_clk(clk_vga),
		.dout(dataout),
		.rd_en(img_de),
		.rd_data_count(fifo_cnt)
	);

	//FIFO 入出力管理
	(* mark_debug = "true" *)reg [31:0] fifo_in;
	(* mark_debug = "true" *)reg [31:0] fifo_out;
	(* mark_debug = "true" *)reg [31:0] fifo_out_clk [0:1];
	(* mark_debug = "true" *)reg [1:0] framestart_clk;
	(* mark_debug = "true" *)reg [31:0] fifo_available;
	always @(posedge clk)  begin
		framestart_clk <= {framestart_clk[0],framestart};
		fifo_out_clk[0] <= fifo_out;
		fifo_out_clk[1] <= fifo_out_clk[0];
	end
	always @(posedge clk) begin
		if(rst || framestart_clk[1])
			fifo_in <= 32'h0;
		else if(kick && busy)
			fifo_in <= fifo_in + read_num;
	end
	always @(posedge clk_vga) begin
		if(rst || framestart)
			fifo_out <= 32'h0;
		else if(img_de)
			fifo_out <= fifo_out + 32'h1;
	end
	always @(posedge clk)  begin
		fifo_available <= fifo_in - fifo_out;
	end

	always @ (posedge clk_vga) begin
		pixelena_edge <= {pixelena_edge[0],de};
	end
	always @ (posedge clk_vga) begin
		if(rst_vga) begin
			x <= 12'h0;
			y <= 12'h0;
		end else begin
			if(framestart) begin
				x <= 12'h0;
				y <= 12'h0;
			end else if(pixelena_edge == 2'b10) begin
				x <= 12'h0;
				if(y < Y_SIZE)begin
					y <= y + 12'h1;
				end
			end else if(de) begin
				if(x < X_SIZE)begin
					x <= x + 12'h1;
				end
			end
		end
	end

	wire [7:0] red;
	wire [7:0] green;
	wire [7:0] blue;

	assign red = (img_de)?dataout[23:16]:8'h20;
	assign green = (img_de)?dataout[15:8]:8'h60;
	assign blue = (img_de)?dataout[7:0]:8'h20;

	dvi_tx tx(
		.rst(rst_vga),
		.clk_vga(clk_vga),
		.clk_tx(clk_tx),

		.d_red(red),
		.d_green(green),
		.d_blue(blue),

		.framestart(framestart),
		.linestart(linestart),
		.prefetch_line(prefetch_line),

		.hsync(),
		.vsync(),
		.de(de),

		.TMDS_CLOCK_N(clk_to_pins_n),
		.TMDS_CLOCK_P(clk_to_pins_p),
		.TMDS_DATA_N(data_out_to_pins_n),
		.TMDS_DATA_P(data_out_to_pins_p)
	);

endmodule
`default_nettype wire
