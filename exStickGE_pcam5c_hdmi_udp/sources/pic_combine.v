`default_nettype none

module pic_combine #(
	parameter WRITE_BASE_ADDR = 32'h0
)(
	input wire	CLK,
	input wire	RST,

	input wire	START,
	output wire END,
	//PIP Data DRAM READ
	output wire pip_kick,
	input wire pip_busy,
	output wire [31:0] pip_read_num,
	output wire [31:0] pip_read_addr,
	input wire [31:0] pip_buf_dout,
	input wire pip_buf_we,
	//Background Data DRAM READ
	output wire back_kick,
	input wire back_busy,
	output wire [31:0] back_read_num,
	output wire [31:0] back_read_addr,
	input wire [31:0] back_buf_dout,
	input wire back_buf_we,
	//DRAM WRITE
	output reg [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	output reg data_we,
	output reg [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	output wire ctrl_we,
	
	input wire [11:0] PIP_X,
	input wire [11:0] PIP_Y,
	input wire  [7:0] PIP_OPACITY
);

	//Result Size
	localparam BACK_WIDTH = 12'd1600;
	localparam BACK_HEIGHT = 12'd900;
	//PIP Size
	localparam PIP_WIDTH = 12'd640;
	localparam PIP_HEIGHT = 12'd480;


	localparam AMOUNT_ONCE = 8'd64;

	wire [31:0] pip_dout;
	wire pip_rden;
	wire [11:0] pip_rdcnt;
	wire [31:0] back_dout;
	wire back_rden;
	wire [11:0] back_rdcnt;

	reg [11:0] WPOS_X;
	reg [11:0] WPOS_Y;

	reg [2:0] state_READ;
	reg [2:0] state_READ_PIP;
	reg [2:0] state_WRITE;

	wire [11:0] READFIFO_CNT;
	wire WRITESTART;
	reg [1:0] START_edge;
	reg [11:0] PROCESS_POSY;

	localparam s_RST = 0;
	localparam s_WAIT = 1;
	localparam s_ADDRCALC = 2;
	localparam s_ADDRSET = 3;
	localparam s_NEXTWAIT = 4;
	localparam s_BUSYWAIT = 5;

	wire [23:0] data_rgb;
	reg [23:0] pip_rgb;
	reg [23:0] back_rgb;
	wire use_pip;
	reg use_pip_reg;
	reg data_we_delay;


	always @(posedge CLK) begin
		START_edge <= {START_edge[0],START};
	end

	reg [1:0] END_detect;
	always @(posedge CLK) begin
		END_detect <= {END_detect[0], ((state_READ == s_RST || state_READ == s_WAIT) && (state_WRITE == s_RST || state_WRITE == s_WAIT))};
	end
	assign END = END_detect == 2'b01;

//READ
	pic_read #(
		.WIDTH(PIP_WIDTH),
		.HEIGHT(PIP_HEIGHT)
	) u_pic_read_pcam (
		.CLK(CLK),
		.RST(RST),
		.START(START),
		.kick(pip_kick),
		.busy(pip_busy),
		.read_num(pip_read_num),
		.read_addr(pip_read_addr),
		.buf_dout(pip_buf_dout),
		.buf_we(pip_buf_we),
		.dout(pip_dout),
		.rd_en(pip_rden),
		.rd_cnt(pip_rdcnt)
	);

	pic_read #(
		.WIDTH(BACK_WIDTH),
		.HEIGHT(BACK_HEIGHT),
		.START_ADDR(32'h1000_000)
	) u_pic_read_back (
		.CLK(CLK),
		.RST(RST),
		.START(START),
		.kick(back_kick),
		.busy(back_busy),
		.read_num(back_read_num),
		.read_addr(back_read_addr),
		.buf_dout(back_buf_dout),
		.buf_we(back_buf_we),
		.dout(back_dout),
		.rd_en(back_rden),
		.rd_cnt(back_rdcnt)
	);
//Combine
	reg combRun;
	reg [11:0] combX;
	reg [11:0] combY;

	assign WRITESTART = combX == BACK_WIDTH - 12'h1;

	always @(posedge CLK) begin
		if(RST)
			combRun <= 1'b0;
		else if(combX == BACK_WIDTH - 12'h1)
			combRun <= 1'b0;
		else if(back_rdcnt > BACK_WIDTH - 12'h10 && (pip_rdcnt > PIP_WIDTH - 12'h10 ||  (combY >= PIP_Y + PIP_HEIGHT)))
			combRun <= 1'b1;
	end
	
	always @(posedge CLK) begin
		if(RST || START_edge == 2'b01)
			combX <= 12'h0;
		else if(combX == BACK_WIDTH - 12'h1)
			combX <= 12'h0;
		else if(combRun == 1'b1)
			combX <= combX + 12'h1;
		else
			combX <= 12'h0;
	end

	always @(posedge CLK) begin
		if(RST || START_edge == 2'b01)
			combY <= 12'h0;
		else if(combX == BACK_WIDTH - 12'h1)
			combY <= combY + 12'h1;
	end

	assign use_pip = ((PIP_X <= combX) && (combX < PIP_X + PIP_WIDTH) && (PIP_Y <= combY) && (combY < PIP_Y + PIP_HEIGHT));
	assign pip_rden = use_pip && combRun;
	assign back_rden = combRun;

	wire [15:0] combine_R = pip_dout[31:24] * PIP_OPACITY + back_dout[31:24] * (8'hff - PIP_OPACITY);
	wire [15:0] combine_G = pip_dout[23:16] * PIP_OPACITY + back_dout[23:16] * (8'hff - PIP_OPACITY);
	wire [15:0] combine_B = pip_dout[15:8] * PIP_OPACITY + back_dout[15:8] * (8'hff - PIP_OPACITY);

	always @(posedge CLK) begin
		back_rgb <= back_dout[31:8];
		pip_rgb <= {combine_R[15:8],combine_G[15:8],combine_B[15:8]};
		data_in <= {4'hf,(use_pip_reg?pip_rgb:back_rgb),8'hff};
		use_pip_reg <= use_pip;
		data_we_delay <= combRun;
		data_we <= data_we_delay;
	end


//Write
	assign ctrl_we = (state_WRITE == s_ADDRSET);
	always @(posedge CLK) begin
		if(RST)
			state_WRITE <= s_RST;
		else
			case (state_WRITE)
				s_RST: state_WRITE <= s_WAIT;
				s_WAIT:
					if(WRITESTART)
						state_WRITE <= s_ADDRCALC;
				s_ADDRCALC: state_WRITE <= s_ADDRSET;
				s_ADDRSET:
					if(WPOS_X < BACK_WIDTH)
						state_WRITE <= s_ADDRCALC;
					else if(WPOS_Y < BACK_HEIGHT)
						state_WRITE <= s_NEXTWAIT;
					else
						state_WRITE <= s_WAIT;
				s_NEXTWAIT:
					if(WRITESTART)
						state_WRITE <= s_ADDRCALC;
					else if(WPOS_Y == BACK_HEIGHT)
						state_WRITE <= s_WAIT;
				default: state_WRITE <= s_RST;
			endcase
	end
	always @(posedge CLK) begin
		if(RST)
			ctrl_in <= 40'h0;
		else if(state_WRITE == s_ADDRCALC)
			ctrl_in = {AMOUNT_ONCE, {WRITE_BASE_ADDR + {({18'h0,WPOS_Y} * {18'h0,BACK_WIDTH} + {18'h0,WPOS_X}),2'h0}}};
	end

	always @(posedge CLK) begin
		if(RST || state_WRITE == s_WAIT)
			WPOS_X <= 12'h0;
		else if(state_WRITE == s_ADDRCALC)			
			WPOS_X <= WPOS_X + AMOUNT_ONCE;
		else if(state_WRITE == s_NEXTWAIT)
			WPOS_X <= 12'h0;
	end

	always @(posedge CLK) begin
		if(RST || state_WRITE == s_WAIT)
			WPOS_Y <= 12'h0;
		else if(state_WRITE == s_ADDRSET && WPOS_X == BACK_WIDTH) begin
			if(WPOS_Y < BACK_HEIGHT)
				WPOS_Y <= WPOS_Y + 12'h1;
		end
	end
endmodule

`default_nettype wire