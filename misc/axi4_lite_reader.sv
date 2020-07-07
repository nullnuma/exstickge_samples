`default_nettype none

module axi4_lite_reader(
			input wire clk,
			input wire reset,
			
			input wire kick,
			output wire busy,
			input wire we,
			input wire [31:0] addr,
			input wire [31:0] din,
			output reg valid,
			output reg [31:0] q,

			output reg [31:0] m_axi_araddr,
			input wire m_axi_arready,
			output reg m_axi_arvalid,
			output reg [31:0] m_axi_awaddr,
			input wire m_axi_awready,
			output reg m_axi_awvalid,
			output reg m_axi_bready,
			input wire m_axi_bresp,
			input wire m_axi_bvalid,
			input wire [31:0] m_axi_rdata,
			output reg m_axi_rready,
			input wire m_axi_rresp,
			input wire m_axi_rvalid,
			output reg [31:0] m_axi_wdata,
			input wire m_axi_wready,
			output reg [3:0] m_axi_wstrb,
			output reg m_axi_wvalid
			);

    logic [31:0] counter;
    logic kick_r;

    assign busy = (counter == 0) ? 0 : 1;

    always @(posedge clk) begin
	if(reset == 1) begin
	    counter <= 0;
	    valid <= 0;
	    q <= 0;
	    m_axi_araddr <= 0;
	    m_axi_arvalid <= 0;
	    m_axi_awaddr <= 0;
	    m_axi_awvalid <= 0;
	    m_axi_bready <= 1;
	    m_axi_rready <= 1;
	    m_axi_wdata <= 0;
	    m_axi_wstrb <= 4'b1111;
	    m_axi_wvalid <= 0;
	    kick_r <= 1;
	end else begin
	    kick_r <= kick;
	    case(counter)
		0: begin
		    if(kick == 1 && kick_r == 0) begin
			if(we == 0) begin
			    counter <= 1;
			    m_axi_araddr <= addr;
			    m_axi_arvalid <= 1;
			end else begin
			    counter <= 2;
			    m_axi_awaddr <= addr;
			    m_axi_awvalid <= 1;
			    m_axi_wdata <= din;
			    m_axi_wvalid <= 1;
			end
		    end
		    valid <= 0;
		end
		1: begin
		    if(m_axi_arready == 1) begin
			m_axi_arvalid <= 0;
		    end
		    if(m_axi_rvalid == 1) begin
			valid <= 1;
			q <= m_axi_rdata;
			counter <= 0;
		    end
		end
		2: begin
		    if(m_axi_awready == 1) begin
			m_axi_awvalid <= 0;
		    end
		    if(m_axi_wready == 1) begin
			m_axi_wvalid <= 0;
		    end
		    if(m_axi_bvalid == 1) begin
			counter <= 0;
		    end
		end
		default: begin
		    counter <= 0;
		end
	    endcase // case (counter)
	end
    end


endmodule // axi4_lite_reader

`default_nettype wire

