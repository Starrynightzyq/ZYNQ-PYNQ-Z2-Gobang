`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/26 11:56:21
// Design Name: 
// Module Name: final_top
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


module final_top(
       input wire clk,reset,rx,
       output hsync,vsync,
       output[2:0] rgb

    );
    wire ram_on,xie_on;
    wire rx_done;
    wire[7:0]x,y,btn;
    wire valid;
    wire[9:0]x_sum_1,
             x_sum_2,
             x_sum_3,
             x_sum_4,
             x_sum_5,
             y_sum_1,
             y_sum_2,
             y_sum_3,
             y_sum_4,
             y_sum_5;
    wire color_on;
    wire xiangpica_on;
   
    BlueTooth uut1(.clk(clk),.rst(~reset),.rx(rx),.rx_done(rx_done),.x(x),.y(y),
    .btn(btn),.valid(valid));
    
    sum_xy uut2(.x(x),.y(y),.btn(btn),.clk(clk),.reset(~reset),.valid(valid),
    .x_sum_1(x_sum_1),.y_sum_1(y_sum_1),
    .x_sum_2(x_sum_2),.y_sum_2(y_sum_2),
    .x_sum_3(x_sum_3),.y_sum_3(y_sum_3),
    .x_sum_4(x_sum_4),.y_sum_4(y_sum_4),
    .x_sum_5(x_sum_5),.y_sum_5(y_sum_5),
    .ram_on(ram_on),.xie_on(xie_on),.color_on(color_on),.xiangpica_on(xiangpica_on));
    
    ball_moving_top uut3(.clk(clk),.reset(~reset),.reset_ram(ram_on),.we(xie_on),
    .ball_x(x_sum_5),.ball_y(y_sum_5),
    .ball_x_1(x_sum_1),.ball_y_1(y_sum_1),
    .ball_x_2(x_sum_2),.ball_y_2(y_sum_2),
    .ball_x_3(x_sum_3),.ball_y_3(y_sum_3),
    .ball_x_4(x_sum_4),.ball_y_4(y_sum_4),
    .hsync(hsync),.vsync(vsync),.rgb(rgb),.color_on(color_on),.xiangpica_on(xiangpica_on));
endmodule
