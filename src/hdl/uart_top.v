`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Module Name: uart_top

//////////////////////////////////////////////////////////////////////////////////


module uart_top #(parameter DVSR = 651,DATA_WIDTH = 8, SB_TICK = 16) (
    input wire clk,reset,
    input wire rx,tx_btn,
    input wire [DATA_WIDTH-1:0]data_in,
    output wire [DATA_WIDTH-1:0]data_out,
    output wire rx_done,tx_done,
    output wire tx
    );
    
    wire s_tick;
    wire [DATA_WIDTH-1:0]rx_reg;
    
    clk #(.DVSR(DVSR)) CLK_div(
        .clk(clk),
        .reset(reset),
        .tick(s_tick)
    );
    
    uart_rx #(.DATA_WIDTH(DATA_WIDTH),.SB_TICK(SB_TICK)) RX(
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick),
        .rx(rx),
        .dout(data_out),
        .done(rx_done)
    );
    
    reg btn_buf;
    wire tx_start;
    always@(posedge clk)begin
        btn_buf = tx_btn;
    end
    assign tx_start = ~btn_buf & tx_btn;
    
    uart_tx #(.DATA_WIDTH(DATA_WIDTH),.SB_TICK(SB_TICK)) TX(
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick),
        .din(data_in),
        .tx_start(tx_start),
        .tx(tx),
        .tx_done(tx_done)
    );
    
endmodule
