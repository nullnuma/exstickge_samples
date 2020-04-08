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

	
	localparam X_SIZE = 12'd1280;
	localparam Y_SIZE = 12'd720;
	

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

	reg [1:0]   busy_ff;

	always @( posedge clk_vga ) begin
		busy_ff <= { busy_ff[0], busy };
	end

	wire busy_o = busy_ff[1];

	hdmi_axi_addr #(
		.X_SIZE(X_SIZE),
		.Y_SIZE(Y_SIZE)
	) hdmi_axi_addr (
		.clk_vga(clk_vga),
		.rst(rst),
		.prefetch_line(prefetch_line),
		.pixelena_edge(pixelena_edge),

		.kick(kick),
		.busy(busy_o),
		.read_addr(read_addr),
		.read_num(read_num)
	);
	udp_axi udp_axi(
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

	always @ (posedge clk_vga) begin
		pixelena_edge <= {pixelena_edge[0],de};
	end
	always @ (posedge clk_vga) begin
		if(rst) begin
			x <= 16'h0;
			y <= 16'h0;
		end else begin
			if(framestart) begin
				x <= 16'h0;
				y <= 16'h0;
			end else if(pixelena_edge == 2'b10) begin
				x <= 16'h0;
				if(y < Y_SIZE)begin
					y <= y + 16'h1;
				end
			end else if(de) begin
				if(x < X_SIZE)begin
					x <= x + 16'h1;
				end
			end
		end
	end


	

	wire [7:0] red;
	wire [7:0] green;
	wire [7:0] blue;

	assign red = (img_de)?dataout[23:16]:8'h00;
	assign green = (img_de)?dataout[15:8]:8'h00;
	assign blue = (img_de)?dataout[7:0]:8'h00;

	dvi_tx tx(
		.clk(clk),
		.rst(rst),
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
