`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Checker to check if someone wins the game
//------------------------------------------------------------------------------
module win_checker(
    input wire clk,               // Clock
    input wire rst,               // Reset
    input wire clr,               // Clear
    input wire active,            // Active signal
    
    input wire [8:0] black_i,     // Row information
    input wire [8:0] black_j,     // Column information
    input wire [8:0] black_ij,    // Main diagonal information
    input wire [8:0] black_ji,    // Counter diagonal information
    input wire [8:0] white_i,
    input wire [8:0] white_j,
    input wire [8:0] white_ij,
    input wire [8:0] white_ji,
    
    output reg [3:0] get_i,       // Current row considered       
    output reg [3:0] get_j,       // Current column considered
    output reg is_win             // If someone wins the game
    );
    
    // Chessboard parameters
    localparam BOARD_SIZE = 15;
    
    // State parameters
    localparam STATE_IDLE = 1'b0,
               STATE_WORKING = 1'b1;
    
    reg state;    // Current state
    
    // Pattern recognizers
    wire b0, b1, b2, b3, w0, w1, w2, w3;
    pattern_five pattern_b0(black_i, b0),
                 pattern_b1(black_j, b1),
                 pattern_b2(black_ij, b2),
                 pattern_b3(black_ji, b3),
                 pattern_w0(white_i, w0),
                 pattern_w1(white_j, w1),
                 pattern_w2(white_ij, w2),
                 pattern_w3(white_ji, w3);
    
    // FSM of the checker
    // Every time the active signal comes, the checker will run once
    always @ (posedge clk or negedge rst) begin
        if (!rst || clr) begin
            get_i <= 4'b0;
            get_j <= 4'b0;
            is_win <= 0;
            
            state <= STATE_IDLE;
        end
        else if (!active && state == STATE_IDLE)
            state <= STATE_WORKING;
        else if (active && state == STATE_WORKING) begin
            // Check if someone wins the game
            if (get_i == 4'b0 && get_j == 4'b0)
                is_win <= b0 | b1 | b2 | b3 | w0 | w1 | w2 | w3;
            else
                is_win <= is_win | b0 | b1 | b2 | b3 | w0 | w1 | w2 | w3;
            
            // Move to the next position
            if (get_j == BOARD_SIZE - 1) begin
                if (get_i == BOARD_SIZE - 1) begin
                    get_i <= 4'b0;
                    get_j <= 4'b0;
                    state <= STATE_IDLE;
                end
                else begin
                    get_i <= get_i + 1'b1;
                    get_j <= 4'b0;
                end
            end
            else
                get_j <= get_j + 1'b1;
        end
    end
    
endmodule
