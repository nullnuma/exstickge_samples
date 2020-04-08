`timescale 1ns/1ps
module hdmi_axi_addr_tb();

localparam integer STEP  = 5;
localparam X_SIZE = 12'd256;
localparam Y_SIZE = 12'd256;

reg CLK;
reg rst;
reg busy;
wire kick;
wire [31:0] read_addr;
reg [1:0]pixelena_edge;
wire prefetch_line;
wire de;
wire hblank;
wire vblank;
assign de = (!hblank) && (!vblank);

always @ (posedge CLK) begin
	pixelena_edge <= {pixelena_edge[0],de};
end

always begin
	CLK = 0; #(STEP/5*3);
	CLK = 1; #(STEP/5*2);
end
initial begin
	rst <= 1'b1;
	#(STEP*500);
	rst = 1'b0;
	#(10 * 1000 * 1000);//10ms
	$stop;
	
end

reg [31:0] random_temp = 5;
initial begin
	busy <= 1'b0;
	forever begin
		 @(posedge kick);
		 #(STEP);
		busy <= 1'b1;
		random_temp = random_temp + 1;
		#(STEP + 40 + random_temp[3:0]);
		busy <= 1'b0;
	end
end
	hdmi_axi_addr #(
		.X_SIZE(X_SIZE),
		.Y_SIZE(Y_SIZE)
	) hdmi_axi_addr (
		.clk_vga(CLK),
		.rst(rst),
		.prefetch_line(prefetch_line),
		.pixelena_edge(pixelena_edge),

		.kick(kick),
		.busy(busy),
		.read_addr(read_addr),
		.read_num(read_num)
	);

	syncgen gen (
		.video_clk(CLK),
		.reset(rst),
		.framestart(framestart),
		.linestart(linestart),
		.prefetch_line(prefetch_line),
		.hblank(hblank),
		.vblank(vblank)
	);

endmodule