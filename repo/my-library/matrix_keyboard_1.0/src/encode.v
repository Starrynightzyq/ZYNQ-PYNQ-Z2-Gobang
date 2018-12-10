`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/21 16:16:17
// Design Name: 
// Module Name: encode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module encode(
	input clk_100M,
	input rst_p,
	input en,

	input [15:0] key_num,

	output reg [3:0] key_code,
	output reg key_trick
    );

	/**
	 * 状态机
	 */
	localparam IDLE = 2'd0;
	localparam PUSH = 2'd1;
	localparam OUT = 2'd2;
	localparam READEN = 2'd3;

	reg key_push;
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			key_push <= 1'b0;
		end
		else if (en) begin
			if (key_num != 16'hFFFF) begin
				key_push <= 1'b1;
			end else begin
				key_push <= 1'b0;
			end
		end
	end
	// assign key_push = (key_num != 16'hffff) ? 1'b1 : 1'b0;

	reg [1:0] state_reg;
	reg [1:0] state_next;
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			state_reg <= IDLE;
		end
		else if (en) begin
			state_reg <= state_next;
		end
	end

	always @(*) begin
		state_next = state_reg;
		case(state_reg)
			IDLE : begin
				if (key_push) begin
					state_next = PUSH;
				end else begin
					state_next = state_reg;
				end
			end
			PUSH : begin
				if (key_push) begin
					state_next = state_reg;
				end else begin
					state_next = OUT;
				end
			end
			OUT : begin
				state_next = READEN;
			end
			READEN : begin
				state_next = IDLE;
			end
			default : begin
				state_next = IDLE;
			end
		endcase
	end


	/**
	 * key_temp
	 */
	reg [3:0] key_code_temp;
	reg abnormal;	//键盘异常信号
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			key_code_temp <= 4'b0;
		end
		else if (en) begin
			if (state_reg == PUSH) begin
				case(key_num)
					16'hFFFF : begin abnormal <= 0; end
					16'hFFFE : begin key_code_temp <= 4'h0; abnormal <= 0; end
					16'hFFFD : begin key_code_temp <= 4'h1; abnormal <= 0; end
					16'hFFFB : begin key_code_temp <= 4'h2; abnormal <= 0; end
					16'hFFF7 : begin key_code_temp <= 4'h3; abnormal <= 0; end
					16'hFFEF : begin key_code_temp <= 4'h4; abnormal <= 0; end
					16'hFFDF : begin key_code_temp <= 4'h5; abnormal <= 0; end
					16'hFFBF : begin key_code_temp <= 4'h6; abnormal <= 0; end
					16'hFF7F : begin key_code_temp <= 4'h7; abnormal <= 0; end
					16'hFEFF : begin key_code_temp <= 4'h8; abnormal <= 0; end
					16'hFDFF : begin key_code_temp <= 4'h9; abnormal <= 0; end
					16'hFBFF : begin key_code_temp <= 4'hA; abnormal <= 0; end
					16'hF7FF : begin key_code_temp <= 4'hB; abnormal <= 0; end
					16'hEFFF : begin key_code_temp <= 4'hC; abnormal <= 0; end
					16'hDFFF : begin key_code_temp <= 4'hD; abnormal <= 0; end
					16'hBFFF : begin key_code_temp <= 4'hE; abnormal <= 0; end
					16'h7FFF : begin key_code_temp <= 4'hF; abnormal <= 0; end
					default : begin  key_code_temp <= 4'hF; abnormal <= 1; end
				endcase
			end
		end
	end


	/**
	 * encode
	 */
	reg key_trick_temp;
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			key_code <= 4'b0;
			key_trick_temp <= 1'b0;
		end
		else if (en) begin
			case(state_reg)
				IDLE : begin
					key_code <= key_code;
					key_trick_temp <= 1'b0;
				end
				PUSH : begin
					key_code <= key_code;	//4'b0
					key_trick_temp <= 1'b0;
				end
				OUT : begin
					if (!abnormal) begin
						key_code <= key_code_temp;
						key_trick_temp <= 1'b0;
					end else begin
						key_code <= 4'b0;
						key_trick_temp <= 1'b0;
					end
				end
				READEN : begin
					if (!abnormal) begin
						key_code <= key_code;
						key_trick_temp <= 1'b1;
					end else begin
						key_code <= 4'b0;
						key_trick_temp <= 1'b0;
					end
				end
				default : begin
					key_code <= key_code;
					key_trick_temp <= 1'b0;
				end
			endcase
		end
	end


	localparam PUSH_IDLE = 2'd0;
	localparam PUSH_COUNT = 2'd1;
	localparam PUSH_CDONE = 2'd2;

	localparam COUNT_NUM = 6'd61;

	reg [2:0] push_state_reg;
	reg [2:0] push_state_next;
	reg count_done;
	reg [5:0] count_reg;

	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			push_state_reg <= PUSH_IDLE;
		end
		else if (en) begin
			push_state_reg <= push_state_next;
		end
	end

	always @(*) begin
		push_state_next = push_state_reg;
		case(push_state_reg)
			PUSH_IDLE:begin
				if (key_trick_temp) begin
					push_state_next = PUSH_COUNT;
				end else begin
					push_state_next = PUSH_IDLE;
				end
			end
			PUSH_COUNT:begin
				if (count_done) begin
					push_state_next = PUSH_CDONE;
				end else begin
					push_state_next = PUSH_COUNT;
				end
			end
			PUSH_CDONE:begin
				push_state_next = PUSH_IDLE;
			end
			default:begin
				push_state_next = PUSH_IDLE;
			end
		endcase
	end

	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			count_reg <= 6'b0;
		end
		else if (en && (push_state_reg == PUSH_COUNT)) begin
			if (count_reg == COUNT_NUM) begin
				count_reg <= 6'b0;
				count_done <= 1'b1;
			end else begin
				count_reg <= count_reg + 6'b1;
				count_done <= 1'b0;
			end
		end else begin
			count_reg <= 6'b0;
			count_done <= 1'b0;
		end
	end

	always @(*) begin
		key_trick = 1'b0;
		case(push_state_reg)
			PUSH_IDLE:begin
				key_trick = 1'b0;
			end
			PUSH_COUNT:begin
				key_trick = 1'b1;
			end
			PUSH_CDONE:begin
				key_trick = 1'b0;
			end
			default:begin
				key_trick = 1'b0;
			end
		endcase
	end

endmodule
