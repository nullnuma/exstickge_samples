`default_nettype none

module resetgen(
       input wire  clk,
       input wire  reset_in,
       output wire reset_out
       );

   reg [15:0] counter = 16'd0;
   reg        reset_n = 1'b0;

   assign reset_out = ~reset_n;
   
   always @(posedge clk) begin
      if(reset_in == 1'b1) begin
	 counter <= 16'd0;
         reset_n <= 1'b0;
      end else begin
	 if(counter > 10000)
           reset_n <= 1'b1; // assert once
	 else
	   counter <= counter + 1;
      end
   end // always @ (posedge clk)

endmodule // resetgen

