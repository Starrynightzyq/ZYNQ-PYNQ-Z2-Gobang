`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 18:42:20
// Design Name: 
// Module Name: uart_new
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


module uart_new #(
	parameter clk_freq = 100000000,
	parameter baud = 115200
) (
	input sys_clk,
	input sys_rst_n,

	input uart_rx,
	output uart_tx,

	output [7:0] rx_data,
	output rx_irq,

	input [7:0] tx_data,
	input tx_wr,
	output tx_irq
    );


parameter default_divisor = clk_freq/baud/16;

uart_transceiver U_transceiver(
	.sys_clk(sys_clk),
	.sys_rst(!sys_rst_n),

	.uart_rx(uart_rx),
	.uart_tx(uart_tx),

	.divisor(default_divisor),

	.rx_data(rx_data),
	.rx_done(rx_irq),

	.tx_data(tx_data),
	.tx_wr(tx_wr),
	.tx_done(tx_irq)
);

endmodule
