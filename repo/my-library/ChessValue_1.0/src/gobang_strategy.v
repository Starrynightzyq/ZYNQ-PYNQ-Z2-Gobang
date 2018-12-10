`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// A simple strategy for the gobang game.
//------------------------------------------------------------------------------
module gobang_strategy #(
    parameter live_Five = 2500,
    parameter live_Four = 216,
    parameter sleep_Four = 36,
    parameter live_Three = 36,
    parameter live_Two = 6,
    parameter live_One = 1,
    parameter un_known = 0 //全为空或者未知
    )(
    input wire clk,                        // Clock
    input wire rst,                        // Reset (active low)
    input wire clr,                        // Clear
    input wire active,                     // Active signal (active high)
    input wire random,                     // Random signal
    
    input wire [8:0] black_i,              // Row information
    input wire [8:0] black_j,              // Column information
    input wire [8:0] black_ij,             // Main diagonal information
    input wire [8:0] black_ji,             // Counter diagonal information
    input wire [8:0] white_i,
    input wire [8:0] white_j,
    input wire [8:0] white_ij,
    input wire [8:0] white_ji,
    input wire [8:0] grid_i,
    input wire [8:0] grid_j,
    input wire [8:0] grid_ij,
    input wire [8:0] grid_ji,
    
    output reg [3:0] get_i,                // Current row considered
    output reg [3:0] get_j,                // Current column considered
    
    output reg [15:0] black_best_score,    // Best possible score
    output reg [3:0] black_best_i,         // Best row
    output reg [3:0] black_best_j,         // Best column
    output reg [15:0] white_best_score,
    output reg [3:0] white_best_i,
    output reg [3:0] white_best_j,
    output reg data_valued,

    output reg black_win,                  //win checker
    output reg white_win,
    output reg [3:0] win_begin_j,
    output reg [3:0] win_begin_i,
    output reg [3:0] win_end_j,
    output reg [3:0] win_end_i
    );

    reg [15:0] black_best_score_t;    // Best possible score
    reg [3:0] black_best_i_t;         // Best row
    reg [3:0] black_best_j_t;         // Best column
    reg [15:0] white_best_score_t;
    reg [3:0] white_best_i_t;
    reg [3:0] white_best_j_t;
    
    // Chessboard parameters
    localparam BOARD_SIZE = 15;
    
    // State parameters
    localparam STATE_IDLE = 2'd0,
               STATE_WORKING = 2'd1,
               STATE_END = 2'd2;

    reg [1:0] state_reg = 2'b0;
    reg [1:0] state_next = 2'b0;

    localparam WORK_IDLE  = 4'd0,
               WORK_SEAT0 = 4'd1,
               WORK_SEAT1 = 4'd2,
               WORK_SEAT2 = 4'd3,
               WORK_SEAT3 = 4'd4,
               WORK_COMP  = 4'd5,
               WORK_INT   = 4'd6;

    reg [3:0] work_state_reg = 4'b0;
    reg [3:0] work_state_next = 4'b0;
    
    reg state;    // Current state
    
    // Scores of the four directions
    wire [15:0] black_score_i, black_score_j, black_score_ij, black_score_ji;
    wire [15:0] white_score_i, white_score_j, white_score_ij, white_score_ji;
    
    // Total scores
    wire [15:0] black_score, white_score;
    assign black_score = black_score_i + black_score_j +
                         black_score_ij + black_score_ji;
    assign white_score = white_score_i + white_score_j +
                         white_score_ij + white_score_ji;
    
    wire seat_end;
    assign seat_end = (get_j == (BOARD_SIZE - 1))&&(get_i == (BOARD_SIZE - 1));

    wire work_end;
    assign work_end = (seat_end)&&(work_state_reg == WORK_INT);

    // Score calculators
    score_calculator # ( 
        .live_Five(live_Five),
        .live_Four(live_Four),
        .sleep_Four(sleep_Four),
        .live_Three(live_Three),
        .live_Two(live_Two),
        .live_One(live_One),
        .un_known(un_known) //全为空或者未知
    )  
        calc_black_i(
            .my(black_i),
            .op(white_i),
            .gr(grid_i),
            .score(black_score_i)
        ),
        calc_black_j(
            .my(black_j),
            .op(white_j),
            .gr(grid_j),
            .score(black_score_j)
        ),
        calc_black_ij(
            .my(black_ij),
            .op(white_ij),
            .gr(grid_ij),
            .score(black_score_ij)
        ),
        calc_black_ji(
            .my(black_ji),
            .op(white_ji),
            .gr(grid_ji),
            .score(black_score_ji)
        ),
        calc_white_i(
            .my(white_i),
            .op(black_i),
            .gr(grid_i),
            .score(white_score_i)
        ),
        calc_white_j(
            .my(white_j),
            .op(black_j),
            .gr(grid_j),
            .score(white_score_j)
        ),
        calc_white_ij(
            .my(white_ij),
            .op(black_ij),
            .gr(grid_ij),
            .score(white_score_ij)
        ),
        calc_white_ji(
            .my(white_ji),
            .op(black_ji),
            .gr(grid_ji),
            .score(white_score_ji)
        );

    wire black_win_t;                  //win checker
    wire white_win_t;
    wire [3:0] win_begin_j_t;
    wire [3:0] win_begin_i_t;
    wire [3:0] win_end_j_t;
    wire [3:0] win_end_i_t;

    cherker U_cherker (
        .black_i(black_i),
        .black_j(black_j),
        .black_ij(black_ij),
        .black_ji(black_ji),
        .white_i(white_i),
        .white_j(white_j),
        .white_ij(white_ij),
        .white_ji(white_ji),

        .get_j(get_j),
        .get_i(get_i),

        .black_win(black_win_t),
        .white_win(white_win_t),
        .win_begin_j(win_begin_j_t),
        .win_begin_i(win_begin_i_t),
        .win_end_j(win_end_j_t),
        .win_end_i(win_end_i_t)
        );

    //FSM
    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            // reset
            state_reg <= STATE_IDLE;
        end
        else begin
            state_reg <= state_next;
        end
    end

    always @(*) begin
        state_next = state_reg;
        case(state_reg)
        STATE_IDLE:begin
            if (active) begin
                state_next = STATE_WORKING;
            end else begin
                state_next = STATE_IDLE;
            end
        end
        STATE_WORKING:begin
            if(clr) begin
                state_next = STATE_IDLE;
            end else if(work_end) begin     //working end
                state_next = STATE_END;
            end else begin
                state_next = STATE_WORKING;
            end
        end
        STATE_END:begin
            state_next = STATE_IDLE;
        end
        default:begin
            state_next = STATE_IDLE;
        end
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            // reset
            work_state_reg <= WORK_IDLE;
        end
        else begin
            if (state_reg == STATE_WORKING) begin
                work_state_reg <= work_state_next;
            end else begin
                work_state_reg <= WORK_IDLE;
            end

            if (state_reg == STATE_END) begin
                data_valued <= 1'b1;
            end else begin
                data_valued <= 1'b0;
            end
        end
    end

    always @(*) begin
        work_state_next = work_state_reg;
        case(work_state_reg)
        WORK_IDLE:begin
            // if (state_reg == STATE_WORKING) begin
                work_state_next = WORK_SEAT0;
            // end else begin
            //     work_state_reg = WORK_IDLE;
            // end
        end
        WORK_SEAT0:begin
            work_state_next = WORK_SEAT1;
        end
        WORK_SEAT1:begin
            work_state_next = WORK_SEAT2;
        end
        WORK_SEAT2:begin
            work_state_next = WORK_SEAT3;
        end
        WORK_SEAT3:begin
            work_state_next = WORK_COMP;
        end
        WORK_COMP:begin
            work_state_next = WORK_INT;
        end
        WORK_INT:begin
            work_state_next = WORK_IDLE;
        end
        default:begin
            work_state_next = WORK_IDLE;
        end
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            // reset
            get_i <= 4'b0;
            get_j <= 4'b0;
            black_best_score_t <= 0;
            black_best_i_t <= BOARD_SIZE / 2;
            black_best_j_t <= BOARD_SIZE / 2;
            white_best_score_t <= 0;
            white_best_i_t <= BOARD_SIZE / 2;
            white_best_j_t <= BOARD_SIZE / 2;
            // data_valued <= 1'b0;  
        end
        else begin
            if (work_state_reg == WORK_COMP) begin  //比较
                if ((get_i == 4'b0 && get_j == 4'b0) ||
                black_score > black_best_score_t ||
                (black_score == black_best_score_t && random)) begin
                    black_best_score_t <= black_score;
                    black_best_i_t <= get_i;
                    black_best_j_t <= get_j;
                end
                if ((get_i == 4'b0 && get_j == 4'b0) ||
                    white_score > white_best_score_t ||
                    (white_score == white_best_score_t && random)) begin
                    white_best_score_t <= white_score;
                    white_best_i_t <= get_i;
                    white_best_j_t <= get_j;
                end 
            end

            if (work_state_reg == WORK_INT) begin   //坐标加一
                if (get_j == BOARD_SIZE - 1) begin
                    if (get_i == BOARD_SIZE - 1) begin
                        get_i <= 4'b0;
                        get_j <= 4'b0;
                    end else begin
                        get_i <= get_i + 1'b1;
                        get_j <= 4'b0;
                    end
                end else begin
                    get_j <= get_j + 1'b1;
                end
            end

        end
    end
    
    //output
    always @(posedge clk or negedge rst) begin
        if (!rst || clr) begin
            // reset
            black_best_score <= 12'b0;    // Best possible score
            black_best_i <= 4'b0;         // Best row
            black_best_j <= 4'b0;         // Best column
            white_best_score <= 12'b0;
            white_best_i <= 4'b0;
            white_best_j <= 4'b0;

            black_win <= 1'b0;                   //win checker
            white_win <= 1'b0; 
            win_begin_j <= 4'b0; 
            win_begin_i <= 4'b0; 
            win_end_j <= 4'b0; 
            win_end_i <= 4'b0; 
        end
        else if (data_valued) begin
            black_best_score <= black_best_score_t;    // Best possible score
            black_best_i <= black_best_i_t;         // Best row
            black_best_j <= black_best_j_t;         // Best column
            white_best_score <= white_best_score_t;
            white_best_i <= white_best_i_t;
            white_best_j <= white_best_j_t;   

            black_win <= black_win_t;                   //win checker
            white_win <= white_win_t; 
            win_begin_j <= win_begin_j_t; 
            win_begin_i <= win_begin_i_t; 
            win_end_j <= win_end_j_t; 
            win_end_i <= win_end_i_t;          
        end
    end

endmodule
