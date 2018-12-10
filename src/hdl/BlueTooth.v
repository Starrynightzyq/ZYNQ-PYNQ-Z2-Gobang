`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/20 10:58:34
// Design Name: 
// Module Name: BlueTooth
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


module BlueTooth(
	input clk,
	input rst,
	input rx,
	output rx_done,
	output [7:0]x,
	output [7:0]y,
	output [7:0]btn,
	output valid
    );
	wire [7:0]data;
	
	uart_top #(
		.DVSR(27),.DATA_WIDTH(8), .SB_TICK(16)
	)U_uart_top (
		.clk(clk),
		.reset(rst),
		.rx(rx),
		.tx_btn(rx_done),
		.data_in(data),
		.data_out(data),
		.rx_done(rx_done)
	);
	decoder U_decoder(
		.clk(clk),
		.rx_done(rx_done),
		.data_in(data),
		.rst(rst),
		.x(x),
		.y(y),
		.btn(btn),
		.valid(valid)
    );
endmodule
