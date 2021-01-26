`default_nettype none

module rgb2videoaxis
	(
	input wire vid_clk,
	input wire rst,
	//RGB Video In
	input wire hsync,
	input wire vsync_n,
	input wire de,
	input wire [23:0] rgb_data,//red,blue,green
	//AXI Video Stream Out
	output reg m_axis_tuser, // Start of Frame
	output wire m_axis_tlast, // End of Line
	output reg m_axis_tvalid,
	output reg [23:0] m_axis_tdata, 
	input wire m_axis_tready
	);


	localparam WIDTH = 32'd1600;

//Vsync
	wire vsync;
// Video Param
	//X
	reg [15:0] in_horizontal;
	//Y
	reg [15:0] in_vertical;
//Counter
	reg [11:0] x_cnt;
	reg [11:0] y_cnt;
// Video Sig Edge
	reg [1:0]hsync_edge;
	reg [1:0]vsync_edge;
	reg [1:0]de_edge;
// AXI Video Stream
	reg frame_started;

//Assign
	assign vsync = ~vsync_n;
	assign m_axis_tlast = {de_edge[0], de} == 2'b10;

// Video Sig Edge
	always @(posedge vid_clk) begin
		hsync_edge <= {hsync_edge[0],hsync};
	end
	always @(posedge vid_clk) begin
		vsync_edge <= {vsync_edge[0],vsync};
	end
	always @(posedge vid_clk) begin
		de_edge <= {de_edge[0],de};
	end

// Counter
	always @(posedge vid_clk) begin
		if(rst)
			x_cnt <= 16'h0;
		else if(hsync_edge == 2'b01)
			x_cnt <= 16'h0;
		else if(de)
			x_cnt <= x_cnt + 16'h1;
	end
	always @(posedge vid_clk) begin
		if(rst)
			y_cnt <= 16'h0;
		else if(vsync_edge == 2'b01)
			y_cnt <= 16'h0;
		else if(de_edge == 2'b10)
			y_cnt <= y_cnt + 16'h1;
	end

// horizontal vertical
	always @(posedge vid_clk) begin
		if(rst)
			in_horizontal <= 16'h0;
		else if(de_edge == 2'b10)
			in_horizontal <= x_cnt;
	end
	always @(posedge vid_clk) begin
		if(rst)
			in_vertical <= 16'h0;
		else if(vsync_edge == 2'b01)
			in_vertical <= y_cnt;
	end

// AXI Video Stream
	always @(posedge vid_clk) begin
		if(rst)
			frame_started <= 1'h0;
		else if(frame_started == 1'b0 && de == 1'b1)
			frame_started <= 1'b1;
		else if(vsync_edge == 2'b10)
			frame_started <= 1'b0;
	end

	always @(posedge vid_clk) begin
		m_axis_tuser <= frame_started == 1'b0 && de == 1'b1;
		m_axis_tvalid <= de;
		m_axis_tdata <= rgb_data;
	end

endmodule // rgb2ideoaxis

`default_nettype wire

