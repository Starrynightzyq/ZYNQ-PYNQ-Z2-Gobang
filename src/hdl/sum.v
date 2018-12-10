`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 20:35:08
// Design Name: 
// Module Name: sum
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


module sum #(
	parameter X_START = 320,
	parameter Y_START = 240,
	parameter X_MAX = 640,
	parameter Y_MAX = 480,
	parameter X_EDGE = 11,
	parameter Y_EDGE = 11,
	parameter X_MULT = 1,
	parameter Y_MULT = 1,
	parameter CLICK_LONG = 3
	)(
	input clk,
	input rst_p,

	input valid,
	input [7:0] data_x,
	input [7:0] data_y,
	input [7:0] btn_i,

	output [9:0] sum_x,
	output [9:0] sum_y,
	output [7:0] btn_o,
	output valid_o
    );

    localparam TWO_8 = 128;	//2^8 用于计算补码

    reg reset_sum;

    wire minus_x;		//符号位
    wire minus_y;
    wire [7:0] true_x;	//原码
    wire [7:0] true_y;	//原码

    reg [9:0] sum_x_reg;
    reg [9:0] sum_y_reg;
    reg [9:0] sum_x_next;
    reg [9:0] sum_y_next;

    reg valid_1;
    reg valid_2;

    assign minus_x = data_x[7];
    assign minus_y = data_y[7];
    assign true_x = minus_x ? (TWO_8 - data_x[6:0]) : data_x;
    assign true_y = minus_y ? (TWO_8 - data_y[6:0]) : data_y;

    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
    		// reset
    		valid_1 <= 1'b0;
    		valid_2 <= 1'b0;
    	end
    	else begin
    		valid_1 <= valid;
    		valid_2 <= valid_1;
    	end
    end
    assign valid_o = valid_2;

	always @(posedge clk or posedge rst_p) begin
		if (rst_p || reset_sum) begin
			// reset
			sum_x_reg <= X_START - 1;
			sum_y_reg <= Y_START - 1;
		end
		else if (valid_1) begin
			sum_x_reg <= sum_x_next;
			sum_y_reg <= sum_y_next;
		end
	end

	always @(*) begin
		sum_x_next = sum_x_reg;
		if(minus_x == 1'b0) begin 	//正数
			if((sum_x_reg + true_x) < (X_MAX - X_EDGE)) begin
				sum_x_next = sum_x_reg + true_x[6:X_MULT];
			end else begin
				sum_x_next = X_MAX - X_EDGE;
			end
		end else begin 	//负数
			if (sum_x_reg > true_x) begin
				sum_x_next = sum_x_reg - true_x[6:X_MULT];
			end else begin
				sum_x_next = 10'b0;
			end
		end
	end

	always @(*) begin
		sum_y_next = sum_y_reg;
		if(minus_y == 1'b0) begin 	//正数
			if((sum_y_reg + true_y) < (Y_MAX - Y_EDGE)) begin
				sum_y_next = sum_y_reg + true_y[6:Y_MULT];
			end else begin
				sum_y_next = Y_MAX - Y_EDGE;
			end
		end else begin 	//负数
			if (sum_y_reg > true_y) begin
				sum_y_next = sum_y_reg - true_y[6:Y_MULT];
			end else begin
				sum_y_next = 10'b0;
			end
		end
	end

	always @(posedge clk or posedge rst_p) begin
		if (rst_p) begin
			// reset
			reset_sum <= 1'b0;
		end
		else if ((btn_i == CLICK_LONG) && valid_1) begin
			reset_sum <= 1'b1;
		end else begin
			reset_sum <= 1'b0;
		end
	end

	assign sum_x = sum_x_reg;
	assign sum_y = sum_y_reg;
	assign btn_o = btn_i;

endmodule
