module tmds_encoder #(
	parameter RESET_LEVEL = 1
)(
	RESET,
	CK,
	DE,
	C1,
	C0,
	D,
	Q
);
	input wire RESET;
	input wire CK;//clk;
	input wire DE;//de_in;
	input wire C1;//c1_in;
	input wire C0;//c0_in;
	input wire [7:0]D;//d_in;
	output reg [9:0]Q;//q_out;

	wire [3:0] N1_D = 4'd0 +D[7]+D[6]+D[5]+D[4]+D[3]+D[2]+D[1]+D[0] ;
	reg  [8:0] q_m;
	reg signed [4:0] cnt;
	reg  de_m, c0_m, c1_m;
	wire [4:0] N1_QM = 5'd0 +q_m[7]+q_m[6]+q_m[5]+q_m[4]+q_m[3]+q_m[2]+q_m[1]+q_m[0];
	
	//stage1
	always @ (posedge CK or posedge RESET) begin
	if(RESET == RESET_LEVEL) begin
		de_m <= 1'b0;
		c0_m <= 1'b0;
		c1_m <= 1'b0;
	end else if((N1_D>4'd4)||((N1_D==4'd4)&&(!D[0]))) begin
	//      if(1) begin
		q_m[0] <= D[0];
		q_m[1] <= D[0]~^D[1];
		q_m[2] <= D[0]~^D[1]~^D[2];
		q_m[3] <= D[0]~^D[1]~^D[2]~^D[3];
		q_m[4] <= D[0]~^D[1]~^D[2]~^D[3]~^D[4];
		q_m[5] <= D[0]~^D[1]~^D[2]~^D[3]~^D[4]~^D[5];
		q_m[6] <= D[0]~^D[1]~^D[2]~^D[3]~^D[4]~^D[5]~^D[6];
		q_m[7] <= D[0]~^D[1]~^D[2]~^D[3]~^D[4]~^D[5]~^D[6]~^D[7];
		q_m[8] <=1'b0;
		end else begin
		q_m[0] <= D[0];
		q_m[1] <= D[0]^D[1];
		q_m[2] <= D[0]^D[1]^D[2];
		q_m[3] <= D[0]^D[1]^D[2]^D[3];
		q_m[4] <= D[0]^D[1]^D[2]^D[3]^D[4];
		q_m[5] <= D[0]^D[1]^D[2]^D[3]^D[4]^D[5];
		q_m[6] <= D[0]^D[1]^D[2]^D[3]^D[4]^D[5]^D[6];
		q_m[7] <= D[0]^D[1]^D[2]^D[3]^D[4]^D[5]^D[6]^D[7];
		q_m[8] <=1'b1;
		end //if
		de_m <= DE;
		c0_m <= C0;
		c1_m <= C1;
	end //always
	
	//stage2
	always @ (posedge CK) begin
		if(!de_m) begin
		cnt <= 5'sd0;
		case({c1_m,c0_m})
			2'b00 : Q <= 10'b1101010100;
			2'b01 : Q <= 10'b0010101011;
			2'b10 : Q <= 10'b0101010100;
			2'b11 : Q <= 10'b1010101011;
		endcase
		end else begin
		if((cnt==5'sd0)||(N1_QM==5'd4)) begin
			Q <= {~q_m[8], q_m[8], q_m[8]?q_m[7:0]:~q_m[7:0]};
			if(q_m[8]) begin
			cnt <= cnt + (N1_QM+N1_QM-5'd8);
			end else begin 
			cnt <= cnt + (5'd8-N1_QM-N1_QM);
			end
		end else if(((cnt>5'sd0)&&(N1_QM>5'd4))||((cnt<5'sd0)&&(N1_QM<5'd4))) begin
			Q <= {1'b1, q_m[8], ~q_m[7:0]};
			cnt <= cnt + {3'b0,q_m[8],1'b0} + (5'd8-N1_QM-N1_QM);
		end else begin
			Q <= {1'b0, q_m[8], q_m[7:0]};
			cnt <= cnt - {3'b0,~q_m[8],1'b0} + (N1_QM+N1_QM-5'd8);
		end
		end //if
	end //always
endmodule