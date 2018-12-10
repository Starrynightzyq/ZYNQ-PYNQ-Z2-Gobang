`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/21 16:14:59
// Design Name: 
// Module Name: matrix_keyboard_top
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


module matrix_keyboard_top(
	input clk_100M,
	input rst_p,
	input en,

	input [3:0] col,	//矩阵键盘列接口
	output [3:0] row,	//矩阵键盘行接口

	output [3:0] key_code,
	output key_trick

    // output [15:0] key_num
    );


	/**
	 * 键盘扫描模块
	 */
	wire [15:0] key_num;
    scan_matrix_keyboard U_scan_matrix_keyboard (
    	.clk_100M(clk_100M),
    	.rst_p(rst_p),
    	.en(en),
    	.col(col),
    	.row(row),
    	.key_out(key_num)
    	);

	/**
	 * encode模块
	 */
    // wire  [3:0] key_code;
    encode U_encode (
    	.clk_100M(clk_100M),
    	.rst_p(rst_p),
    	.en(en),
    	.key_num(key_num),
    	.key_code(key_code),
    	.key_trick(key_trick)
    	);

endmodule
