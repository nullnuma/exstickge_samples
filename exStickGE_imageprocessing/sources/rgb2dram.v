`default_nettype none
module rgb2dram(
	input wire clk,
	input wire rst,
	//DRAM WRITE
	output wire [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	output wire data_we,
	output reg [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	output reg ctrl_we,
	//VIDEO
	input wire vid_clk,
	input wire hsync,
	input wire vsync_n,
	input wire de,
	input wire [23:0] rgb_data,//red,blue,green
	//Capture
	input wire capture_sig,
	output reg capture_rtn,
	output reg capture_done
);

	localparam WIDTH = 32'd1600;
	wire vsync = ~vsync_n;

	wire capture_de = de && capture_rtn;

	wire [23:0] rgb_data_o;

	assign data_in = {4'hf,rgb_data[23:16],rgb_data[7:0],rgb_data[15:8],8'hff};
	assign data_we = capture_de;

//キャプチャ
	reg [1:0]vsync_edge;
	always @(posedge vid_clk) begin
		vsync_edge <= {vsync_edge[0],vsync};
	end
	always @(posedge vid_clk) begin
		if(rst)
			capture_rtn <= 1'b0;
		else if(vsync_edge == 2'b01)
			capture_rtn <= (capture_sig == 1'b1);
	end
	always @(posedge vid_clk) begin
		if(rst)
			capture_done <= 1'b0;
		else if(vsync_edge == 2'b01)
			capture_done <= capture_rtn;
	end
	
//カウンタ
	reg [11:0] x_cnt;
	always @(posedge vid_clk) begin
		if(rst)
			x_cnt <= 12'h0;
		else if(hsync)
			x_cnt <= 12'h0;
		else if(capture_de)
			x_cnt <= x_cnt + 12'h1;
	end
	reg [1:0]vsync_edge;
	always @(posedge vid_clk) begin
		vsync_edge <= {vsync_edge[0],vsync};
	end
	reg [1:0]de_edge;
	always @(posedge vid_clk) begin
		de_edge <= {de_edge[0],capture_de};
	end
	reg [1:0]hsync_edge;
	always @(posedge vid_clk) begin
		hsync_edge <= {hsync_edge[0],hsync};
	end
	reg [11:0] y_cnt;
	always @(posedge vid_clk) begin
		if(rst)
			y_cnt <= 12'h0;
		else if(vsync)
			y_cnt <= 12'h0;
		else if(de_edge == 2'b10)
			y_cnt <= y_cnt + 12'h1;
	end
	reg [7:0] write_cnt;
	always @(posedge vid_clk) begin
		if(rst)
			write_cnt <= 8'h0;
		else if(capture_de)
			if(write_cnt < 8'd64 - 12'h1)//上限に達していなければ
				write_cnt <= write_cnt + 8'h1;
			else
				write_cnt <= 8'h0;
		else
			write_cnt <= 8'h0;
	end

	wire [31:0] address = ((y_cnt * WIDTH) + (x_cnt - write_cnt)) * 32'h4;
	always @(posedge vid_clk) begin
		if(rst) begin
			ctrl_in <= 40'h0;
			ctrl_we <= 1'b0;
		end else if(capture_de) begin
			if(write_cnt == 8'd63) begin//kickするタイミング
				ctrl_in <= {8'd64,address};
				ctrl_we <= 1'b1;
			end else begin
				ctrl_we <= 1'b0;
			end
		end else begin
			if(write_cnt != 8'h0) begin
				ctrl_in <= {write_cnt+ 8'h1,address};
				ctrl_we <= 1'b1;
			end else begin
				ctrl_we <= 1'b0;
			end
		end
	end
endmodule