`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Calculate the score of a given pattern
//------------------------------------------------------------------------------
module cherker (    
    input wire [8:0] black_i,              // Row information
    input wire [8:0] black_j,              // Column information
    input wire [8:0] black_ij,             // Main diagonal information
    input wire [8:0] black_ji,             // Counter diagonal information
    input wire [8:0] white_i,
    input wire [8:0] white_j,
    input wire [8:0] white_ij,
    input wire [8:0] white_ji,

    input wire [3:0] get_i,                // Current row considered
    input wire [3:0] get_j,                // Current column considered

    output reg black_win,
    output reg white_win,
    output reg [3:0] win_begin_j,
    output reg [3:0] win_begin_i,
    output reg [3:0] win_end_j,
    output reg [3:0] win_end_i
    );

    wire b0, b1, b2, b3, w0, w1, w2, w3;
    wire [3:0] coord_b0, coord_b1, coord_b2, coord_b3, coord_w0, coord_w1, coord_w2, coord_w3;
    five_checker pattern_b0(black_i, coord_b0, b0),
                 pattern_b1(black_j, coord_b1, b1),
                 pattern_b2(black_ij, coord_b2, b2),
                 pattern_b3(black_ji, coord_b3, b3),
                 pattern_w0(white_i, coord_w0, w0),
                 pattern_w1(white_j, coord_w1, w1),
                 pattern_w2(white_ij, coord_w2, w2),
                 pattern_w3(white_ji, coord_w3, w3);
    
    always @(*) begin
        if (b0 || b1 || b2 || b3) begin
            black_win = 1'b1;
        end else begin
            black_win = 1'b0;
        end
    end

    always @(*) begin
        if (w0 || w1 || w2 || w3) begin
            white_win = 1'b1;
        end else begin
            white_win = 1'b0;
        end
    end

    always @(*) begin
        win_begin_j = 0;
        win_begin_i = 0;
        win_end_j = 0;
        win_end_i = 0;
    end

endmodule
