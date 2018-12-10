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
	input start_page,   //1 at start page, 0 at game page

	output reg [3:0] seat_x_o,	//棋盘x坐标
	output reg [3:0] seat_y_o,	//棋盘y坐标
	output reg [3:0] vga_btn_o,	//屏幕上的按钮值： 0 无，1 player ai, 2 black, 3 ok, 4 undo, 5 restart ,6 tips,7 棋盘, 8 声音
	output reg [1:0] value_choice,	// 0 光标在空白区域， 1 光标在棋盘区域， 2 光标在第一屏的按钮区域， 3 光标在第二屏的按钮区域

	output reg [7:0] btn_o,	// 按键值
	output reg btn_valid_o	// 按键中断信号，仅当按键信号为有效值时才产生中断
    );
	
	// Chessboard display parameters
    localparam BOARD_SIZE = 15,		//棋盘大小 15*15
               GRID_SIZE = 23,		//棋盘格子间距
               GRID_X_BEGIN = 148,
               GRID_X_END = 492,
               GRID_Y_BEGIN = 68,
               GRID_Y_END = 412;

    // 按键值
    reg btn_valid_buf;
    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
    		btn_o <= 8'h0;
    		btn_valid_buf <= 1'b0;
    	end else if (valid_i) begin
    		btn_o <= btn_i;
    		if ((btn_i == 0) || (btn_i == 3)) btn_valid_buf <= 1'b0;
    		else            btn_valid_buf <= 1'b1;  
    	end else begin
    		btn_o <= btn_o;
    		btn_valid_buf <= 1'b0;
    	end
    end

    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
            btn_valid_o <= 1'b0;
    	end else begin
    		btn_valid_o <= btn_valid_buf;
    	end
    end

	// Calculate the current seat_x_o and seat_y_o
    // 计算当前棋盘的行和列
    always @ (posedge clk or posedge rst_p) begin
        if (rst_p) begin
        	seat_x_o <= 4'b0000;
        	seat_y_o <= 4'b0000;
        end else if (valid_i) begin
	        if (y_i >= GRID_Y_BEGIN &&
	            y_i < GRID_Y_BEGIN + GRID_SIZE)
	            seat_x_o <= 4'b0001;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*2)
	            seat_x_o <= 4'b0010;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*2 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*3)
	            seat_x_o <= 4'b0011;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*3 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*4)
	            seat_x_o <= 4'b0100;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*4 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*5)
	            seat_x_o <= 4'b0101;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*5 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*6)
	            seat_x_o <= 4'b0110;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*6 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*7)
	            seat_x_o <= 4'b0111;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*7 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*8)
	            seat_x_o <= 4'b1000;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*8 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*9)
	            seat_x_o <= 4'b1001;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*9 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*10)
	            seat_x_o <= 4'b1010;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*10 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*11)
	            seat_x_o <= 4'b1011;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*11 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*12)
	            seat_x_o <= 4'b1100;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*12 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*13)
	            seat_x_o <= 4'b1101;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*13 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*14)
	            seat_x_o <= 4'b1110;
	        else if (y_i >= GRID_Y_BEGIN + GRID_SIZE*14 &&
	                 y_i < GRID_Y_BEGIN + GRID_SIZE*15)
	            seat_x_o <= 4'b1111;
	        else
	            seat_x_o <= 4'b0000;
	        
	        if (x_i >= GRID_X_BEGIN &&
	            x_i < GRID_X_BEGIN + GRID_SIZE)
	            seat_y_o <= 4'b0001;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*2)
	            seat_y_o <= 4'b0010;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*2 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*3)
	            seat_y_o <= 4'b0011;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*3 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*4)
	            seat_y_o <= 4'b0100;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*4 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*5)
	            seat_y_o <= 4'b0101;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*5 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*6)
	            seat_y_o <= 4'b0110;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*6 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*7)
	            seat_y_o <= 4'b0111;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*7 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*8)
	            seat_y_o <= 4'b1000;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*8 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*9)
	            seat_y_o <= 4'b1001;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*9 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*10)
	            seat_y_o <= 4'b1010;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*10 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*11)
	            seat_y_o <= 4'b1011;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*11 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*12)
	            seat_y_o <= 4'b1100;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*12 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*13)
	            seat_y_o <= 4'b1101;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*13 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*14)
	            seat_y_o <= 4'b1110;
	        else if (x_i >= GRID_X_BEGIN + GRID_SIZE*14 &&
	                 x_i < GRID_X_BEGIN + GRID_SIZE*15)
	            seat_y_o <= 4'b1111;
	        else
	            seat_y_o <= 4'b0000;
	    end else begin
	    	seat_x_o <= seat_x_o;
	    	seat_y_o <= seat_y_o;
	    end
    end

    //光标所在区域
    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
    		value_choice <= 2'b00;
    		vga_btn_o <= 4'h0;
    	end else if(start_page) begin  // at start page
    		if ((y_i[9:4]>=19) && (y_i[9:4]<21) && (x_i[9:4]<=28) && (x_i[9:4]>=10)) begin
    			vga_btn_o <= 4'h1;
    			value_choice <= 2'b10;
    		end else if ((y_i[9:4]>=23) && (y_i[9:4]<25) && (x_i[9:4]<=28) && (x_i[9:4]>=10)) begin
    			vga_btn_o <= 4'h2;
    			value_choice <= 2'b10;
    		end else if ((y_i[9:4]>=27) && (y_i[9:4]<29) && (x_i[9:4]<=28) && (x_i[9:4]>=10)) begin
    			vga_btn_o <= 4'h3;
    			value_choice <= 2'b10;
    		end else if ((y_i[9:3]>=51) && (y_i[9:3]<=56) && (x_i[9:3]>=3) && (x_i[9:3]<=8))begin  //在声音按键区域
    			vga_btn_o <= 4'h8;
    			value_choice <= 2'b10;
    		end else begin
    			vga_btn_o <= 4'h0;
    			value_choice <= 2'b00;
    		end
    	end else begin                 // at game page
    		if ((x_i >= GRID_X_BEGIN) && (x_i <= GRID_X_END) && (y_i >= GRID_Y_BEGIN) && (y_i <= GRID_Y_END)) begin  //在棋盘区域
    			value_choice <= 2'b01;
    			vga_btn_o <= 4'h7;
    		end else if ((y_i[9:5]==11) && (x_i[9:3]<77) && (x_i[9:3]>=65)) begin    //在undo区域
    			value_choice <= 2'b11;
    			vga_btn_o <= 4'h4;
    		end else if ((y_i[9:5]==13) && (x_i[9:3] < 81) && (x_i[9:3] >= 65)) begin    //在restart区域
    			value_choice <= 2'b11;
    			vga_btn_o <= 4'h5;
    		end else if ((y_i[9:5]==12) && (x_i[9:3]<77) && (x_i[9:3]>=65)) begin    //在tips区域
    			value_choice <= 2'b11;
    			vga_btn_o <= 4'h6;
    		end else if ((y_i[9:3]>=51) && (y_i[9:3]<=56) && (x_i[9:3]>=3) && (x_i[9:3]<=8)) begin  //在声音按键区域
    			vga_btn_o <= 4'h8;
    			value_choice <= 2'b11;
    		end else begin
    			value_choice <= 2'b00;
    			vga_btn_o <= 4'h0;
    		end
    	end 
    end

endmodule
