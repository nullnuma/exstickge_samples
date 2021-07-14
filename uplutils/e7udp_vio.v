`default_nettype none
/*
packet
---------------------------------------
  |       3|       2|       1|       0|
  |76543210|76543210|76543210|76543210|
---------------------------------------
 0|dst ip                             |dst ip(32)
 4|src ip                             |src ip(32)
 8|dst port         |src port         |dst port(16), src port(16)
12|chksum           |length           |chksum(16), length(16)
---------------------------------------
16|                 |      mo|addr    |mo(2): 0:in 1:out 2:info, addr(8)
# mode 0 set reg
20|in data                            |data(32)
# mode 1 get reg
none
# mode 2 info
none
*/

module e7udp_vio #(
	parameter INPUT_NUM = 1,
	parameter OUTPUT_NUM = 1
)(
	input wire clk,
	input wire rst,
	//UPL
	input wire r_req,
	input wire r_enable,
	output wire r_ack,
	input wire [31:0] r_data,
	output wire w_req,
	output reg w_enable,
	input wire w_ack,
	output reg [31:0] w_data,

	input wire [31:0] in0,
	input wire [31:0] in1,
	input wire [31:0] in2,
	input wire [31:0] in3,
	input wire [31:0] in4,
	input wire [31:0] in5,
	input wire [31:0] in6,
	input wire [31:0] in7,

	output wire [31:0] out0,
	output wire [31:0] out1,
	output wire [31:0] out2,
	output wire [31:0] out3,
	output wire [31:0] out4,
	output wire [31:0] out5,
	output wire [31:0] out6,
	output wire [31:0] out7
);


	wire [31:0] inport [INPUT_NUM - 1:0];
	reg [31:0] r_inport [INPUT_NUM - 1:0];
	reg [INPUT_NUM - 1:0] irq_inport;
	reg [31:0] outport [OUTPUT_NUM - 1:0];

	//Inport
	generate
		if (INPUT_NUM > 0) begin
			assign inport[0] = in0;
			always @(posedge clk) begin
				r_inport[0] <= inport[0];
				irq_inport[0] <= |(r_inport[0]- inport[0]);
			end
		end
		if (INPUT_NUM > 1) begin
			assign inport[1] = in1;
			always @(posedge clk) begin
				r_inport[1] <= inport[1];
				irq_inport[1] <= |(r_inport[1]- inport[1]);
			end
		end
		if (INPUT_NUM > 2) begin
			assign inport[2] = in2;
			always @(posedge clk) begin
				r_inport[2] <= inport[2];
				irq_inport[2] <= |(r_inport[2]- inport[2]);
			end
		end
		if (INPUT_NUM > 3) begin
			assign inport[3] = in3;
			always @(posedge clk) begin
				r_inport[3] <= inport[3];
				irq_inport[3] <= |(r_inport[3]- inport[3]);
			end
		end
		if (INPUT_NUM > 4) begin
			assign inport[4] = in4;
			always @(posedge clk) begin
				r_inport[4] <= inport[4];
				irq_inport[4] <= |(r_inport[4]- inport[4]);
			end
		end
		if (INPUT_NUM > 5) begin
			assign inport[5] = in5;
			always @(posedge clk) begin
				r_inport[5] <= inport[5];
				irq_inport[5] <= |(r_inport[5]- inport[5]);
			end
		end
		if (INPUT_NUM > 6) begin
			assign inport[6] = in6;
			always @(posedge clk) begin
				r_inport[6] <= inport[6];
				irq_inport[6] <= |(r_inport[6]- inport[6]);
			end
		end
		if (INPUT_NUM > 7) begin
			assign inport[7] = in7;
			always @(posedge clk) begin
				r_inport[7] <= inport[7];
				irq_inport[7] <= |(r_inport[7]- inport[7]);
			end
		end
	endgenerate

	//Outport
	generate
		if (OUTPUT_NUM > 0) begin
			assign out0 = outport[0];
		end
		if (OUTPUT_NUM > 1) begin
			assign out1 = outport[1];
		end
		if (OUTPUT_NUM > 2) begin
			assign out2 = outport[2];
		end
		if (OUTPUT_NUM > 3) begin
			assign out3 = outport[3];
		end
		if (OUTPUT_NUM > 4) begin
			assign out4 = outport[4];
		end
		if (OUTPUT_NUM > 5) begin
			assign out5 = outport[5];
		end
		if (OUTPUT_NUM > 6) begin
			assign out6 = outport[6];
		end
		if (OUTPUT_NUM > 7) begin
			assign out7 = outport[7];
		end
	endgenerate

	reg [2:0] header_cnt;
	reg [31:0] header_reg[0:3];
	reg [31:0] r_data_reg;
	reg [7:0] port_num;
	reg irq_ready;
	reg [INPUT_NUM - 1:0] irq_data;

	reg [3:0] state;
	localparam s_rst = 0;
	localparam s_wait = 1;
	localparam s_header = 2;
	localparam s_addr = 3;
	localparam s_write_wait = 4;
	localparam s_write_header = 5;
	localparam s_write_addr = 6;
	localparam s_write_data = 7;
	localparam s_read = 8;
	localparam s_irqsend_wait = 9;
	localparam s_irqsend_header = 10;
	localparam s_irqsend_data = 11;

	localparam s_drop = 15;

	reg [1:0] mode;
	localparam mode_in = 2'b00;//write to reg, udp read
	localparam mode_out = 2'b01;//read from reg, udp write
	localparam mode_info = 2'b10;//infomation, udp write
	localparam mode_irq = 2'b11;//irq

	assign r_ack = 1'b1;
	assign w_req = (state == s_write_wait || state == s_irqsend_wait);

	always @(posedge clk) begin
		if(rst)
			state <= s_rst;
		else
			case (state)
				s_rst:
					state <= s_wait;
				s_wait:
					if(r_enable)
						state <= s_header;
					else if((|irq_inport != 0) && irq_ready)
						state <= s_irqsend_wait;
				s_header:
					if(header_cnt == 3'b011)
						state <= s_addr;
				s_addr:
					case (r_data_reg[9:8])
						mode_in:
							state <= s_read;
						mode_out:
							state <= s_write_wait;
						mode_info:
							state <= s_write_wait;
						default:
							state <= s_drop;
					endcase
				s_write_wait:
					if(w_ack == 1'b1)
						state <= s_write_header;
				s_write_header:
					if(header_cnt == 3'b011)
						state <= s_write_addr;
				s_write_addr:
						state <= s_write_data;
				s_write_data:
						state <= s_drop;
				s_read:
					state <= s_drop;
				s_irqsend_wait:
					if(w_ack == 1'b1)
						state <= s_irqsend_header;
				s_irqsend_header:
					if(header_cnt == 3'b011)
						state <= s_irqsend_data;
				s_irqsend_data:
					state <= s_wait;
				s_drop:
					if(r_enable == 1'b0)
						state <= s_wait;
				default:
					state <= s_wait; 
			endcase
	end

	always @ (posedge clk) begin
		r_data_reg <= r_data;
	end
	always @(posedge clk) begin
		if(rst)
			irq_ready <= 1'b0;
		else if(state == s_header)
			irq_ready = 1'b1;
	end
	always @(posedge clk) begin
		if(rst)
			irq_data <= 0;
		else if(state == s_wait && (|irq_inport != 0))
			irq_data <= irq_inport;
	end

	//カウンタ
	always @ (posedge clk) begin
		if(state == s_header || state == s_write_header || state == s_irqsend_header)
			header_cnt <= header_cnt + 3'b001;
		else
			header_cnt <= 3'b000;
	end

	//UDPパケットヘッダ
	always @ (posedge clk) begin
		if(state == s_header)
			//UDPパケットヘッダ
			header_reg[header_cnt] <= r_data_reg;
		else if(state == s_write_wait)
			//UDPパケットサイズ設定
			header_reg[3] = 32'h8;
		else if(state == s_irqsend_wait)
			header_reg[3] = 32'h4;//可変
	end

	//モード
	always @(posedge clk) begin
		if(rst)
			mode <= 2'b00;
		else if(state == s_wait)
			mode <= 2'b00;
		else if(state == s_addr)
			mode <= r_data_reg[9:8];
		else if(state == s_irqsend_wait)
			mode <= mode_irq;
	end

	//ポート番号
	always @ (posedge clk) begin
		if(state == s_addr) begin
			port_num <= r_data_reg[7:0];
		end
	end

	//データ入力
	always @ (posedge clk) begin
		if(state == s_read && port_num < OUTPUT_NUM)
			outport[port_num] <= r_data_reg;
	end

	//データ出力
	always @ (posedge clk) begin
		if(state == s_write_header || state == s_irqsend_header)
			w_data <= header_reg[header_cnt];
		else if(state == s_write_addr)
			w_data <= {22'h00,mode, port_num};
		else if(state == s_write_data)
			case (mode)
				mode_out:
					w_data <= (port_num < INPUT_NUM)?inport[port_num]:32'h0; 
				mode_info:
					case (port_num)
						8'h0:
							w_data <= {16'h0,INPUT_NUM[7:0],OUTPUT_NUM[7:0]};
						default: 
							w_data <= 32'h0;
					endcase
				default: 
					w_data <= 32'h0;
			endcase
		else if(state == s_irqsend_data)
			w_data <= {22'h00,mode, {8-INPUT_NUM {1'b0}}, irq_data};

	end
	//イネーブル信号
	always @ (posedge clk) begin
		if(state == s_write_header || state == s_write_addr || state == s_write_data || state == s_irqsend_header || state == s_irqsend_data)
			w_enable <= 1'b1;
		else
			w_enable <= 1'b0;
	end
endmodule