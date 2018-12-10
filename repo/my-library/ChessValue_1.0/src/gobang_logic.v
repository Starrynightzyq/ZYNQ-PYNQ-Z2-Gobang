`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// The logic part of the gobang game
//------------------------------------------------------------------------------
module gobang_logic(
    input wire clk_slow,             // Slower clock for main FSM
    input wire clk_fast,             // Faster clock for strategy and checker
    input wire rst,                  // Reset
    input wire random,               // Random signal
    
    input wire key_up,               // If UP key is pressed
    input wire key_down,             // If DOWN key is pressed
    input wire key_left,             // If LEFT key is pressed
    input wire key_right,            // If RIGHT key is pressed
    input wire key_ok,               // If OK key is pressed
    input wire key_switch,           // If SWITCH key is pressed
    
    input wire [8:0] black_i,        // Row information for strategy/checker
    input wire [8:0] black_j,        // Column information for s/c
    input wire [8:0] black_ij,       // Main diagonal information for s/c
    input wire [8:0] black_ji,       // Counter diagonal information for s/c
    input wire [8:0] white_i,
    input wire [8:0] white_j,
    input wire [8:0] white_ij,
    input wire [8:0] white_ji,
    input wire [14:0] chess_row,     // Row information for main logic
    
    output wire [3:0] consider_i,    // The row s/c is considering
    output wire [3:0] consider_j,    // The column s/c is considering
    
    output reg data_clr,             // Clear the datapath
    output reg data_write,           // Writing-enable signal of the datapath
    
    output reg [3:0] cursor_i,       // Row of the cursor
    output reg [3:0] cursor_j,       // Column of the cursor
    output reg black_is_player,      // If black is not AI
    output reg white_is_player,      // If white is not AI
    output reg crt_player,           // Current player
    output reg game_running,         // If the game is running
    output reg [1:0] winner          // Who wins the game
    );
    
    // Side parameters
    localparam BLACK = 1'b0,
               WHITE = 1'b1;
    
    // Chessboard parameters
    localparam BOARD_SIZE = 15;
    
    // State parameters
    localparam STATE_IDLE = 3'b000,
               STATE_MOVE = 3'b001,
               STATE_WAIT = 3'b010,
               STATE_DECIDE = 3'b011,
               STATE_PUT_CHESS = 3'b100,
               STATE_PUT_END = 3'b101,
               STATE_CHECK = 3'b110,
               STATE_GAME_END = 3'b111;
    
    // Lasting time for STATE_WAIT
    localparam WAIT_TIME = 400;
    
    reg [2:0] state;         // Current game state
    reg [8:0] wait_count;
    reg [7:0] move_count;    // How many moves have been played
    
    // A simple strategy for the game
    reg strategy_clr, strategy_active;
    wire [3:0] strategy_i, strategy_j;
    wire [12:0] black_best_score;
    wire [3:0] black_best_i, black_best_j;
    wire [12:0] white_best_score;
    wire [3:0] white_best_i, white_best_j;
    gobang_strategy
        strategy(
            .clk(clk_fast),
            .rst(rst),
            .clr(strategy_clr),
            .active(strategy_active),
            .random(random),
            .black_i(black_i),
            .black_j(black_j),
            .black_ij(black_ij),
            .black_ji(black_ji),
            .white_i(white_i),
            .white_j(white_j),
            .white_ij(white_ij),
            .white_ji(white_ji),
            .get_i(strategy_i),
            .get_j(strategy_j),
            .black_best_score(black_best_score),
            .black_best_i(black_best_i),
            .black_best_j(black_best_j),
            .white_best_score(white_best_score),
            .white_best_i(white_best_i),
            .white_best_j(white_best_j)
        );
    
    // A checker to check if someone wins the game
    reg win_clr, win_active;
    wire [3:0] win_i, win_j;
    wire is_win;
    win_checker
        checker(
            .clk(clk_fast),
            .rst(rst),
            .clr(win_clr),
            .active(win_active),
            .black_i(black_i),
            .black_j(black_j),
            .black_ij(black_ij),
            .black_ji(black_ji),
            .white_i(white_i),
            .white_j(white_j),
            .white_ij(white_ij),
            .white_ji(white_ji),
            .get_i(win_i),
            .get_j(win_j),
            .is_win(is_win)
        );
    
    // The strategy and the checker uses the same port to get information,
    // but they will not use it at the same time
    assign consider_i = strategy_i | win_i;
    assign consider_j = strategy_j | win_j;
    
    // Main FSM of the game
    always @ (posedge clk_slow or negedge rst) begin
        if (!rst) begin
            cursor_i <= BOARD_SIZE;
            cursor_j <= BOARD_SIZE;
            {white_is_player, black_is_player} <= 2'b01;
            crt_player <= BLACK;
            game_running <= 1'b0;
            winner <= 2'b00;
            
            state <= STATE_IDLE;
            move_count <= 8'b0;
            data_clr <= 1'b0;
            data_write <= 1'b0;
            strategy_clr <= 1'b0;
            strategy_active <= 1'b0;
            win_clr <= 1'b0;
            win_active <= 1'b0;
        end
        else begin
            case (state)
            STATE_IDLE:
                if (key_ok) begin
                    // Press OK key to start the game
                    cursor_i <= BOARD_SIZE/2;
                    cursor_j <= BOARD_SIZE/2;
                    crt_player <= BLACK;
                    game_running <= 1'b1;
                    winner <= 2'b00;
                    
                    state <= STATE_MOVE;
                    move_count <= 8'b0;
                    data_clr <= 1'b1;
                    strategy_clr <= 1'b1;
                    win_clr <= 1'b1;
                end
                else if (key_switch)
                    // Switch player
                    {white_is_player, black_is_player} <= 
                    {white_is_player, black_is_player} + 2'b1;
                else
                    state <= STATE_IDLE;
            
            STATE_MOVE: begin
                data_clr <= 1'b0;
                strategy_clr <= 1'b0;
                win_clr <= 1'b0;
                
                if ((crt_player == BLACK && black_is_player) ||
                    (crt_player == WHITE && white_is_player)) begin
                    // Player's move
                    
                    // Move the cursor
                    if (key_up && cursor_i > 0)
                        cursor_i <= cursor_i - 1'b1;
                    else if (key_down && cursor_i < BOARD_SIZE - 1)
                        cursor_i <= cursor_i + 1'b1;
                    if (key_left && cursor_j > 0)
                        cursor_j <= cursor_j - 1'b1;
                    else if (key_right && cursor_j < BOARD_SIZE - 1)
                        cursor_j <= cursor_j + 1'b1;
                    
                    if (key_ok)
                        // Press OK key to put the chess
                        state <= STATE_PUT_CHESS;
                end
                else begin
                    // CPU's move
                    strategy_active <= 1'b1;
                    state <= STATE_WAIT;
                    wait_count <= 0;
                end
            end
            
            STATE_WAIT:
                // Wait for a while, otherwise the CPU will deicide too fast
                if (wait_count >= WAIT_TIME)
                    state <= STATE_DECIDE;
                else
                    wait_count <= wait_count + 1'b1;
            
            STATE_DECIDE: begin
                // Compare the best possible score for my side and the opposite,
                // and choose the best position
                strategy_active <= 1'b0;
                if (black_best_score > white_best_score ||
                    (black_best_score == white_best_score &&
                    crt_player == BLACK)) begin
                    cursor_i <= black_best_i;
                    cursor_j <= black_best_j;
                end
                else begin
                    cursor_i <= white_best_i;
                    cursor_j <= white_best_j;
                end
                
                state <= STATE_PUT_CHESS;
            end
            
            STATE_PUT_CHESS:
                // Check if the position is occupied. If not, put the chess
                if (!chess_row[cursor_j]) begin
                    move_count <= move_count + 8'b1;
                    data_write <= 1'b1;
                    state <= STATE_PUT_END;
                end
                else
                    state <= STATE_MOVE;
            
            STATE_PUT_END: begin
                data_write <= 1'b0;
                win_active <= 1'b1;
                state <= STATE_CHECK;
            end
            
            STATE_CHECK: begin
                // Check if someone wins the game or there is a draw
                win_active <= 1'b0;
                if (is_win || move_count == BOARD_SIZE * BOARD_SIZE)
                    state <= STATE_GAME_END;
                else begin
                    crt_player <= ~crt_player;
                    state <= STATE_MOVE;
                end
            end
            
            STATE_GAME_END: begin
                if (is_win)
                    // Someone wins the game
                    winner <= 2'b01 << crt_player;
                else
                    // There is a draw
                    winner <= 2'b11;
                
                state <= STATE_IDLE;
                game_running <= 1'b0;
            end
            
            endcase
        end
    end
    
endmodule
