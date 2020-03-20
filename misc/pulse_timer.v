`default_nettype none

module pulse_timer#(parameter CLK_PERIOD=5, parameter TIMER_VAL=1000)(
       input wire clk,
       input wire reset,
       output reg pulse_out
       );

   reg [15:0] counter = 16'd0;
   reg        reset_n = 1'b0;

   localparam COUNTER_VAL = TIMER_VAL / CLK_PERIOD;

   always @(posedge clk) begin
      if(reset == 1'b1) begin
	 counter   <= 16'd0;
         pulse_out <= 1'b0;
      end else begin
	 if(counter >= COUNTER_VAL) begin
            pulse_out <= 1'b1;
	    counter <= 0;
	 end else begin
            pulse_out <= 1'b0;
	    counter <= counter + 1;
	 end
      end
   end // always @ (posedge clk)

endmodule // pulse_timer


