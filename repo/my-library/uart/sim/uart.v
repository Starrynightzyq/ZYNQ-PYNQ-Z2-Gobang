/*
 * Milkymist VJ SoC
 * Copyright (C) 2007, 2008, 2009, 2010 Sebastien Bourdeauducq
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

module uart #(
	parameter clk_freq = 100000000,
	parameter baud = 115200
) (
	input sys_clk,
	input sys_rst,

	input [7:0] txd_data,
	input txd_wr_en,
	output txd_empty,
	output txd_full,

	output [7:0] rxd_data,
	input rxd_rd_en,
	output rxd_empty,
	output rxd_full,

	input uart_rx,
	output uart_tx
);

parameter default_divisor = clk_freq/baud/16;

wire [7:0] rx_data;
wire [7:0] tx_data;
wire tx_wr;
wire rx_irq;
wire tx_irq;

uart_transceiver U_transceiver(
	.sys_clk(sys_clk),
	.sys_rst(sys_rst),

	.uart_rx(uart_rx),
	.uart_tx(uart_tx),

	.divisor(default_divisor),

	.rx_data(rx_data),
	.rx_done(rx_irq),

	.tx_data(tx_data),
	.tx_wr(tx_wr),
	.tx_done(tx_irq)
);


fifo_rx U_fifo_rx (
  .clk(sys_clk),      // input wire clk
  .srst(sys_rst),    // input wire srst
  .din(rx_data),      // input wire [7 : 0] din
  .wr_en(rx_irq),  // input wire wr_en
  .rd_en(rxd_rd_en),  // input wire rd_en
  .dout(rxd_data),    // output wire [7 : 0] dout
  .full(rxd_full),    // output wire full
  .empty(rxd_empty)  // output wire empty
);

wire fifo_tx_empty;
wire fifo_tx_rd_en;
fifo_tx U_fifo_tx (
  .clk(sys_clk),      // input wire clk
  .srst(sys_rst),    // input wire srst
  .din(txd_data),      // input wire [7 : 0] din
  .wr_en(txd_wr_en),  // input wire wr_en
  .rd_en(fifo_tx_rd_en),  // input wire rd_en
  .dout(tx_data),    // output wire [7 : 0] dout
  .full(txd_full),    // output wire full
  .empty(fifo_tx_empty)  // output wire empty
);

assign tx_wr = tx_wr_en;
assign txd_empty = fifo_tx_empty;

reg fifo_tx_empty_1 = 0;
wire fifo_tx_empty_p;
always @(posedge sys_rst) begin
	fifo_tx_empty_1 <= fifo_tx_empty;
end
assign fifo_tx_empty_p = fifo_tx_empty&(!fifo_tx_empty_1);

assign fifo_tx_rd_en = fifo_tx_empty_p | tx_irq;

reg tx_wr_en = 0;
always @(posedge sys_clk) begin
	tx_wr_en <= fifo_tx_rd_en;
end

endmodule
