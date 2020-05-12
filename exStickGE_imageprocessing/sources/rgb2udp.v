`default_nettype none
module rgb2udp(
	input wire clk,
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
	//VIDEO
	input wire vid_clk,
	input wire hsync,
	input wire vsync_n,
	input wire de,
	input wire [23:0] rgb_data//red,blue,green
);
	wire vsync = ~vsync_n;
	localparam s_idle	= 0;
	localparam s_wait	= 1;
	localparam s_header	= 2;
	localparam s_data	= 3;

	assign r_ack = 1'b1;

	wire [11:0] v_cnt_o;
	wire [11:0] h_cnt_o;
	wire [23:0] rgb_data_o;

	reg [11:0] h_cnt;
	always @(posedge vid_clk) begin
		if(rst)
			h_cnt <= 12'h0;
		else if(hsync)
			h_cnt <= 12'h0;
		else if(de)
			h_cnt <= h_cnt + 12'h1;
	end
	reg [1:0]vsync_edge;
	always @(posedge vid_clk) begin
		vsync_edge <= {vsync_edge[0],vsync};
	end
	reg [1:0]de_edge;
	always @(posedge vid_clk) begin
		de_edge <= {de_edge[0],de};
	end
	reg [1:0]hsync_edge;
	always @(posedge vid_clk) begin
		hsync_edge <= {hsync_edge[0],hsync};
	end
	reg [11:0] v_cnt;
	always @(posedge vid_clk) begin
		if(rst)
			v_cnt <= 12'h0;
		else if(vsync)
			v_cnt <= 12'h0;
		else if(de_edge == 2'b10)
			v_cnt <= v_cnt + 12'h1;
	end

	reg [15:0] frame_cnt;
	always @(posedge vid_clk) begin
		if(rst)
			frame_cnt <= 16'h0;
		else if(vsync_edge == 2'b01)
			frame_cnt <= frame_cnt + 16'h1;
	end

	reg [11:0] v_cnt_ff [0:1];
	always @(posedge clk) begin
		v_cnt_ff[0] <= v_cnt;
		v_cnt_ff[1] <= v_cnt_ff[0];
	end

	wire [12:0]store_cnt;
	wire rd_en_fifo = (state == s_data);
	fifo_rgb fifo(
		.wr_clk(vid_clk),
		.rst(rst || vsync),
		.din({v_cnt,h_cnt,rgb_data[23:16],rgb_data[7:0],rgb_data[15:8]}),
		.wr_en(de && (v_cnt[1:0] == 2'b00)&&(h_cnt[1:0] == 2'b00)&&(frame_cnt[3:0] == 4'b0000)),
		//.empty(),
		.rd_clk(clk),
		.dout({v_cnt_o,h_cnt_o,rgb_data_o}),
		.rd_en(rd_en_fifo),
		.rd_data_count(store_cnt)
	);

	reg [1:0]state;
	reg [2:0] header_cnt;
	reg [11:0] data_cnt;

	assign w_req  = (state == s_wait);
	always @(posedge clk) begin
		if(rst)
			state <= s_idle;
		else
			case (state)
				s_idle: begin
					if(store_cnt > 13'd200)
						state <= s_wait;
				end
				s_wait: begin
					if(w_ack == 1'b1)
						state <= s_header;
				end
				s_header: begin
					if(header_cnt == 3'h4)
						state <= s_data;
				end
				s_data: begin
					if(data_cnt == 12'd199)
						state <= s_idle;
				end
				default: state <= s_idle;
			endcase
	end

	always  @(posedge clk) begin
			case (state)
				s_header: begin
					case (header_cnt)
						3'h0:	w_data <= 32'h0a000003;
						3'h1:	w_data <= 32'h0a000001;
						3'h2:	w_data <= 32'h40004000;
						3'h3:	w_data <= 32'h324;
						3'h4:	w_data <= {4'h0,v_cnt_o,4'h0,h_cnt_o};
						default: w_data <= 32'h00;
					endcase
				end
				s_data: begin
					w_data <= {rgb_data_o,8'hff};
				end
				default: w_data <= 32'h0;
			endcase
	end

//header
	always @(posedge clk) begin
		if(rst)
			header_cnt <= 3'h0;
		else if(state == s_header)
			header_cnt <= header_cnt + 3'h1;
		else
			header_cnt <= 3'h0;
	end
//data
	always @(posedge clk) begin
		if(rst)
			data_cnt <= 12'h0;
		else if(state == s_data)
			data_cnt <= data_cnt + 12'h1;
		else
			data_cnt <= 12'h0;
	end
//packet en
	always @ (posedge clk) begin
		if(state == s_header || state == s_data)
			w_enable <= 1'b1;
		else
			w_enable <= 1'b0;
	end
endmodule