`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/14 10:29:03
// Design Name: 
// Module Name: decoder2axi
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


module decoder2axi(
	input clk,
	input rst_p,

	input [11:0] x_i,
	input [11:0] y_i,
	input [7:0] btn_i,
	input valid_i,

	output [3:0] seat_x_o,	//棋盘x坐标
	output [3:0] seat_y_o,	//棋盘y坐标
	output [3:0] vga_btn_o,	//屏幕上的按钮值
	output [1:0] value_choice,	// 0 光标在空白区域， 1 光标在棋盘区域， 2 光标在第一屏的按钮区域， 3 光标在第二屏的按钮区域

	output [7:0] btn_o,	// 按键值
	output btn_valid_o	// 按键中断信号，仅当按键信号为有效值时才产生中断
    );
endmodule
