`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Stores the data of the chessboard
//------------------------------------------------------------------------------
module gobang_datapath(
    input wire clk,                      // Clock
    input wire rst_p,                      // Reset
    input wire clr,                      // Clear
    
    input wire write,                    // Enable-write signal
    input wire retract,                  // 悔棋
    input wire [3:0] write_i,            // The position to write information
    input wire [3:0] write_j,
    input wire write_color,              // The color to write in, 0 is black, 1 is white
    
    input wire [3:0] logic_i,            // Row needed by logic
    input wire [3:0] display_i,          // Row needed by display
    
    output wire [14:0] logic_row,        // Row information for logic
    output wire [14:0] display_black,    // Row information for display
    output wire [14:0] display_white,

    input wire [3:0] consider_i,         // Row considered by strategy/checker
    input wire [3:0] consider_j,         // Column considered by s/c

    output reg [8:0] black_i,            // Row information for s/c
    output reg [8:0] black_j,            // Column information for s/c
    output reg [8:0] black_ij,           // Main diagonal information for s/c
    output reg [8:0] black_ji,           // Counter diagonal information for s/c
    output reg [8:0] white_i,
    output reg [8:0] white_j,
    output reg [8:0] white_ij,
    output reg [8:0] white_ji,
    output reg [8:0] grid_i,
    output reg [8:0] grid_j,
    output reg [8:0] grid_ij,
    output reg [8:0] grid_ji
    );
    
    // Side parameters
    localparam BLACK = 1'b0,
               WHITE = 1'b1;
    
    // Chessboard parameters
    localparam BOARD_SIZE = 15;
    
    // RAMs, store the information of the black/white chess
    reg [14:0] board_black [14:0];
    reg [14:0] board_white [14:0];
        
    // Helper registers to fetch information from RAM
    integer i, j;
    reg [14:0] row_4b, row_3b, row_2b, row_1b, row0b,
               row1b, row2b, row3b, row4b;
    reg [14:0] row_4w, row_3w, row_2w, row_1w, row0w,
               row1w, row2w, row3w, row4w;
    reg [14:0] row_4g, row_3g, row_2g, row_1g, row0g,   /* 边界 */
               row1g, row2g, row3g, row4g;

    // Generate the output
    assign logic_row = board_black[logic_i] | board_white[logic_i];
    assign display_black = board_black[display_i];
    assign display_white = board_white[display_i];
    
    always @ (posedge clk or posedge rst_p) begin
        if (rst_p || clr) begin
            board_black[0] <= 15'b0;
            board_black[1] <= 15'b0;
            board_black[2] <= 15'b0;
            board_black[3] <= 15'b0;
            board_black[4] <= 15'b0;
            board_black[5] <= 15'b0;
            board_black[6] <= 15'b0;
            board_black[7] <= 15'b0;
            board_black[8] <= 15'b0;
            board_black[9] <= 15'b0;
            board_black[10] <= 15'b0;
            board_black[11] <= 15'b0;
            board_black[12] <= 15'b0;
            board_black[13] <= 15'b0;
            board_black[14] <= 15'b0;
            
            board_white[0] <= 15'b0;
            board_white[1] <= 15'b0;
            board_white[2] <= 15'b0;
            board_white[3] <= 15'b0;
            board_white[4] <= 15'b0;
            board_white[5] <= 15'b0;
            board_white[6] <= 15'b0;
            board_white[7] <= 15'b0;
            board_white[8] <= 15'b0;
            board_white[9] <= 15'b0;
            board_white[10] <= 15'b0;
            board_white[11] <= 15'b0;
            board_white[12] <= 15'b0;
            board_white[13] <= 15'b0;
            board_white[14] <= 15'b0;
        end
        else if (write) begin
            if (write_color == BLACK)
                board_black[write_i] <= board_black[write_i] |
                                        (15'b1 << write_j);
            else
                board_white[write_i] <= board_white[write_i] |
                                        (15'b1 << write_j);
        end else if (retract) begin
            if (write_color == BLACK)
                board_black[write_i] <= board_black[write_i] &
                                        (~(15'b1 << write_j));
            else
                board_white[write_i] <= board_white[write_i] &
                                        (~(15'b1 << write_j));
        end
    end
    
    always @ (*) begin        
        i = consider_i;
        j = consider_j;
        
        // Fetch the data of the rows from i-4 to i+4
        if (i - 4 >= 0) begin
            row_4b = board_black[i - 4];
            row_4w = board_white[i - 4];
            row_4g = 15'b0;
        end
        else begin
            row_4b = 15'b0;
            row_4w = 15'b0;
            row_4g = 15'h7FFFF;
        end
        
        if (i - 3 >= 0) begin
            row_3b = board_black[i - 3];
            row_3w = board_white[i - 3];
            row_3g = 15'b0;
        end
        else begin
            row_3b = 15'b0;
            row_3w = 15'b0;
            row_3g = 15'h7FFFF;
        end
        
        if (i - 2 >= 0) begin
            row_2b = board_black[i - 2];
            row_2w = board_white[i - 2];
            row_2g = 15'b0;
        end
        else begin
            row_2b = 15'b0;
            row_2w = 15'b0;
            row_2g = 15'h7FFFF;
        end
        
        if (i - 1 >= 0) begin
            row_1b = board_black[i - 1];
            row_1w = board_white[i - 1];
            row_1g = 15'b0;
        end
        else begin
            row_1b = 15'b0;
            row_1w = 15'b0;
            row_1g = 15'h7FFFF;
        end
        
        if (i >= 0 && i < BOARD_SIZE) begin
            row0b = board_black[i];
            row0w = board_white[i];
            row0g = 15'b0;
        end
        else begin
            row0b = 15'b0;
            row0w = 15'b0;
            row0g = 15'h7FFFF;
        end
        
        if (i + 1 < BOARD_SIZE) begin
            row1b = board_black[i + 1];
            row1w = board_white[i + 1];
            row1g = 15'b0;
        end
        else begin
            row1b = 15'b0;
            row1w = 15'b0;
            row1g = 15'h7FFFF;
        end
        
        if (i + 2 < BOARD_SIZE) begin
            row2b = board_black[i + 2];
            row2w = board_white[i + 2];
            row2g = 15'b0;
        end
        else begin
            row2b = 15'b0;
            row2w = 15'b0;
            row2g = 15'h7FFFF;
        end
        
        if (i + 3 < BOARD_SIZE) begin
            row3b = board_black[i + 3];
            row3w = board_white[i + 3];
            row3g = 15'b0;
        end
        else begin
            row3b = 15'b0;
            row3w = 15'b0;
            row3g = 15'h7FFFF;
        end
        
        if (i + 4 < BOARD_SIZE) begin
            row4b = board_black[i + 4];
            row4w = board_white[i + 4];
            row4g = 15'b0;
        end
        else begin
            row4b = 15'b0;
            row4w = 15'b0;
            row4g = 15'h7FFFF;
        end
        
        // Write the data of each grid to the output
        if (j - 4 >= 0) begin
            black_i[0] = row0b[j - 4];
            white_i[0] = row0w[j - 4];
            grid_i[0] = 1'b0;
            black_ij[0] = row_4b[j - 4];
            white_ij[0] = row_4w[j - 4];
            grid_ij[0] = 1'b0;
            black_ji[0] = row4b[j - 4];
            white_ji[0] = row4w[j - 4];
            grid_ji[0] = 1'b0;
        end
        else begin
            black_i[0] = 1'b0;
            white_i[0] = 1'b0;
            grid_i[0] = 1'b1;
            black_ij[0] = 1'b0;
            white_ij[0] = 1'b0;
            grid_ij[0] = 1'b1;
            black_ji[0] = 1'b0;
            white_ji[0] = 1'b0;
            grid_ji[0] = 1'b1;
        end
        
        if (j - 3 >= 0) begin
            black_i[1] = row0b[j - 3];
            white_i[1] = row0w[j - 3];
            grid_i[1] = 1'b0;
            black_ij[1] = row_3b[j - 3];
            white_ij[1] = row_3w[j - 3];
            grid_ij[1] = 1'b0;
            black_ji[1] = row3b[j - 3];
            white_ji[1] = row3w[j - 3];
            grid_ji[1] = 1'b0;
        end
        else begin
            black_i[1] = 1'b0;
            white_i[1] = 1'b0;
            grid_i[1] = 1'b1;
            black_ij[1] = 1'b0;
            white_ij[1] = 1'b0;
            grid_ij[1] = 1'b1;
            black_ji[1] = 1'b0;
            white_ji[1] = 1'b0;
            grid_ji[1] = 1'b1;
        end
        
        if (j - 2 >= 0) begin
            black_i[2] = row0b[j - 2];
            white_i[2] = row0w[j - 2];
            grid_i[2] = 1'b0;
            black_ij[2] = row_2b[j - 2];
            white_ij[2] = row_2w[j - 2];
            grid_ij[2] = 1'b0;
            black_ji[2] = row2b[j - 2];
            white_ji[2] = row2w[j - 2];
            grid_ji[2] = 1'b0;
        end
        else begin
            black_i[2] = 1'b0;
            white_i[2] = 1'b0;
            grid_i[2] = 1'b1;
            black_ij[2] = 1'b0;
            white_ij[2] = 1'b0;
            grid_ij[2] = 1'b1;
            black_ji[2] = 1'b0;
            white_ji[2] = 1'b0;
            grid_ji[2] = 1'b1;
        end
        
        if (j - 1 >= 0) begin
            black_i[3] = row0b[j - 1];
            white_i[3] = row0w[j - 1];
            grid_i[3] = 1'b0;
            black_ij[3] = row_1b[j - 1];
            white_ij[3] = row_1w[j - 1];
            grid_ij[3] = 1'b0;
            black_ji[3] = row1b[j - 1];
            white_ji[3] = row1w[j - 1];
            grid_ji[3] = 1'b0;
        end
        else begin
            black_i[3] = 1'b0;
            white_i[3] = 1'b0;
            grid_i[3] = 1'b1;
            black_ij[3] = 1'b0;
            white_ij[3] = 1'b0;
            grid_ij[3] = 1'b1;
            black_ji[3] = 1'b0;
            white_ji[3] = 1'b0;
            grid_ji[3] = 1'b1;
        end
        
        if (j >= 0 && j < BOARD_SIZE) begin
            black_i[4] = row0b[j];
            white_i[4] = row0w[j];
            grid_i[4] = 1'b0;
            black_ij[4] = row0b[j];
            white_ij[4] = row0w[j];
            grid_ij[4] = 1'b0;
            black_ji[4] = row0b[j];
            white_ji[4] = row0w[j];
            grid_ji[4] = 1'b0;
            
            black_j[0] = row_4b[j];
            black_j[1] = row_3b[j];
            black_j[2] = row_2b[j];
            black_j[3] = row_1b[j];
            black_j[4] = row0b[j];
            black_j[5] = row1b[j];
            black_j[6] = row2b[j];
            black_j[7] = row3b[j];
            black_j[8] = row4b[j];
            white_j[0] = row_4w[j];
            white_j[1] = row_3w[j];
            white_j[2] = row_2w[j];
            white_j[3] = row_1w[j];
            white_j[4] = row0w[j];
            white_j[5] = row1w[j];
            white_j[6] = row2w[j];
            white_j[7] = row3w[j];
            white_j[8] = row4w[j];
            grid_j = 9'b0;
        end
        else begin
            black_i[4] = 1'b0;
            white_i[4] = 1'b0;
            grid_i[4] = 1'b1;
            black_ij[4] = 1'b0;
            white_ij[4] = 1'b0;
            grid_ij[4] = 1'b1;
            black_ji[4] = 1'b0;
            white_ji[4] = 1'b0;
            grid_ji[4] = 1'b1;
            
            black_j[0] = 1'b0;
            black_j[1] = 1'b0;
            black_j[2] = 1'b0;
            black_j[3] = 1'b0;
            black_j[4] = 1'b0;
            black_j[5] = 1'b0;
            black_j[6] = 1'b0;
            black_j[7] = 1'b0;
            black_j[8] = 1'b0;
            white_j[0] = 1'b0;
            white_j[1] = 1'b0;
            white_j[2] = 1'b0;
            white_j[3] = 1'b0;
            white_j[4] = 1'b0;
            white_j[5] = 1'b0;
            white_j[6] = 1'b0;
            white_j[7] = 1'b0;
            white_j[8] = 1'b0;
            grid_j = 9'h1FF;
        end
        
        if (j + 1 < BOARD_SIZE) begin
            black_i[5] = row0b[j + 1];
            white_i[5] = row0w[j + 1];
            grid_i[5] = 1'b0;
            black_ij[5] = row1b[j + 1];
            white_ij[5] = row1w[j + 1];
            grid_ij[5] = 1'b0;
            black_ji[5] = row_1b[j + 1];
            white_ji[5] = row_1w[j + 1];
            grid_ji[5] = 1'b0;
        end
        else begin
            black_i[5] = 1'b0;
            white_i[5] = 1'b0;
            grid_i[5] = 1'b1;
            black_ij[5] = 1'b0;
            white_ij[5] = 1'b0;
            grid_ij[5] = 1'b1;
            black_ji[5] = 1'b0;
            white_ji[5] = 1'b0;
            grid_ji[5] = 1'b1;
        end
        
        if (j + 2 < BOARD_SIZE) begin
            black_i[6] = row0b[j + 2];
            white_i[6] = row0w[j + 2];
            grid_i[6] = 1'b0;
            black_ij[6] = row2b[j + 2];
            white_ij[6] = row2w[j + 2];
            grid_ij[6] = 1'b0;
            black_ji[6] = row_2b[j + 2];
            white_ji[6] = row_2w[j + 2];
            grid_ji[6] = 1'b0;
        end
        else begin
            black_i[6] = 1'b0;
            white_i[6] = 1'b0;
            grid_i[6] = 1'b1;
            black_ij[6] = 1'b0;
            white_ij[6] = 1'b0;
            grid_ij[6] = 1'b1;
            black_ji[6] = 1'b0;
            white_ji[6] = 1'b0;
            grid_ji[6] = 1'b1;
        end
        
        if (j + 3 < BOARD_SIZE) begin
            black_i[7] = row0b[j + 3];
            white_i[7] = row0w[j + 3];
            grid_i[7] = 1'b0;
            black_ij[7] = row3b[j + 3];
            white_ij[7] = row3w[j + 3];
            grid_ij[7] = 1'b0;
            black_ji[7] = row_3b[j + 3];
            white_ji[7] = row_3w[j + 3];
            grid_ji[7] = 1'b0;
        end
        else begin
            black_i[7] = 1'b0;
            white_i[7] = 1'b0;
            grid_i[7] = 1'b1;
            black_ij[7] = 1'b0;
            white_ij[7] = 1'b0;
            grid_ij[7] = 1'b1;
            black_ji[7] = 1'b0;
            white_ji[7] = 1'b0;
            grid_ji[7] = 1'b1;
        end
        
        if (j + 4 < BOARD_SIZE) begin
            black_i[8] = row0b[j + 4];
            white_i[8] = row0w[j + 4];
            grid_i[8] = 1'b0;
            black_ij[8] = row4b[j + 4];
            white_ij[8] = row4w[j + 4];
            grid_ij[8] = 1'b0;
            black_ji[8] = row_4b[j + 4];
            white_ji[8] = row_4w[j + 4];
            grid_ji[8] = 1'b0;
        end
        else begin
            black_i[8] = 1'b0;
            white_i[8] = 1'b0;
            grid_i[8] = 1'b1;
            black_ij[8] = 1'b0;
            white_ij[8] = 1'b0;
            grid_ij[8] = 1'b1;
            black_ji[8] = 1'b0;
            white_ji[8] = 1'b0;
            grid_ji[8] = 1'b1;
        end
    end
     
endmodule
