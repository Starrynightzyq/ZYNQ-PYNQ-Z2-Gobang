`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/21 12:46:40
// Design Name: 
// Module Name: matrix_keyboard
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


module scan_matrix_keyboard #(
	parameter NUM_200Hz = 500_000	//500_000
	)
	(
	input clk_100M,
	input rst_p,
	input en,

	input [3:0] col,	//矩阵键盘列接口
	output reg [3:0] row,	//矩阵键盘行接口

	output reg [15:0] key_out	//键值输出
    );

	/**
	 * 分频计数器，产生200Hz的信号
	 */
	reg [18:0] counter_200Hz;
	wire trick_200Hz_1;
	wire trick_200Hz_2;
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			counter_200Hz <= 19'b0;
		end
		else if (en) begin
			if (counter_200Hz >= (NUM_200Hz - 1)) begin
				counter_200Hz <= 19'b0;
			end else begin
				counter_200Hz <= counter_200Hz + 19'b1;
			end
		end
	end
	assign trick_200Hz_1 = (counter_200Hz == ((NUM_200Hz >> 1) - 1))&en&(!rst_p);
	assign trick_200Hz_2 = (counter_200Hz == (NUM_200Hz - 1))&en&(!rst_p);

	/**
	 * 状态机根据clk_200hz信号在4个状态间循环，每个状态对矩阵按键的行接口单行有效
	 */
	localparam	STATE0 = 2'b00;
	localparam	STATE1 = 2'b01;
	localparam	STATE2 = 2'b10;
	localparam	STATE3 = 2'b11;

	reg [1:0] state_reg;
	reg [1:0] state_next;
	
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			state_reg <= STATE0;
		end
		else if (en) begin
			state_reg <= state_next;
		end
	end

	always @(*) begin
		state_next = state_reg;
		if (trick_200Hz_1) begin
			case(state_reg)
				STATE0 : begin
					state_next = STATE1;
				end
				STATE1 : begin
					state_next = STATE2;
				end
				STATE2 : begin
					state_next = STATE3;
				end
				STATE3 : begin
					state_next = STATE0;
				end
				default : begin
					state_next = STATE0;
				end
			endcase
		end else begin
			state_next = state_reg;
		end
	end

	/**
	 * 产生row信号
	 */
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			row <= 4'b1110;
		end
		else if (en) begin
			case(state_reg)
				STATE0 : begin
					row <= 4'b1110;
				end
				STATE1 : begin
					row <= 4'b1101;
				end
				STATE2 : begin
					row <= 4'b1011;
				end
				STATE3 : begin
					row <= 4'b0111;
				end
				default : begin
					row <= 4'b1110;
				end
			endcase
		end
	end

	/**
	 * 采集col信号
	 */
	always @(posedge clk_100M or posedge rst_p) begin
		if (rst_p) begin
			// reset
			key_out <= 16'hffff;
		end
		else if (en & trick_200Hz_2) begin
			case(state_reg)
				STATE0 : begin
					key_out[3:0] <= col;
				end
				STATE1 : begin
					key_out[7:4] <= col;
				end
				STATE2 : begin
					key_out[11:8] <= col;
				end
				STATE3 : begin
					key_out[15:12] <= col;
				end
				default : begin
					key_out <= 16'hffff;
				end
			endcase
		end
	end

endmodule
