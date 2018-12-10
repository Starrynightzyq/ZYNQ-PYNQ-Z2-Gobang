`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/01 18:55:08
// Design Name: 
// Module Name: gobang_display
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


module gobang_display(
	input wire clk,
	input wire rst_p,
	input wire clr,

	input wire [11:0] pixel_x,				//VGA signal in
	input wire [11:0] pixel_y,
	input wire video_on,

	input wire [3:0] cursor_i,				// 当前光标位置
	input wire [3:0] cursor_j,
    input wire [1:0] cursor_shape,

	input wire black_is_player,				// If black is not AI
	input wire white_is_player,				// If white is not AI

	input wire crt_player, 					// 当前玩家指示，0 is black， 1 is white
	input wire game_running,				// If the game is running， 影响 crt_player 作用
	input wire [1:0] winner,            	// Who wins the game , winner[1] == 1 is black win, winner[0] == 1 is white win

    input wire write,                    // Enable-write signal
    input wire retract,                  // 悔棋
    input wire [3:0] write_i,            // The position to write information
    input wire [3:0] write_j,
    input wire write_color,              // The color to write in, 0 is black, 1 is white

    input wire [3:0] col_first,        //five_on_line
    input wire [3:0] col_last,
    input wire [3:0] row_first,
    input wire [3:0] row_last,
    input wire  line_en,

    input wire start_page,             // 1 display the start page, 0 display the game page
    //input wire [1:0]square,            // 00 don't display;01 player vs...;10 black...;11 ok

    input wire [3:0] point_btn_1,           //鼠标1指向
    input wire [3:0] point_btn_2,           //鼠标2指向

     input wire sound_onoff,           //声音开关

    input wire [11:0] dot_x_1,               //鼠标位置
    input wire [11:0] dot_y_1,
    input wire [11:0] dot_x_2,               //鼠标位置
    input wire [11:0] dot_y_2,
    
    input wire [3:0] consider_i,         // Row considered by strategy/checker
    input wire [3:0] consider_j,         // Column considered by s/c

    output wire [8:0] black_i,            // Row information for s/c
    output wire [8:0] black_j,            // Column information for s/c
    output wire [8:0] black_ij,           // Main diagonal information for s/c
    output wire [8:0] black_ji,           // Counter diagonal information for s/c
    output wire [8:0] white_i,
    output wire [8:0] white_j,
    output wire [8:0] white_ij,
    output wire [8:0] white_ji,
    output wire [8:0] grid_i,
    output wire [8:0] grid_j,
    output wire [8:0] grid_ij,
    output wire [8:0] grid_ji,

    output wire [3:0] r_dout,                // VGA red component
    output wire [3:0] g_dout,                // VGA green component
    output wire [3:0] b_dout                 // VGA blue component
    );

	
    wire [3:0] display_i;         // Row needed by display
    vga_display U_vga_display (
        .clk(clk),
        .rst_p(rst_p),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .cursor_i(cursor_i),
        .cursor_j(cursor_j),
        .black_is_player(black_is_player),
        .white_is_player(white_is_player),
        .crt_player(crt_player),
        .game_running(game_running),
        .winner(winner),
        .display_black(display_black),
        .display_white(display_white),
        .col_first(col_first),
        .col_last(col_last),
        .row_first(row_first),
        .row_last(row_last),
        .line_en(line_en),
        .start_page(start_page),
        //.square(square),
        .round_cnt_unit(round_cnt_unit),
        .round_cnt_tens(round_cnt_tens),
        .round_cnt_hund(round_cnt_hund),
        .point_btn_1(point_btn_1),
        .point_btn_2(point_btn_2),
        .dot_x_1(dot_x_1),
        .dot_y_1(dot_y_1),
        .dot_x_2(dot_x_2),
        .dot_y_2(dot_y_2),
        .cursor_shape(cursor_shape),

        .sound_onoff(sound_onoff),

        .display_i(display_i),
        .r_dout(r_dout),
        .g_dout(g_dout),
        .b_dout(b_dout)
        );

    wire [14:0] display_black;    // Row information for display
    wire [14:0] display_white;
    gobang_datapath U_gobang_datapath (
        .clk(clk), 
        .rst_p(rst_p), 
        .clr(clr), 
        .write(write), 
        .retract(retract),
        .write_i(write_i), 
        .write_j(write_j), 
        .write_color(write_color),
        .display_i(display_i),
        .logic_i(4'b0),

        .display_black(display_black), 
        .display_white(display_white),

        .consider_i(consider_i),
        .consider_j(consider_j),
        .black_i(black_i),
        .black_j(black_j),
        .black_ij(black_ij),
        .black_ji(black_ji),
        .white_i(white_i),
        .white_j(white_j),
        .white_ij(white_ij),
        .white_ji(white_ji),
        .grid_i(grid_i),
        .grid_j(grid_j),
        .grid_ij(grid_ij),
        .grid_ji(grid_ji)
    );


    wire[3:0] round_cnt_unit;
    wire[3:0] round_cnt_tens;
    wire[3:0] round_cnt_hund;
    round_cnt U_round_cnt(
        .clk(clk),
        .rst_p(rst_p),
        .write(write),
        .write_color(write_color),
        .retract(retract),
        .clr(clr),

        .round_cnt_unit(round_cnt_unit),
        .round_cnt_tens(round_cnt_tens),
        .round_cnt_hund(round_cnt_hund)
        );

endmodule
