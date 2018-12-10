`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Calculate the score of a given pattern
//------------------------------------------------------------------------------
module score_calculator #(
    parameter live_Five = 2500,
    parameter live_Four = 216,
    parameter sleep_Four = 36,
    parameter live_Three = 36,
    parameter live_Two = 6,
    parameter live_One = 1,
    parameter un_known = 0 //全为空或者未知
    // parameter sleep_Three = 25,
    // parameter sleep_Two = 5,
    // parameter sleep_One = 1,
    // parameter Polluted = 0  //混合
    )(
    input wire [8:0] my,       // Pattern of my side
    input wire [8:0] op,       // Pattern of the opposite side
    input wire [8:0] gr,       // border
    output reg [15:0] score    // The score of the given pattern
    );
    
    wire [8:0] my_next;
    wire [8:0] op_next;
    assign my_next = my | 9'b000010000;
    assign op_next = op | gr;
    wire chess_nempty;   //当前落子位置非空
    assign chess_nempty = (my[4] || op[4]);
    
    // wire score2, score4, score5, score8, score15,
    //      score40, score70, score300, score2000;

    wire s_lfive, s_lfour, s_sfour, s_lthree, s_sthree, s_ltwo, s_stwo, s_lone;
    
    // Pattern recognizers
    // pattern_lfive U_pattern_lfive(my_next, s_lfive);
    // pattern_lfour U_pattern_lfour(my_next, op, s_lfour);
    // pattern_sfour U_pattern_sfour(my_next, op, s_sfour);
    // pattern_lthree U_pattern_lthree(my_next, op, s_lthree);
    // pattern_sthree U_pattern_sthree(my_next, op, s_sthree);
    // pattern_ltwo U_pattern_ltwo(my_next, op, s_ltwo);
    // pattern_stwo U_pattern_stwo(my_next, op, s_stwo);
    // pattern_lone U_pattern_lone(my_next, op, s_lone);
    // 
    
    pat_five U_pat_five(my_next, s_lfive);
    pat_four U_pat_four(my_next, op_next, s_lfour);
    pat_three U_pat_three(my_next, op_next, s_lthree);
    pat_sfour U_pat_sfour(my_next, op_next, s_sfour);
    pat_two U_pat_two(my_next, op_next, s_ltwo);
    pat_one U_pat_one(my_next, op_next, s_lone);
    
    always @ (*)
        if (chess_nempty)
            // Invalid pattern
            score = 0;
        else if (s_lfive)
            score = live_Five;
        else if (s_lfour)
            score = live_Four;
        else if (s_sfour)
            score = sleep_Four;
        else if (s_lthree)
            score = live_Three;
        else if (s_ltwo)
            score = live_Two;
        else if (s_lone) 
            score = live_One;
        else
            score = un_known;
    
endmodule
