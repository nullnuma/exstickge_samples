`default_nettype none

module videoaxis2dram
  (
   input wire clk,
   input wire rst,
   //DRAM WRITE
   output reg [32+4-1:0] data_in,//strb[35:32] + data[31:0]
   output reg data_we,
   output reg [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
   output reg ctrl_we,
   //VIDEO
   input wire vid_clk,
   input wire s_axis_tuser, // Start of Frame
   input wire s_axis_tlast, // End of Line
   input wire s_axis_tvalid,
   input wire [23:0] s_axis_tdata, 
   output wire s_axis_tready,
   //Capture
   input wire capture_sig,
   output reg capture_rtn
   );

	assign s_axis_tready = 1;

	localparam WIDTH = 32'd1920;

	wire de = s_axis_tvalid;
	wire frame_start = s_axis_tuser && de;
	wire line_end = s_axis_tlast && de;
	wire capture_de = de && (capture_rtn || (capture_sig && frame_start));
	wire [23:0] rgb_data = s_axis_tdata;

	reg [1:0] edge_frame_start;
	reg [1:0] edge_line_end;

	reg [11:0] line_cnt;
	reg [11:0] pixel_cnt;
	reg [7:0] write_cnt;
	reg [31:0] address;

	

//Capture Ctrl
	always @(posedge vid_clk) begin
		if(rst)
			capture_rtn <= 1'b0;
		else if(frame_start == 1'b1)
			capture_rtn <= (capture_sig == 1'b1);
	end
//Edge Detect
	always @(posedge vid_clk) begin
		edge_frame_start <= {edge_frame_start[0],frame_start};
	end

	always @(posedge vid_clk) begin
		edge_line_end <= {edge_line_end[0],frame_start};
	end

//Counter
	//Line count
	always @(posedge vid_clk) begin
		if(rst)
			line_cnt <= 12'h0;
		else if(frame_start == 1'b1)
			line_cnt <= 12'h0;
		else if(line_end == 1'b1)
			line_cnt <= line_cnt + 12'h1;
	end
	//Pixel count
	always @(posedge vid_clk) begin
		if(rst)
			pixel_cnt <= 12'h0;
		else if(line_end == 1'b1)
			pixel_cnt <= 12'h0;
		else if(de)
			pixel_cnt <= pixel_cnt + 12'h1;
	end

	always @(posedge vid_clk) begin
		data_in <= {4'hf,rgb_data[23:16],rgb_data[15:8],rgb_data[7:0],8'hff};
		//data_in <= {4'hf,line_cnt[3:0],4'h0,write_cnt,pixel_cnt[7:0],8'hff};
		data_we <= capture_de && pixel_cnt < WIDTH;
	end
	always @(posedge vid_clk) begin
		if(rst)
			write_cnt <= 8'h0;
		else if(data_we)
			if(write_cnt < 8'd64 - 12'h1)//上限に達していなければ
				write_cnt <= write_cnt + 8'h1;
			else
				write_cnt <= 8'h0;
		else if(edge_line_end[0] == 1'b1)
			write_cnt <= 8'h0;
	end
	always @(posedge vid_clk) begin
		if(rst) begin
			ctrl_in <= 40'h0;
			ctrl_we <= 1'b0;
		end else if(data_we) begin
			if(write_cnt == 8'd63) begin//kickするタイミング
				ctrl_in <= {8'd64,address};
				ctrl_we <= 1'b1;
			end else begin
				ctrl_we <= 1'b0;
			end
		end else begin
			if(edge_line_end[0] == 1'b1 && write_cnt != 8'h0) begin
				ctrl_in <= {write_cnt + 8'h1,address};
				ctrl_we <= 1'b1;
			end else begin
				ctrl_we <= 1'b0;
			end
		end
	end

	always @(posedge vid_clk) begin
		if(rst)
			address <= 32'h0;
		else if(ctrl_we)
			address <= address + (ctrl_in[39:32]) * 32'h4;
		else if(frame_start)
			address <= 32'h0;
	end

	a4v2dram_ila u_a4v2dram_ila(
		.clk(vid_clk),
		.probe0(pixel_cnt),
		.probe1(line_cnt),
		.probe2(frame_start),
		.probe3(line_end),
		.probe4(s_axis_tuser),
		.probe5(s_axis_tlast),
		.probe6(s_axis_tready),
		.probe7(s_axis_tvalid),
		.probe8(capture_sig),
		.probe9(capture_rtn),
		.probe10(capture_de),
		.probe11(data_we),
		.probe12(data_in),
		.probe13(ctrl_we),
		.probe14(ctrl_in),
		.probe15(write_cnt)//,
		//.probe16(address)
	);
endmodule // videoaxi2dram

`default_nettype wire

