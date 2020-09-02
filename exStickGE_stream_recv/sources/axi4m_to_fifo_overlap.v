`default_nettype none

module axi4m_to_fifo_overlap #(
	parameter C_M_AXI_ID_WIDTH = 4,
	parameter C_M_AXI_ADDR_WIDTH = 32,
	parameter C_M_AXI_DATA_WIDTH = 32
)(
		input wire clk,
		input wire reset,
		
		(* mark_debug = "true" *)input wire kick,
		(* mark_debug = "true" *)output wire busy,
		(* mark_debug = "true" *)input wire [31:0]read_num,
		(* mark_debug = "true" *)input wire [31:0]read_addr,
		
		output wire [C_M_AXI_ID_WIDTH-1:0] m_axi_arid,
		output reg [C_M_AXI_ADDR_WIDTH-1:0] m_axi_araddr,
		output reg [7:0] m_axi_arlen,
		output wire [2:0] m_axi_arsize,
		output wire [1:0] m_axi_arburst,
		output wire [0:0] m_axi_arlock,
		output wire [3:0] m_axi_arcache,
		output wire [2:0] m_axi_arprot,
		output wire m_axi_arvalid,
		input wire m_axi_arready,
		
		output wire m_axi_rready,
		input wire [C_M_AXI_ID_WIDTH-1:0] m_axi_rid,
		input wire [C_M_AXI_DATA_WIDTH-1:0] m_axi_rdata,
		input wire [1:0] m_axi_rresp,
		input wire m_axi_rlast,
		input wire m_axi_rvalid,
		
		output reg [C_M_AXI_DATA_WIDTH-1:0] buf_dout,
		output reg buf_we
);

	localparam MAX_BURST_LENGTH = 32'd64;

	
	(* mark_debug = "true" *)reg [2:0] state;
	localparam s_idle = 0;
	localparam s_kick = 1;
	localparam s_addrcalc = 2;
	localparam s_addrissue = 3;
	localparam s_datawait = 4;


	assign m_axi_arid = {C_M_AXI_ID_WIDTH{1'b0}};
	assign m_axi_arburst = 2'b01;
	assign m_axi_arlock = 1'b0;
	assign m_axi_arcache = 4'b0010;
	assign m_axi_arprot = 3'h0;
	assign m_axi_arsize = 3'b010;//4byte @TODO
	assign m_axi_arvalid = (state == s_addrissue);

	assign m_axi_rready = (state != s_idle);

	assign busy = (state != s_idle);


	(* mark_debug = "true" *)reg [7:0] issue_num;
	(* mark_debug = "true" *)reg [7:0] issue_num_cnt;
	(* mark_debug = "true" *)reg [31:0] read_num_buf;
	(* mark_debug = "true" *)reg [31:0] read_addr_buf;
	(* mark_debug = "true" *)reg [31:0] total_read_cnt;

	always @(posedge clk) begin
		if(reset == 1'b1) begin
			state <= s_idle;
		end else begin
			case (state)
				s_idle:
					if(kick == 1'b1)
						state <= s_kick;
				s_kick:
					state <= s_addrcalc;
				s_addrcalc:
					state <= s_addrissue;
				s_addrissue: begin
					if(m_axi_arready == 1'b1) begin
						if(read_num_buf > 32'h0)
							state <= s_addrcalc;
						else
							state <= s_datawait;
					end
				end
				s_datawait:
					if(issue_num_cnt == issue_num)
						state <= s_idle;
				default: state <= s_idle; 
			endcase
		end
	end

	always @(posedge clk) begin
		if(reset == 1'b1) begin
			read_num_buf <= 32'h0;
			read_addr_buf <= 32'h0;
		end else if(state == s_kick) begin
			read_num_buf <= read_num;
			read_addr_buf <= read_addr;
		end	else if(state == s_addrcalc) begin
			m_axi_arlen <= ((read_num_buf < MAX_BURST_LENGTH)?read_num_buf:MAX_BURST_LENGTH) - 32'h1;
			read_num_buf <= read_num_buf - ((read_num_buf < MAX_BURST_LENGTH)?read_num_buf:MAX_BURST_LENGTH);
			m_axi_araddr <= read_addr_buf;
			read_addr_buf <= read_addr_buf + (C_M_AXI_DATA_WIDTH/8) * ((read_num_buf < MAX_BURST_LENGTH)?read_num_buf:MAX_BURST_LENGTH);
		end
	end

	always @(posedge clk) begin
		if(reset == 1'b1 || state == s_idle)
			total_read_cnt <= 32'h0;
		else if(m_axi_rvalid == 1'b1 && m_axi_rready == 1'b1)
			total_read_cnt <= total_read_cnt + 32'h1;
	end
	always @(posedge clk) begin
		if(reset == 1'b1 || state == s_idle)
			issue_num <= 8'h0;
		else if(state == s_addrcalc)
			issue_num <= issue_num + 8'h1;
	end
	always @(posedge clk) begin
		if(reset == 1'b1 || state == s_idle)
			issue_num_cnt <= 8'h0;
		else if(m_axi_rvalid == 1'b1 && m_axi_rready == 1'b1 && m_axi_rlast == 1'b1)
			issue_num_cnt <= issue_num_cnt + 8'h1;
	end

	always @(posedge clk) begin
		if(m_axi_rvalid == 1'b1 && m_axi_rready == 1'b1) begin
			buf_dout <= m_axi_rdata;
			buf_we <= m_axi_rvalid;
		end else begin
			buf_dout <= {C_M_AXI_DATA_WIDTH{1'b0}};
			buf_we <= 1'b0;
		end
	end

endmodule