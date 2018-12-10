`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 18:58:52
// Design Name: 
// Module Name: bluetooth_decoder
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


module bluetooth_decoder #(
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
	input rst_n,
	input rx_done,
	input [7:0]data_in,
	output [11:0] x_sum_o,
	output [11:0] y_sum_o,
	output [7:0] btn_o,
	output  valid_o
    );

    wire[7:0]x,y,btn;
    wire valid;
    wire [9:0] sum_x;
    wire [9:0] sum_y;

	decoder U_decoder(
		.clk(clk),
		.rx_done(rx_done),
		.data_in(data_in),
		.rst(!rst_n),
		.x(x),
		.y(y),
		.btn(btn),
		.valid(valid)
    );

    sum #(
        .X_START(X_START),
        .Y_START(Y_START),
        .X_MAX(X_MAX),
        .Y_MAX(Y_MAX),
        .X_EDGE(X_EDGE),
        .Y_EDGE(Y_EDGE),
        .X_MULT(X_MULT),
        .Y_MULT(Y_MULT),
        .CLICK_LONG(CLICK_LONG)
        )
    U_sum (
        .clk(clk),
        .rst_p(!rst_n),

        .valid(valid),
        .data_x(x),
        .data_y(y),
        .btn_i(btn),

        .sum_x(sum_x),
        .sum_y(sum_y),
        .btn_o(btn_o),
        .valid_o(valid_o)
        );


    assign x_sum_o = {2'b0, sum_x};
    assign y_sum_o = {2'b0, sum_y};
    assign btn_o = btn;

endmodule
