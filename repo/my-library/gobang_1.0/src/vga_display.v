`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/30 17:27:08
// Design Name: 
// Module Name: vga_display
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


module vga_display(
    input wire clk,                     // Clock (25MHz)
    input wire rst_p,                   // Reset active high

    input wire [11:0] pixel_x,
    input wire [11:0] pixel_y,
    input wire video_on,
    
    input wire [3:0] cursor_i,          // Cursor position
    input wire [3:0] cursor_j,
    input wire black_is_player,         // If black is not AI
    input wire white_is_player,         // If white is not AI
    input wire crt_player,              // Current player
    input wire game_running,            // If the game is running
    input wire [1:0] winner,            // Who wins the game , winner[1] == 1 is black win, winner[0] == 1 is white win
    
    input wire [14:0] display_black,    // Row information for display
    input wire [14:0] display_white,
    
    input wire [3:0] col_first,        //five_on_line
    input wire [3:0] col_last,
    input wire [3:0] row_first,
    input wire [3:0] row_last,
    input wire  line_en,

    input wire start_page,             // 1 display the start page, 0 display the game page
    //input wire [1:0]square,            // 方框  00 don't display;01 player vs...;10 black...;11 ok

    input wire [3:0] round_cnt_unit,         //回合数个位
    input wire [3:0] round_cnt_tens,         //回合数十位
    input wire [3:0] round_cnt_hund,         //回合数百位   

    input wire [3:0] point_btn_1,           //鼠标1指向
    input wire [3:0] point_btn_2,           //鼠标2指向

    input wire sound_onoff,           //声音开关

    input wire [1:0] cursor_shape,

    input wire [11:0] dot_x_1,               //鼠标位置
    input wire [11:0] dot_y_1,
    input wire [11:0] dot_x_2,               
    input wire [11:0] dot_y_2,

    output wire [3:0] display_i,        // Row needed by display
    
    // output wire sync_h,                 // VGA horizontal sync
    // output wire sync_v,                 // VGA vertical sync
    output wire [3:0] r_dout,                // VGA red component
    output wire [3:0] g_dout,                // VGA green component
    output wire [3:0] b_dout                 // VGA blue component
    );

    // Side parameters
    localparam BLACK = 1'b0,
               WHITE = 1'b1;
    
    // Chessboard display parameters
    localparam BOARD_SIZE = 15,		//棋盘大小 15*15
               GRID_SIZE = 23,		//棋盘格子间距
               GRID_X_BEGIN = 148,
               GRID_X_END = 492,
               GRID_Y_BEGIN = 68,
               GRID_Y_END = 412;
  
    // Side information display parameters
    // 玩家信息
    localparam SIDE_BLACK_X_BEGIN = 545,
               SIDE_BLACK_X_END = 616,
               SIDE_BLACK_Y_BEGIN = 182,
               SIDE_BLACK_Y_END = 200,
               SIDE_WHITE_X_BEGIN = 545,
               SIDE_WHITE_X_END = 616,
               SIDE_WHITE_Y_BEGIN = 278,
               SIDE_WHITE_Y_END = 296;
    
    // Current player pointer display parameters
    // 指示当前玩家
    localparam CRT_BLACK_X_BEGIN = 510,
               CRT_BLACK_X_END = 541,
               CRT_BLACK_Y_BEGIN = 185,
               CRT_BLACK_Y_END = 198,
               CRT_WHITE_X_BEGIN = 510,
               CRT_WHITE_X_END = 541,
               CRT_WHITE_Y_BEGIN = 281,
               CRT_WHITE_Y_END = 294;
               
    // Result display parameters
    // 显示胜负结果
    localparam RES_X_BEGIN = 187,
               RES_X_END = 452,
               RES_Y_BEGIN = 20,
               RES_Y_END = 47;
    
    // 背景色
    localparam back_color = 12'hEC8;
    // 字体色
    localparam font_color = 12'h960,
                btn_color = 12'h960;
    // 鼠标方框色
    localparam squ_color = 12'h900;
    // 鼠标色
    localparam mouse_color = 12'h159;

    //xilinx商标位置
    localparam XILINX_X_BEGIN = 10,
               XILINX_X_END   = 74,
               XILINX_Y_BEGIN = 10,
               XILINX_Y_END   = 74,
               XILINX_SIZE    = 64;

    // Chessboard display registers
    reg [3:0] row, col;
    integer delta_x, delta_y;
    assign display_i = row < BOARD_SIZE ? row : 4'b0;

    // Current display color
    reg [11:0] rgb_data;
    assign r_dout = video_on ? rgb_data[11:8] : 4'b0;
    assign g_dout = video_on ? rgb_data[7:4]  : 4'b0;
    assign b_dout = video_on ? rgb_data[3:0]  : 4'b0;

	// wire [11:0] pixel_x;
	// wire [11:0] pixel_y;
	// wire video_on;
	// vga_driver U_vga_driver (
	// 	.clk_25M(clk),
	// 	.rst_p(rst_p),
	// 	.hsync(sync_h),
	// 	.vsync(sync_v),
	// 	.pixel_x(pixel_x),
	// 	.pixel_y(pixel_y),
	// 	.video_on(video_on)
	// 	);

    // Patterns needed to be displayed
    // 棋盘
    wire [22:0] chess_piece_data;
    pic_chess_piece U_chess_piece(pixel_x >= GRID_X_BEGIN && pixel_x <= GRID_X_END &&
                                pixel_y >= GRID_Y_BEGIN && pixel_y <= GRID_Y_END,
                                delta_y + GRID_SIZE/2, chess_piece_data);

    //当前玩家指示
    wire pic_crt_ptr_black_en;
    wire pic_crt_ptr_white_en;
    wire pic_crt_ptr_en;
    wire [31:0] pic_crt_ptr_addr;
    wire [31:0] pic_crt_ptr_data;
    assign pic_crt_ptr_black_en = pixel_x >= CRT_BLACK_X_BEGIN && pixel_x <= CRT_BLACK_X_END &&
                          			pixel_y >= CRT_BLACK_Y_BEGIN && pixel_y <= CRT_BLACK_Y_END;
    assign pic_crt_ptr_white_en = pixel_x >= CRT_WHITE_X_BEGIN && pixel_x <= CRT_WHITE_X_END &&
                          			pixel_y >= CRT_WHITE_Y_BEGIN && pixel_y <= CRT_WHITE_Y_END;
    assign pic_crt_ptr_en = pic_crt_ptr_white_en || pic_crt_ptr_black_en;
    assign pic_crt_ptr_addr = pic_crt_ptr_black_en ? (pixel_y - CRT_BLACK_Y_BEGIN) : pic_crt_ptr_white_en ? (pixel_y - CRT_WHITE_Y_BEGIN) : 31'b0;
    pic_crt_ptr U_pic_crt_ptr(pic_crt_ptr_en, pic_crt_ptr_addr, pic_crt_ptr_data);

    //玩家信息
    wire pic_side_black_en;
    wire pic_side_white_en;
    wire pic_side_player_en;
    wire [31:0] pic_side_addr;
    wire [71:0] pic_side_player_data;
    wire [71:0] pic_side_ai_data;
    assign pic_side_black_en = pixel_x >= SIDE_BLACK_X_BEGIN &&
                                pixel_x <= SIDE_BLACK_X_END &&
                                pixel_y >= SIDE_BLACK_Y_BEGIN &&
                                pixel_y <= SIDE_BLACK_Y_END;
    assign pic_side_white_en = pixel_x >= SIDE_WHITE_X_BEGIN &&
                                pixel_x <= SIDE_WHITE_X_END &&
                                pixel_y >= SIDE_WHITE_Y_BEGIN &&
                                pixel_y <= SIDE_WHITE_Y_END;
    assign pic_side_player_en = pic_side_black_en || pic_side_white_en;
    assign pic_side_addr = pic_side_black_en ? (pixel_y - SIDE_BLACK_Y_BEGIN) : pic_side_white_en ? (pixel_y - SIDE_WHITE_Y_BEGIN) : 31'b0;
    pic_side_player U_pic_side_player(pic_side_player_en, pic_side_addr, pic_side_player_data);
    pic_side_ai U_pic_side_ai(pic_side_player_en, pic_side_addr, pic_side_ai_data);
     
    //字
    reg [10:0] font_rom_addr;
    reg [2:0] font_bit_addr;
    wire [7:0] font_rom_data;
    font_rom U_font_rom_1 (.clk(clk), .addr(font_rom_addr), .data(font_rom_data));

    // 计算当前显示的字
    always @(*) begin
    	font_rom_addr = 11'b0;
    	font_bit_addr = 3'b0;
    	if(start_page) begin
            if (font_rom_on_gobang) begin
                font_rom_addr = font_rom_addr_gobang;
                font_bit_addr = font_bit_addr_gobang;
            end else if (font_rom_on_pvp) begin
                font_rom_addr = font_rom_addr_pvp;
                font_bit_addr = font_bit_addr_pvp;
            end else if (font_rom_on_blkwht&&Player_vs_AI) begin 
                font_rom_addr = font_rom_addr_blkwht;
                font_bit_addr = font_bit_addr_blkwht;
            end else if(font_rom_on_ok) begin
                font_rom_addr = font_rom_addr_ok;
                font_bit_addr = font_bit_addr_ok;
            end else begin
                font_rom_addr = 11'b0;
                font_bit_addr = 3'b0;
            end
        end else if (font_rom_on_res) begin
    		font_rom_addr = font_rom_addr_res;
    		font_bit_addr = font_bit_addr_res;
        end else if (font_rom_on_round) begin
            font_rom_addr = font_rom_addr_round;
            font_bit_addr = font_bit_addr_round;
        end else if (font_rom_on_undo) begin
        	font_rom_addr = font_rom_addr_undo;
            font_bit_addr = font_bit_addr_undo;
        end else if (font_rom_on_tips) begin
        	font_rom_addr = font_rom_addr_tips;
            font_bit_addr = font_bit_addr_tips;
        end else if (font_rom_on_restart) begin
        	font_rom_addr = font_rom_addr_restart;
            font_bit_addr = font_bit_addr_restart;
    	end else begin
	    	font_rom_addr = 11'b0;
	    	font_bit_addr = 3'b0;
    	end
    end

    // 显示胜负结果
    wire font_rom_on_res;
    wire [10:0] font_rom_addr_res;
    reg [6:0] font_char_addr_res;
    wire [3:0] font_row_addr_res;
    wire [2:0] font_bit_addr_res;
    assign font_rom_on_res = (pixel_y[9:5]==0) && (pixel_x[9:4]<=24) && (pixel_x[9:4]>=16);
	assign font_row_addr_res = pixel_y[4:1];
	assign font_bit_addr_res = (3'h7 - pixel_x[3:1]);
	assign font_rom_addr_res = {font_char_addr_res, font_row_addr_res};
	always @(*) begin
	  	case (pixel_x[7:4])
			4'h0: font_char_addr_res = winner[1] ? 7'h42 : winner[0] ? 7'h57 : 7'h0; //  B / W
			4'h1: font_char_addr_res = winner[1] ? 7'h4c : winner[0] ? 7'h48 : 7'h0; //  L / H
			4'h2: font_char_addr_res = winner[1] ? 7'h41 : winner[0] ? 7'h49 : 7'h0; //  A / I
			4'h3: font_char_addr_res = winner[1] ? 7'h43 : winner[0] ? 7'h54 : 7'h0; //  C / T
			4'h4: font_char_addr_res = winner[1] ? 7'h4b : winner[0] ? 7'h45 : 7'h0; //  K / E
			4'h5: font_char_addr_res = 7'h00; //
			4'h6: font_char_addr_res = 7'h77; // w
			4'h7: font_char_addr_res = 7'h69; // i
			4'h8: font_char_addr_res = 7'h6e; // n
			default : font_char_addr_res = 7'h00; //
		endcase
	end
    
    // Calculate the current row and column
    // 计算当前棋盘的行和列
    always @ (pixel_x or pixel_y) begin
        if (pixel_y >= GRID_Y_BEGIN &&
            pixel_y < GRID_Y_BEGIN + GRID_SIZE)
            row = 4'b0000;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*2)
            row = 4'b0001;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*2 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*3)
            row = 4'b0010;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*3 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*4)
            row = 4'b0011;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*4 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*5)
            row = 4'b0100;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*5 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*6)
            row = 4'b0101;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*6 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*7)
            row = 4'b0110;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*7 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*8)
            row = 4'b0111;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*8 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*9)
            row = 4'b1000;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*9 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*10)
            row = 4'b1001;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*10 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*11)
            row = 4'b1010;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*11 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*12)
            row = 4'b1011;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*12 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*13)
            row = 4'b1100;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*13 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*14)
            row = 4'b1101;
        else if (pixel_y >= GRID_Y_BEGIN + GRID_SIZE*14 &&
                 pixel_y < GRID_Y_BEGIN + GRID_SIZE*15)
            row = 4'b1110;
        else
            row = 4'b1111;
        
        if (pixel_x >= GRID_X_BEGIN &&
            pixel_x < GRID_X_BEGIN + GRID_SIZE)
            col = 4'b0000;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*2)
            col = 4'b0001;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*2 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*3)
            col = 4'b0010;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*3 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*4)
            col = 4'b0011;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*4 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*5)
            col = 4'b0100;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*5 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*6)
            col = 4'b0101;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*6 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*7)
            col = 4'b0110;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*7 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*8)
            col = 4'b0111;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*8 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*9)
            col = 4'b1000;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*9 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*10)
            col = 4'b1001;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*10 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*11)
            col = 4'b1010;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*11 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*12)
            col = 4'b1011;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*12 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*13)
            col = 4'b1100;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*13 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*14)
            col = 4'b1101;
        else if (pixel_x >= GRID_X_BEGIN + GRID_SIZE*14 &&
                 pixel_x < GRID_X_BEGIN + GRID_SIZE*15)
            col = 4'b1110;
        else
            col = 4'b1111;
        
        delta_x = GRID_X_BEGIN + col*GRID_SIZE + GRID_SIZE/2 - pixel_x;
        delta_y = GRID_Y_BEGIN + row*GRID_SIZE + GRID_SIZE/2 - pixel_y;
    end
 
    //显示 xilinx 商标
    design_gobang_blk_mem_gen_0_0 U_xilinx_rom (
      .clka(clk),    // input wire clka
      .ena(on_xilinx),      // input wire ena
      .addra(xilinx_addr),  // input wire [11 : 0] addra
      .douta(xilinx_data)  // output wire [15 : 0] douta
    );
    wire on_xilinx;
    wire [11:0] xilinx_addr;
    wire [11:0] xilinx_data;
    wire [11:0] xilinx_colar;
    assign on_xilinx = (pixel_x >= XILINX_X_BEGIN) && (pixel_x < XILINX_X_END) && (pixel_y >= XILINX_Y_BEGIN) && (pixel_y < XILINX_Y_END);
    assign xilinx_addr = (pixel_y - XILINX_Y_BEGIN)*64 + (pixel_x - XILINX_X_BEGIN);
    assign xilinx_colar = xilinx_data;

 //显示五个加粗点 和 行列数
    wire big_point;//是否在加粗5个特殊点的位置
    wire rows_num;//是否在显示行数的区域
    wire cols_num;//是否在显示列数的区域
    wire[10:0] num_addr;
    reg[10:0] num_addr_c;
    wire[10:0] num_addr_r;
    wire[7:0] num_data;
    assign big_point = (delta_x*delta_x+delta_y*delta_y<=25) && ((row==3&&col==3)||(row==3&&col==11)||(row==11&&col==3)||(row==11&&col==11)||(row==7&&col==7));
	assign rows_num = (pixel_y>=GRID_Y_BEGIN&&pixel_y<=GRID_Y_END)&&(pixel_x>=GRID_X_BEGIN-12&&pixel_x<=GRID_X_BEGIN-4)&&(delta_y<=8&&delta_y>=-7);
    assign cols_num = (pixel_x>=GRID_X_BEGIN&&pixel_x<=GRID_X_END)&&(pixel_y>=GRID_Y_BEGIN-16&&pixel_y<=GRID_Y_BEGIN)&&(delta_x<=8&&delta_x>=-7);
    font_rom U_font_rom_2 (.clk(clk), .addr(num_addr), .data(num_data));
    assign num_addr = (cols_num)?num_addr_c:num_addr_r;
    assign num_addr_r = 11'h410+row*5'h10+16-delta_y-3'h7;
    always@(*) begin
        //(delta_x>0)?(11'h300+(col+1)/10*5'h10+pixel_y+16-GRID_Y_BEGIN):(11'h300+(col+1)%10*5'h10+pixel_y+16-GRID_Y_BEGIN)
        if(col<=8) begin
            num_addr_c = (delta_x>0)?(11'h300+pixel_y+16-GRID_Y_BEGIN):(11'h300+(col+1)*5'h10+pixel_y+16-GRID_Y_BEGIN);
        end else begin
            num_addr_c = (delta_x>0)?(11'h310+pixel_y+16-GRID_Y_BEGIN):(11'h300+(col+1-10)*5'h10+pixel_y+16-GRID_Y_BEGIN);
        end
    end

// 标记出五个连成线的棋子
    wire[4:0] col_second_h;
    wire[4:0] col_middle_h;
    wire[4:0] col_fourth_h;
    wire[4:0] row_second_h;
    wire[4:0] row_middle_h;
    wire[4:0] row_fourth_h;

    wire[3:0] col_second;
    wire[3:0] col_middle;
    wire[3:0] col_fourth;
    wire[3:0] row_second;
    wire[3:0] row_middle;
    wire[3:0] row_fourth;

    assign col_middle_h = col_first + col_last;
    assign row_middle_h = row_first + row_last;
    assign col_second_h = col_first + col_middle;
    assign row_second_h = row_first + row_middle;
    assign col_fourth_h = col_middle + col_last;
    assign row_fourth_h = row_middle + row_last;

    assign col_middle = col_middle_h[4:1];
    assign row_middle = row_middle_h[4:1];
    assign col_second = col_second_h[4:1];
    assign row_second = row_second_h[4:1];
    assign col_fourth = col_fourth_h[4:1];
    assign row_fourth = row_fourth_h[4:1];
    
    wire xy_on_line;
    assign xy_on_line = line_en && ((delta_x==0 && delta_y<=5&&delta_y>=-5) || (delta_y==0 && delta_x<=5&&delta_x>=-5)) && 
                        ((col==col_first&&row==row_first)||(col==col_second&&row==row_second)||(col==col_middle&&row==row_middle)||(col==col_fourth&&row==row_fourth)||(col==col_last&&row==row_last));

    // 开始界面
    //gobang
    wire font_rom_on_gobang;
    wire [10:0] font_rom_addr_gobang;
    reg [6:0]  font_char_addr_gobang;
    wire [3:0]  font_row_addr_gobang;
    assign font_rom_on_gobang = (pixel_y[9:6]==1) && (pixel_x[9:5]<13) && (pixel_x[9:5]>=7);
    assign font_row_addr_gobang = pixel_y[5:2];
    assign font_rom_addr_gobang = {font_char_addr_gobang,font_row_addr_gobang};
    always@(*) begin
        case (pixel_x[9:5])
            7:  font_char_addr_gobang = 8'h47; //G
            8:  font_char_addr_gobang = 8'h6f; //o
            9:  font_char_addr_gobang = 8'h62; //b
            10: font_char_addr_gobang = 8'h61; //a
            11: font_char_addr_gobang = 8'h6e; //n
            12: font_char_addr_gobang = 8'h67; //g
            default: font_char_addr_gobang = 8'h00; 
        endcase
    end
    // player vs player    player vs AI   AI vs AI
    wire font_rom_on_pvp;
    reg [10:0] font_rom_addr_pvp;
    reg [6:0]  font_char_addr_pvp;
    reg [6:0]  font_char_addr_pva;
    reg [6:0]  font_char_addr_ava;
    wire [3:0]  font_row_addr_pvp;
    assign font_rom_on_pvp = (pixel_y[9:4]>=19) && (pixel_y[9:4]<21) && (pixel_x[9:4]<=28) && (pixel_x[9:4]>=10);
    assign font_row_addr_pvp = pixel_y[4:1]-8;
   
    always@(*) begin
        case ({black_is_player,white_is_player})
            0: font_rom_addr_pvp = {font_char_addr_ava,font_row_addr_pvp}; //Ai vs ai
            1: font_rom_addr_pvp = {font_char_addr_pva,font_row_addr_pvp}; //player vs ai
            2: font_rom_addr_pvp = {font_char_addr_pva,font_row_addr_pvp}; //player vs ai
            3: font_rom_addr_pvp = {font_char_addr_pvp,font_row_addr_pvp}; //player vs player
            default: font_rom_addr_pvp = 11'b0;
        endcase
    end
 
    
    always@(*) begin
        case (pixel_x[9:4])
        	10: begin font_char_addr_pvp = (point_btn_1==1)?8'h15:8'h00; font_char_addr_pva = (point_btn_1==1)?8'h15:8'h00; font_char_addr_ava = (point_btn_1==1)?8'h15:8'h00;end //&
            11: begin font_char_addr_pvp = 8'h00; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //
            12: begin font_char_addr_pvp = 8'h50; font_char_addr_pva = 8'h50; font_char_addr_ava = 8'h00;end //P //P
            13: begin font_char_addr_pvp = 8'h4c; font_char_addr_pva = 8'h4C; font_char_addr_ava = 8'h00;end //L //L
            14: begin font_char_addr_pvp = 8'h41; font_char_addr_pva = 8'h41; font_char_addr_ava = 8'h00;end //A //A
            15: begin font_char_addr_pvp = 8'h59; font_char_addr_pva = 8'h59; font_char_addr_ava = 8'h00;end //Y //Y
            16: begin font_char_addr_pvp = 8'h45; font_char_addr_pva = 8'h45; font_char_addr_ava = 8'h41;end //E //E //A
            17: begin font_char_addr_pvp = 8'h52; font_char_addr_pva = 8'h52; font_char_addr_ava = 8'h49;end //R //R //I
            18: begin font_char_addr_pvp = 8'h00; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //
            19: begin font_char_addr_pvp = 8'h76; font_char_addr_pva = 8'h76; font_char_addr_ava = 8'h76;end //v   v   v
            20: begin font_char_addr_pvp = 8'h73; font_char_addr_pva = 8'h73; font_char_addr_ava = 8'h73;end //s   s   s
            21: begin font_char_addr_pvp = 8'h00; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //
            22: begin font_char_addr_pvp = 8'h50; font_char_addr_pva = 8'h41; font_char_addr_ava = 8'h41;end //P //A //A
            23: begin font_char_addr_pvp = 8'h4c; font_char_addr_pva = 8'h49; font_char_addr_ava = 8'h49;end //L //I //I
            24: begin font_char_addr_pvp = 8'h41; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //A
            25: begin font_char_addr_pvp = 8'h59; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //Y
            26: begin font_char_addr_pvp = 8'h45; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //E
            27: begin font_char_addr_pvp = 8'h52; font_char_addr_pva = 8'h00; font_char_addr_ava = 8'h00;end //R
            default:begin font_char_addr_pvp = 8'h00; font_char_addr_pva = 8'h00; end
        endcase
    end
    wire Player_vs_AI;
    assign Player_vs_AI = ({black_is_player,white_is_player}==1) || ({black_is_player,white_is_player}==2);

    //black  white
    wire font_rom_on_blkwht;
    wire [10:0] font_rom_addr_blkwht;
    reg [6:0]  font_char_addr_blk;
    reg [6:0]  font_char_addr_wht;
    wire [3:0]  font_row_addr_blkwht;
    assign font_rom_on_blkwht = (pixel_y[9:4]>=23) && (pixel_y[9:4]<25) && (pixel_x[9:4]<=28) && (pixel_x[9:4]>=10);
    assign font_row_addr_blkwht = pixel_y[4:1]-8;
    assign font_rom_addr_blkwht = (black_is_player)?{font_char_addr_blk,font_row_addr_blkwht}:{font_char_addr_wht,font_row_addr_blkwht};
    always@(*) begin
        case (pixel_x[9:4])
        	10: begin font_char_addr_blk = (point_btn_1==2)?8'h15:8'h00; font_char_addr_wht = (point_btn_1==2)?8'h15:8'h00; end //&
            17: begin font_char_addr_blk = 8'h42; font_char_addr_wht = 8'h57; end //B  W
            18: begin font_char_addr_blk = 8'h4C; font_char_addr_wht = 8'h48; end //L  H
            19: begin font_char_addr_blk = 8'h41; font_char_addr_wht = 8'h49; end //A  I
            20: begin font_char_addr_blk = 8'h43; font_char_addr_wht = 8'h54; end //C  T
            21: begin font_char_addr_blk = 8'h4B; font_char_addr_wht = 8'h45; end //K  E
            default:begin font_char_addr_blk = 8'h00; font_char_addr_wht = 8'h00; end
        endcase
    end
    //OK
    wire font_rom_on_ok;
    wire [10:0] font_rom_addr_ok;
    reg [6:0]  font_char_addr_ok;
    wire [3:0]  font_row_addr_ok;
    assign font_rom_on_ok = (pixel_y[9:4]>=27) && (pixel_y[9:4]<29) && (pixel_x[9:4]<=28) && (pixel_x[9:4]>=10);
    assign font_row_addr_ok = pixel_y[4:1]-8;
    assign font_rom_addr_ok = {font_char_addr_ok,font_row_addr_ok};
    always@(*) begin
        case (pixel_x[9:4])
        	10: font_char_addr_ok = (point_btn_1==3)?8'h15:8'h00; //&
            19: font_char_addr_ok = 8'h4F; //O
            20: font_char_addr_ok = 8'h4B; //K
            default: font_char_addr_ok = 8'h00; 
        endcase
    end
    wire[2:0] font_bit_addr_gobang;
    wire[2:0] font_bit_addr_pvp;
    wire[2:0] font_bit_addr_blkwht;
    wire[2:0] font_bit_addr_ok;
    assign font_bit_addr_gobang = 7-pixel_x[4:2];
    assign font_bit_addr_pvp = 7-pixel_x[3:1];
    assign font_bit_addr_blkwht = 7-pixel_x[3:1];
    assign font_bit_addr_ok = 7-pixel_x[3:1];

    //显示开始页面的方框
    reg square_display;
    wire square_1;
    wire square_2;
    wire square_3;
    assign square_1 = pixel_y>=301 && pixel_y<=338 && pixel_x[9:3]>=23 && pixel_x[9:3]<=56;                  
    assign square_2 = pixel_y>=365 && pixel_y<=402 && pixel_x[9:3]>=23 && pixel_x[9:3]<=56 && Player_vs_AI;
    assign square_3 = pixel_y>=429 && pixel_y<=466 && pixel_x[9:3]>=23 && pixel_x[9:3]<=56;
    always @(*) begin
        case(point_btn_1)
            1: square_display = square_1;
            2: square_display = square_2;
            3: square_display = square_3;
            default: square_display = 1'b0;
        endcase
    end

    //显示回合数
    wire font_rom_on_round;
    wire[10:0] font_rom_addr_round;
    reg[6:0]  font_char_addr_round;
    reg[6:0]  font_char_addr_unit;
    reg[6:0]  font_char_addr_tens;
    reg[6:0]  font_char_addr_hund;
    wire[3:0]  font_row_addr_round;
    wire[2:0]  font_bit_addr_round;
    assign font_rom_on_round = (pixel_x[9:4] >= 36) && (pixel_x[9:4] < 39) && (pixel_y[9:5] == 1);
    assign font_row_addr_round = pixel_y[4:1];
    assign font_rom_addr_round = {font_char_addr_round,font_row_addr_round};
    assign font_bit_addr_round = 7-pixel_x[3:1];
    always @(*) begin
        case(pixel_x[5:4])
            0: font_char_addr_round = font_char_addr_hund;
            1: font_char_addr_round = font_char_addr_tens;
            2: font_char_addr_round = font_char_addr_unit;
            default: font_char_addr_round = 0;
        endcase
        case(round_cnt_unit)
            0: font_char_addr_unit = 8'h30;
            1: font_char_addr_unit = 8'h31;
            2: font_char_addr_unit = 8'h32;
            3: font_char_addr_unit = 8'h33;
            4: font_char_addr_unit = 8'h34;
            5: font_char_addr_unit = 8'h35;
            6: font_char_addr_unit = 8'h36;
            7: font_char_addr_unit = 8'h37;
            8: font_char_addr_unit = 8'h38;
            9: font_char_addr_unit = 8'h39;
            default: font_char_addr_unit = 8'h00;
        endcase
        case(round_cnt_tens)
            0: font_char_addr_tens = 8'h30;
            1: font_char_addr_tens = 8'h31;
            2: font_char_addr_tens = 8'h32;
            3: font_char_addr_tens = 8'h33;
            4: font_char_addr_tens = 8'h34;
            5: font_char_addr_tens = 8'h35;
            6: font_char_addr_tens = 8'h36;
            7: font_char_addr_tens = 8'h37;
            8: font_char_addr_tens = 8'h38;
            9: font_char_addr_tens = 8'h39;
            default: font_char_addr_tens = 8'h00;
        endcase
        case(round_cnt_hund)
            0: font_char_addr_hund = 8'h30;
            1: font_char_addr_hund = 8'h31;
            2: font_char_addr_hund = 8'h32;
            3: font_char_addr_hund = 8'h33;
            4: font_char_addr_hund = 8'h34;
            5: font_char_addr_hund = 8'h35;
            6: font_char_addr_hund = 8'h36;
            7: font_char_addr_hund = 8'h37;
            8: font_char_addr_hund = 8'h38;
            9: font_char_addr_hund = 8'h39;
            default: font_char_addr_hund = 8'h00;
        endcase
    end

    // 悔棋按钮 The Undo button
    wire font_rom_on_undo;
    wire [10:0] font_rom_addr_undo;
    reg [6:0]  font_char_addr_undo;
    wire [3:0]  font_row_addr_undo;
    assign font_rom_on_undo = (pixel_y[9:5]==11) && (pixel_x[9:3]<77) && (pixel_x[9:3]>=65);
    assign font_row_addr_undo = pixel_y[4:1];
    assign font_rom_addr_undo = {font_char_addr_undo,font_row_addr_undo};
    always@(*) begin
        case (pixel_x[9:4])
            37: font_char_addr_undo = 8'h1b; //<-
            33: font_char_addr_undo = 8'h55; //u
            34: font_char_addr_undo = 8'h6e; //n
            35: font_char_addr_undo = 8'h64; //d
            36: font_char_addr_undo = 8'h6f; //o
            default: font_char_addr_undo = 8'h00; 
        endcase
    end
    wire[2:0] font_bit_addr_undo;
    assign font_bit_addr_undo = 7-pixel_x[3:1];

	// 提示按钮 The Tips button
    wire font_rom_on_tips;
    wire [10:0] font_rom_addr_tips;
    reg [6:0]  font_char_addr_tips;
    wire [3:0]  font_row_addr_tips;
    assign font_rom_on_tips = (pixel_y[9:5]==12) && (pixel_x[9:3]<77) && (pixel_x[9:3]>=65);
    assign font_row_addr_tips = pixel_y[4:1];
    assign font_rom_addr_tips = {font_char_addr_tips,font_row_addr_tips};
    always@(*) begin
        case (pixel_x[9:4])
            37: font_char_addr_tips = 8'h03; //
            33: font_char_addr_tips = 8'h54; //T
            34: font_char_addr_tips = 8'h69; //i
            35: font_char_addr_tips = 8'h70; //p
            36: font_char_addr_tips = 8'h73; //s
            default: font_char_addr_tips = 8'h00; 
        endcase
    end
    wire[2:0] font_bit_addr_tips;
    assign font_bit_addr_tips = 7-pixel_x[3:1];

    // 重启按钮 The Restart button  
    wire font_rom_on_restart;
    wire [10:0] font_rom_addr_restart;
    reg [6:0]  font_char_addr_restart;
    wire [3:0]  font_row_addr_restart;
    assign font_rom_on_restart = (pixel_y[9:5]==13) && (pixel_x[9:3] < 81) && (pixel_x[9:3] >= 65);
    assign font_row_addr_restart = pixel_y[4:1];
    assign font_rom_addr_restart = {font_char_addr_restart,font_row_addr_restart};
    always@(*) begin
        case (pixel_x[9:4])
        	33: font_char_addr_restart = 8'h52; //R
            34: font_char_addr_restart = 8'h65; //e
            35: font_char_addr_restart = 8'h73; //s
            36: font_char_addr_restart = 8'h74; //t
            37: font_char_addr_restart = 8'h61; //a
            38: font_char_addr_restart = 8'h72; //r
            39: font_char_addr_restart = 8'h74; //t
            default: font_char_addr_restart = 8'h00; 
        endcase
    end
    wire[2:0] font_bit_addr_restart;
    assign font_bit_addr_restart = 7-pixel_x[3:1];

    //鼠标 mouse display
    wire on_mouse_1;
    reg [10:0] mouse_addr_1;
    wire [11:0] mouse_row_addr_1;
    wire [11:0] delta_mouse_1;
    wire [3:0] mouse_bit_addr_1;
    assign mouse_row_addr_1 = pixel_y - dot_y_1;
    assign delta_mouse_1 = pixel_x - dot_x_1;
    assign mouse_bit_addr_1 = 15 - delta_mouse_1[3:0]; 
    always @(*) begin
    	case(cursor_shape)
    		0:	mouse_addr_1 = {7'h04,mouse_row_addr_1[3:0]};
    		1:	mouse_addr_1 = {7'h00,mouse_row_addr_1[3:0]};
    		2:	mouse_addr_1 = {7'h02,mouse_row_addr_1[3:0]};
    		default : mouse_addr_1 = {7'h04,mouse_row_addr_1[3:0]};
    	endcase
    end
  	assign  on_mouse_1 = (pixel_x - dot_x_1 <= 15) && (pixel_x - dot_x_1 >= 0) && (pixel_y - dot_y_1 <= 15) && (pixel_y - dot_y_1 >= 0);

    wire on_mouse_2;
    reg [10:0] mouse_addr_2;
    wire [11:0] mouse_row_addr_2;
    wire [11:0] delta_mouse_2;
    wire [3:0] mouse_bit_addr_2;
    //assign on_mouse_2 = (pixel_x - dot_x_2 <= 15) && (pixel_x - dot_x_2 >= 0) && (pixel_y - dot_y_2 <= 15) && (pixel_y - dot_y_2 >= 0) && (black_is_player == 1) && (white_is_player == 1) ;
    assign mouse_row_addr_2 = pixel_y - dot_y_2;
    assign delta_mouse_2 = pixel_x - dot_x_2;
    assign mouse_bit_addr_2 = 15 - delta_mouse_2; 
    always @(*) begin
    	case(cursor_shape)
    		0:	mouse_addr_2 = {7'h05,mouse_row_addr_2[3:0]};
    		1:	mouse_addr_2 = {7'h01,mouse_row_addr_2[3:0]};
    		2:	mouse_addr_2 = {7'h03,mouse_row_addr_2[3:0]};
    		default: mouse_addr_2 = {7'h05,mouse_row_addr_2[3:0]};
    	endcase
    end
   assign on_mouse_2 = (pixel_x - dot_x_2 <= 15) && (pixel_x - dot_x_2 >= 0) && (pixel_y - dot_y_2 <= 15) && (pixel_y - dot_y_2 >= 0) && (black_is_player == 1) && (white_is_player == 1) && (start_page == 0);


    wire [10:0] mouse_addr;
    wire [15:0] mouse_data;
    assign mouse_addr = (on_mouse_1)?mouse_addr_1:mouse_addr_2;
   cursor_rom U_cursor_rom(.clk(clk), .addr(mouse_addr), .data(mouse_data));

   //声音开关
    wire on_sound;
    reg [5:0] sound_addr;
    wire [3:0] sound_row_addr;
    wire [3:0] sound_bit_addr;
    assign on_sound = (pixel_y[9:3]>=51) && (pixel_y[9:3]<=56) && (pixel_x[9:3]>=3) && (pixel_x[9:3]<=8);
    //assign sound_addr = (sound_onoff) ? {1'h0,sound_row_addr[3:0]} : {1'h1,sound_row_addr[3:0]};
    assign sound_row_addr = pixel_y[4:1];
    assign sound_bit_addr = 15-pixel_x[4:1];
    always @* begin
        if((pixel_y[9:3]>=52) && (pixel_y[9:3]<=55) && (pixel_x[9:3]>=4) && (pixel_x[9:3]<=7))  begin
            sound_addr = (sound_onoff) ? {2'h0,sound_row_addr[3:0]} : {2'h1,sound_row_addr[3:0]};
        end else begin
            sound_addr = {2'h2,sound_row_addr[3:0]};
        end
    end
    wire [15:0] sound_data;
    sound_rom U_sound_rom(
        .clk(clk),
        .addr(sound_addr),
        .data(sound_data)
        );

    // 鼠标方框 mouse square
    wire mouse_square;
    assign mouse_square = (row == cursor_i && col == cursor_j &&
                            (((delta_x == GRID_SIZE/2 || delta_x == -(GRID_SIZE/2)) && ((delta_y > 5) || (delta_y < -5))) ||
                            ((delta_y == GRID_SIZE/2 || delta_y == -(GRID_SIZE/2)) && ((delta_x > 5) || (delta_x < -5)))));

    // Calculate the color
	always @(posedge clk or posedge rst_p) begin
		if (rst_p) begin
			// reset
			rgb_data <= 12'b0;
		end else if (start_page) begin  
                //开始页面
                if((on_mouse_1 && mouse_data[mouse_bit_addr_1]) || (on_mouse_2 && mouse_data[mouse_bit_addr_2])) rgb_data <= mouse_color;
                else if (on_xilinx)  rgb_data <= xilinx_colar;
                else if(on_sound) begin 
                    if ((point_btn_1 == 8) || (point_btn_2 == 8))  rgb_data <= (sound_data[sound_bit_addr])?back_color:font_color; 
                    else rgb_data <= (sound_data[sound_bit_addr])?font_color:back_color;  
                end else if(square_display) rgb_data <= (font_rom_data[font_bit_addr])?back_color:font_color;
                else rgb_data <= (font_rom_data[font_bit_addr])?font_color:back_color;
        end else begin
			//Draw the chessboard
            if((on_mouse_1 && mouse_data[mouse_bit_addr_1]) || (on_mouse_2 && mouse_data[mouse_bit_addr_2])) begin 
                rgb_data <= mouse_color;
			end else if (pixel_x >= GRID_X_BEGIN && pixel_x <= GRID_X_END && pixel_y >= GRID_Y_BEGIN && pixel_y <= GRID_Y_END) begin
				if (xy_on_line) begin
                    rgb_data <= 12'h4dd;
                end else if (display_black[col] && chess_piece_data[delta_x + GRID_SIZE/2]) begin
					rgb_data <= 12'h000; 	//Draw a black chess
				end else if (display_white[col] && chess_piece_data[delta_x + GRID_SIZE/2]) begin
					rgb_data <= 12'hfff;	//Draw a white chess
				end else if (mouse_square) begin
					rgb_data <= squ_color;	//Draw a blue square as a cursor
				end else if (delta_x == 0 || delta_y == 0) begin
					rgb_data <= 12'hda6;	//Draw the light border of a gird
                end else if (big_point) begin
                    rgb_data <= 12'h751;    //Make the five special points thicker
				end else if (delta_x == 1 || delta_y == 1) begin
					rgb_data <= 12'h751;	//Draw the dark border of a gird
				end else begin
					rgb_data <= back_color;	//Draw the blank chessboard
				end
            end else if (rows_num) begin
                // Display the number of rows
                rgb_data <= (num_data[GRID_X_BEGIN-4-pixel_x]==1)?font_color:back_color;
            end else if (cols_num) begin
                // Display the number of cols
                if(delta_x>0)
                    rgb_data <= (num_data[delta_x])?font_color:back_color;
                else
                    rgb_data <= (num_data[delta_x+8])?font_color:back_color;
            end else if(font_rom_on_round) begin
                // Display the number of rounds
                rgb_data <= (font_rom_data[font_bit_addr])?font_color:back_color;
            end else if(font_rom_on_undo) begin
            	//display the button
                if ((point_btn_1 == 4) || (point_btn_2 == 4))  rgb_data <= (font_rom_data[font_bit_addr])?back_color:font_color; 
            	else rgb_data <= (font_rom_data[font_bit_addr])?font_color:back_color;  
            end else if(font_rom_on_tips) begin
                if ((point_btn_1 == 6) || (point_btn_2 == 6))  rgb_data <= (font_rom_data[font_bit_addr])?back_color:font_color; 
            	else rgb_data <= (font_rom_data[font_bit_addr])?font_color:back_color;  
            end else if(font_rom_on_restart) begin
                if ((point_btn_1 == 5) || (point_btn_2 == 5))  rgb_data <= (font_rom_data[font_bit_addr])?back_color:font_color; 
            	else rgb_data <= (font_rom_data[font_bit_addr])?font_color:back_color;  
			end else if(on_sound) begin 
                if ((point_btn_1 == 8) || (point_btn_2 == 8))  rgb_data <= (sound_data[sound_bit_addr])?back_color:font_color; 
                else rgb_data <= (sound_data[sound_bit_addr])?font_color:back_color;  
            end else if (pic_crt_ptr_black_en) begin
				// Draw the current player pointer for black side
	            rgb_data <= game_running && crt_player == BLACK && pic_crt_ptr_data[CRT_BLACK_X_END - pixel_x] ? 12'h000 : back_color;
			end else if (pic_crt_ptr_white_en) begin
				// Draw the current player pointer for white side
	            rgb_data <= game_running && crt_player == WHITE && pic_crt_ptr_data[CRT_WHITE_X_END - pixel_x] ? 12'hfff : back_color;
			end else if (pic_side_black_en) begin
	            // Draw who plays the black side
	            if (black_is_player) begin
	                rgb_data <= pic_side_player_data[SIDE_BLACK_X_END - pixel_x] ? 12'h000 : back_color;
	            end else begin
	                rgb_data <= pic_side_ai_data[SIDE_BLACK_X_END - pixel_x] ? 12'h000 : back_color;
	            end
			end else if (pic_side_white_en) begin
				//Draw who plays the white side
				if (white_is_player) begin
	                rgb_data <= pic_side_player_data[SIDE_WHITE_X_END - pixel_x] ? 12'hfff : back_color;
				end else begin
	                rgb_data <= pic_side_ai_data[SIDE_WHITE_X_END - pixel_x] ? 12'hfff : back_color;
				end
			end else if (font_rom_on_res) begin
				// 显示胜负结果
				if (winner[1]) begin //black win
					rgb_data <= font_rom_data[font_bit_addr] ? 12'h000 : back_color;
				end else if (winner[0]) begin //white win
					rgb_data <= font_rom_data[font_bit_addr] ? 12'hfff : back_color;
				end else begin
					rgb_data <= back_color;
				end
			end else if(on_xilinx) begin
                rgb_data <= xilinx_colar;
            end
			else begin
				rgb_data <= back_color;    //空白处背景
			end
		end
	end

endmodule
