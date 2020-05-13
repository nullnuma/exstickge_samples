`default_nettype none
module dram_copy(
	input wire	CLK,
	input wire	RST,

	input wire	START,
	//DRAM READ
	output wire kick,
	input wire busy,
	output wire [31:0] read_num,
	output reg [31:0] read_addr,
	input wire [31:0] buf_dout,
	input wire buf_we,
	//DRAM WRITE
	output wire [32+4-1:0] data_in,//strb[35:32] + data[31:0]
	output wire data_we,
	output reg [32+8-1:0]ctrl_in,//len[39:32] + addr[31:0]
	output wire ctrl_we
);

	localparam WIDTH = 12'd1600;
	localparam HEIGHT = 12'd900;

	localparam AMOUNT_ONCE = 8'd64;

	localparam READ_BASE_ADDR = 32'h0;
	localparam WRITE_BASE_ADDR = 32'h100_0000;


	(* mark_debug = "true" *)reg [11:0] RPOS_X;
	(* mark_debug = "true" *)reg [11:0] RPOS_Y;
	(* mark_debug = "true" *)reg [11:0] WPOS_X;
	(* mark_debug = "true" *)reg [11:0] WPOS_Y;

	(* mark_debug = "true" *)reg [2:0] state_READ;
	(* mark_debug = "true" *)reg [2:0] state_WRITE;

	(* mark_debug = "true" *)wire [11:0] READFIFO_CNT;
	(* mark_debug = "true" *)wire WRITESTART;

	localparam s_RST = 0;
	localparam s_WAIT = 1;
	localparam s_ADDRCALC = 2;
	localparam s_ADDRSET = 3;
	localparam s_NEXTWAIT = 4;
	localparam s_BUSYWAIT = 5;

//READ

	assign read_num = AMOUNT_ONCE;
	assign kick = (state_READ == s_ADDRSET);

	wire [31:0] processing_in_data;
	wire processing_in_rd;
	fifo_rgbtmp fifo(
		.clk(CLK),
		.srst(RST),
		//.full(),
		.din(buf_dout),
		.wr_en(buf_we),
		//.empty(),
		.dout(processing_in_data),
		.rd_en(processing_in_rd),
		.data_count(READFIFO_CNT)
	);

	always @(posedge CLK) begin
		if(RST)
			state_READ <= s_RST;
		else
			case (state_READ)
				s_RST: state_READ <= s_WAIT;
				s_WAIT:
					if(START)
						state_READ <= s_ADDRCALC;
				s_ADDRCALC: state_READ <= s_ADDRSET;
				s_ADDRSET:
					if(busy)
						state_READ <= s_BUSYWAIT;
				s_BUSYWAIT:begin
						if(~busy) begin
							if(RPOS_X < WIDTH) begin
								state_READ <= s_ADDRCALC;
							end else if(RPOS_Y < HEIGHT - 12'h1) begin
									state_READ <= s_NEXTWAIT;
							end else begin
									state_READ <= s_WAIT;
							end
						end
					end
				s_NEXTWAIT:
					if(READFIFO_CNT == 12'h0)
						state_READ <= s_ADDRCALC;
					
				default: state_READ <= s_RST;
			endcase
	end

	always @(posedge CLK) begin
		if(RST)
			read_addr <= 32'h0;
		else if(state_READ == s_ADDRCALC)
			read_addr <= READ_BASE_ADDR + {(RPOS_Y * WIDTH + RPOS_X),2'h0};
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
			else
				RPOS_Y <= 12'h0;
		end
	end

//Processing
	processing u_processing(
		.CLK(CLK),
		.RST(RST),
		.READ_LINE_DONE(READFIFO_CNT > WIDTH - 12'h10),//修正予定
		.IN_DE(processing_in_rd),
		.IN_DATA(processing_in_data),
		.WRITE_LINE_DONE(WRITESTART),
		.OUT_DE(data_we),
		.OUT_DATA(data_in[31:0])
	);
	assign data_in[35:32] = 4'hf;

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
					if(WPOS_X < WIDTH)
						state_WRITE <= s_ADDRCALC;
					else if(WPOS_Y < HEIGHT)
						state_WRITE <= s_NEXTWAIT;
					else
						state_WRITE <= s_WAIT;
				s_NEXTWAIT:
					if(WRITESTART)
						state_WRITE <= s_ADDRCALC;

				default: state_WRITE <= s_RST;
			endcase
	end
	always @(posedge CLK) begin
		if(RST)
			ctrl_in <= 40'h0;
		else if(state_WRITE == s_ADDRCALC)
			ctrl_in = {AMOUNT_ONCE, {WRITE_BASE_ADDR + {(WPOS_Y * WIDTH + WPOS_X),2'h0}}};
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
		if(RST || state_READ == s_WAIT)
			WPOS_Y <= 12'h0;
		else if(WRITESTART && (state_WRITE == s_NEXTWAIT)) begin
			if(WPOS_Y < HEIGHT)
				WPOS_Y <= WPOS_Y + 12'h1;
			else
				WPOS_Y <= 12'h0;
		end
	end
endmodule