module pic_read #(
	parameter WIDTH = 32'h1600,
	parameter HEIGHT = 32'h900,
	parameter START_ADDR = 32'h0
)(
	input wire CLK,
	input wire RST,

	input wire START,
	//DRAM READ
	output wire kick,
	input wire busy,
	output wire [31:0] read_num,
	output reg [31:0] read_addr,
	input wire [31:0] buf_dout,
	input wire buf_we,
	//Output

	output wire [31:0] dout,
	input wire rd_en,
	output wire [11:0] rd_cnt
);

	localparam AMOUNT_ONCE = 8'd64;

	reg [11:0] RPOS_X;
	reg [11:0] RPOS_Y;

	reg [2:0] state_READ;

	localparam s_RST = 0;
	localparam s_WAIT = 1;
	localparam s_ADDRCALC = 2;
	localparam s_ADDRSET = 3;
	localparam s_NEXTWAIT = 4;
	localparam s_BUSYWAIT = 5;

	reg [1:0] START_edge;

	assign read_num = AMOUNT_ONCE;
	assign kick = (state_READ == s_ADDRSET);
	
	always @(posedge CLK) begin
		START_edge <= {START_edge[0],START};
	end

	
	fifo_rgbtmp u_fifo_pcam(
		.clk(CLK),
		.srst(RST),
		//.full(),
		.din(buf_dout),
		.wr_en(buf_we),
		//.empty(),
		.dout(dout),
		.rd_en(rd_en),
		.data_count(rd_cnt)
	);

	
	always @(posedge CLK) begin
		if(RST)
			state_READ <= s_RST;
		else
			case (state_READ)
				s_RST: state_READ <= s_WAIT;
				s_WAIT:
					if(START_edge == 2'b01)
						state_READ <= s_ADDRCALC;
				s_ADDRCALC: state_READ <= s_ADDRSET;
				s_ADDRSET:
					if(busy)
						state_READ <= s_BUSYWAIT;
				s_BUSYWAIT:begin
						if(~busy) begin
							if(RPOS_X < WIDTH) begin
								state_READ <= s_ADDRCALC;
							end else if(RPOS_Y < HEIGHT) begin
									state_READ <= s_NEXTWAIT;
							end else begin
									state_READ <= s_WAIT;
							end
						end
					end
				s_NEXTWAIT:
					if(rd_cnt == 12'h0)
						state_READ <= s_ADDRCALC;
					else if(RPOS_Y == HEIGHT)
						state_READ <= s_WAIT;
				default: state_READ <= s_RST;
			endcase
	end

	always @(posedge CLK) begin
		if(RST)
			read_addr <= 32'h0;
		else if(state_READ == s_ADDRCALC)
			read_addr <= START_ADDR + {({18'h0,RPOS_Y} * {18'h0,WIDTH} + {18'h0,RPOS_X}),2'h0};
	end

	always @(posedge CLK) begin
		if(RST || state_READ == s_WAIT)
			RPOS_X <= 12'h0;
		else if(state_READ == s_ADDRCALC)			
			RPOS_X <= RPOS_X + AMOUNT_ONCE;
		else if(state_READ == s_NEXTWAIT)
			RPOS_X <= 12'h0;
	end

	always @(posedge CLK) begin
		if(RST || state_READ == s_WAIT)
			RPOS_Y <= 12'h0;
		else if(state_READ == s_ADDRSET && RPOS_X == WIDTH && busy) begin
			if(RPOS_Y < HEIGHT)
				RPOS_Y <= RPOS_Y + 12'h1;
		end
	end
endmodule