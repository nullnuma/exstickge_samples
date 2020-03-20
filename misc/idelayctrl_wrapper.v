`default_nettype none

module idelayctrl_wrapper#(parameter CLK_PERIOD=5)
   (
    input wire clk,
    input wire reset,
    output wire ready
    );

   wire        pulse_100us;
   pulse_timer#(.CLK_PERIOD(CLK_PERIOD), .TIMER_VAL(100000))
   pulse_timer_i(.clk(clk), .reset(reset), .pulse_out(pulse_100us));

   reg 	       idctl_rst = 1'b0;
   reg [1:0]   idctl_rst_state = 2'b0;

   always @(posedge clk) begin
      if (pulse_100us == 1'b1) begin
         case(idctl_rst_state)
           2'b00: begin
              idctl_rst <= 1'b0;
              idctl_rst_state <= idctl_rst_state + 1;
	   end
           2'b01: begin
              idctl_rst <= 1'b1;
              idctl_rst_state <= idctl_rst_state + 1;
	   end
           2'b10: begin
              idctl_rst <= 1'b0;
	   end
	   default:
	     idctl_rst_state <= 2'b00;
         endcase // case (idctl_rst_state)
      end // if (pulse_100us == 1'b1)
   end // always @ (posedge clk)
   
   IDELAYCTRL IDELAYCTRL_i(.RDY(ready), .REFCLK(clk), .RST(idctl_rst));

endmodule // idelayctrl_wrapper

`default_nettype wire
