`timescale 1ns / 1ps
module syncgen #(
) (
	//active high
	input wire reset,
	//typ 148.5MHz
	input wire video_clk,
	output wire framestart,
	output wire linestart,
	output wire prefetch_line,
	//pixel readout active
	output wire pixelena,
	output wire hsync,
	output wire vsync,
	output wire hblank,
	output wire vblank
);


	reg [11:0] hcount;
	reg [11:0] vcount;

	reg [11:0] bk_vbarcnt;
	reg [11:0] bk_hbarcnt;

	reg dibegina_reg;
	reg frame_reg;
	reg line_reg;
	reg hsync_reg;
	reg vsync_reg;
	reg hblank_reg;
	reg vblank_reg;

	reg [15:0] cblamp_sig;

	assign framestart = frame_reg;
	assign linestart  = line_reg;
	assign prefetch_line = (vcount == (V_SYNC + V_BACKP - 6));
	assign pixelena   = (hblank_reg == 1'b0 && vblank_reg == 1'b0)?1'b1:1'b0;

	assign hsync  = hsync_reg;
	assign vsync  = vsync_reg;
	assign hblank = hblank_reg;
	assign vblank = vblank_reg;


/*  900p  */
	localparam H_TOTAL  = 12'd1800;
	localparam H_SYNC   = 12'd80;
	localparam H_BACKP  = 12'd96;
	localparam H_ACTIVE = 12'd1600;
	localparam V_TOTAL  = 12'd1000;
	localparam V_SYNC   = 12'd3;
	localparam V_BACKP  = 12'd96;
	localparam V_ACTIVE = 12'd900;


	always@(posedge video_clk)begin
		if(reset == 1'b1)begin
			hcount <= H_TOTAL - 1;
			vcount <= V_TOTAL - 1;

			//Bar Cnt
			bk_vbarcnt <= 0; 
			bk_hbarcnt <= 0; 

			dibegina_reg <= 1'b0;
			frame_reg   <= 1'b0;
			line_reg    <= 1'b0;
			hsync_reg   <= 1'b0;
			vsync_reg   <= 1'b0;
			hblank_reg  <= 1'b1;
			vblank_reg  <= 1'b1;
		end
		else if (video_clk == 1'b1) begin

			if(hcount == 12'b0 && vcount == 12'b0)begin
				if (bk_vbarcnt == V_ACTIVE - 1)
					bk_vbarcnt <= 0;
				else
					bk_vbarcnt <= bk_vbarcnt + 1;

				if (bk_hbarcnt == H_ACTIVE - 1)
					bk_hbarcnt <= 0;
				else
					bk_hbarcnt <= bk_hbarcnt + 1;
			end

			if (hcount == H_TOTAL - 1) begin
				hcount <= 12'b0;
			end else begin
				hcount <= hcount + 1;
			end

			if (hcount == H_TOTAL - 1) begin
				hsync_reg <= 1'b1;
			end else if (hcount == H_SYNC - 1) begin
				hsync_reg <= 1'b0;
			end

			if (hcount == H_SYNC + H_BACKP-1) begin
				hblank_reg <= 1'b0;
			end else if (hcount == H_SYNC + H_BACKP + H_ACTIVE - 1) begin
				hblank_reg <= 1'b1;
			end

			if (hcount == H_SYNC + H_BACKP + H_ACTIVE-1) begin
				if (vcount == V_TOTAL-1) begin
					vcount <= 0;
				end else begin
					vcount <= vcount + 1;
				end

				if (vcount == V_TOTAL-1) begin
					vsync_reg <= 1'b1;
				end else if (vcount == V_SYNC-1) begin
					vsync_reg <= 1'b0;
				end

				if (vcount == V_SYNC + V_BACKP-1) begin
					vblank_reg <= 1'b0;
				end else if (vcount == V_SYNC + V_BACKP + V_ACTIVE-1) begin
					vblank_reg <= 1'b1;
				end
			end

			if (hcount == H_TOTAL-1) begin
				if (vcount == 0) begin
					frame_reg <= 1'b1;
				end else begin
					frame_reg <= 1'b0;
				end

				if (vblank_reg == 1'b0) begin
					line_reg <= 1'b1;
				end else begin
					line_reg <= 1'b0;
				end
			end else if (hcount == H_SYNC-1) begin
				frame_reg <= 1'b0;
				line_reg  <= 1'b0;
			end
		end
	end

endmodule
