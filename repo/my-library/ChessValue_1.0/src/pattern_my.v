`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// + = empty | o = my chess
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Recognize 1活五 ***** 50000 ok
//------------------------------------------------------------------------------
module pat_five(
    input wire [8:0] my,
    output reg ret
    );
    
    always @ (*)
        if ((my[0] && my[1] && my[2] && my[3] && my[4]) ||
            (my[1] && my[2] && my[3] && my[4] && my[5]) ||
            (my[2] && my[3] && my[4] && my[5] && my[6]) ||
            (my[3] && my[4] && my[5] && my[6] && my[7]) ||
            (my[4] && my[5] && my[6] && my[7] && my[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 2活四 _****_ 4320 ok
//------------------------------------------------------------------------------
module pat_four(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && my[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (empty[1] && my[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && my[5] && my[6] && my[7] && empty[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 活三 3 _***__ | 4 __***_ | 5 _**_*_ | 6 _*_**_ 720 ok
//------------------------------------------------------------------------------
module pat_three(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && empty[1] && my[2] && my[3] && my[4] && empty[5]) ||    /* __***_ */
            (empty[1] && empty[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (empty[2] && empty[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (empty[3] && empty[4] && my[5] && my[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && my[2] && my[3] && empty[4] && empty[5]) ||    /* _***__ */
            (empty[1] && my[2] && my[3] && my[4] && empty[5] && empty[6]) ||
            (empty[2] && my[3] && my[4] && my[5] && empty[6] && empty[7]) ||
            (empty[3] && my[4] && my[5] && my[6] && empty[7] && empty[8]) ||

            (empty[0] && my[1] && my[2] && empty[3] && my[4] && empty[5]) ||    /* _**_*_ */
            (empty[1] && my[2] && my[3] && empty[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && my[4] && empty[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && my[5] && empty[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && empty[2] && my[3] && my[4] && empty[5]) ||    /* _*_**_ */
            (empty[1] && my[2] && empty[3] && my[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && empty[4] && my[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && empty[5] && my[6] && my[7] && empty[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule


//------------------------------------------------------------------------------
// Recognize 冲四 7 ****_ | 8 _**** | 10 *_*** | 11 ***_* | 9 **_** 720 ok
//------------------------------------------------------------------------------
module pat_sfour(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((my[0] && my[1] && my[2] && my[3] && empty[4]) ||  /* ****_ */
            (my[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (my[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (my[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (my[4] && my[5] && my[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && my[2] && my[3] && my[4]) ||  /* _**** */
            (empty[1] && my[2] && my[3] && my[4] && my[5]) ||
            (empty[2] && my[3] && my[4] && my[5] && my[6]) ||
            (empty[3] && my[4] && my[5] && my[6] && my[7]) ||
            (empty[4] && my[5] && my[6] && my[7] && my[8]) ||

            (my[0] && empty[1] && my[2] && my[3] && my[4]) ||           /* *_*** */
            (my[1] && empty[2] && my[3] && my[4] && my[5]) ||
            (my[2] && empty[3] && my[4] && my[5] && my[6]) ||
            (my[3] && empty[4] && my[5] && my[6] && my[7]) ||
            (my[4] && empty[5] && my[6] && my[7] && my[8]) ||

            (my[0] && my[1] && my[2] && empty[3] && my[4]) ||           /* ***_* */
            (my[1] && my[2] && my[3] && empty[4] && my[5]) ||
            (my[2] && my[3] && my[4] && empty[5] && my[6]) ||
            (my[3] && my[4] && my[5] && empty[6] && my[7]) ||
            (my[4] && my[5] && my[6] && empty[7] && my[8]) ||

            (my[0] && my[1] && empty[2] && my[3] && my[4]) ||           /* **_** */
            (my[1] && my[2] && empty[3] && my[4] && my[5]) ||
            (my[2] && my[3] && empty[4] && my[5] && my[6]) ||
            (my[3] && my[4] && empty[5] && my[6] && my[7]) ||
            (my[4] && my[5] && empty[6] && my[7] && my[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 活二 12 __**__ | 13 __*_*_ | 14 _*_*__ 120 ok
//------------------------------------------------------------------------------
module pat_two(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && empty[1] && my[2] && my[3] && empty[4] && empty[5]) || /* __*_*_ */
            (empty[1] && empty[2] && my[3] && my[4] && empty[5] && empty[6]) ||
            (empty[2] && empty[3] && my[4] && my[5] && empty[6] && empty[7]) ||
            (empty[3] && empty[4] && my[5] && my[6] && empty[7] && empty[8]) ||

            (empty[0] && empty[1] && my[2] && empty[3] && my[4] && empty[5]) || /* __**__ */
            (empty[1] && empty[2] && my[3] && empty[4] && my[5] && empty[6]) ||
            (empty[2] && empty[3] && my[4] && empty[5] && my[6] && empty[7]) ||
            (empty[3] && empty[4] && my[5] && empty[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && empty[2] && my[3] && empty[4] && empty[5]) ||   /* _*_*__ */
            (empty[1] && my[2] && empty[3] && my[4] && empty[5] && empty[6]) ||
            (empty[2] && my[3] && empty[4] && my[5] && empty[6] && empty[7]) ||
            (empty[3] && my[4] && empty[5] && my[6] && empty[7] && empty[8])
            )
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 活一 15 ___*__ | 16 __*___  20 ok
//------------------------------------------------------------------------------
module pat_one(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && empty[1] && empty[2] && my[3] && empty[4] && empty[5]) || /* ___*__ */
            (empty[1] && empty[2] && empty[3] && my[4] && empty[5] && empty[6]) ||
            (empty[2] && empty[3] && empty[4] && my[5] && empty[6] && empty[7]) ||
            (empty[3] && empty[4] && empty[5] && my[6] && empty[7] && empty[8]) ||

            (empty[0] && empty[1] && my[2] && empty[3] && empty[4] && empty[5]) || /* __*___ */
            (empty[1] && empty[2] && my[3] && empty[4] && empty[5] && empty[6]) ||
            (empty[2] && empty[3] && my[4] && empty[5] && empty[6] && empty[7]) ||
            (empty[3] && empty[4] && my[5] && empty[6] && empty[7] && empty[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule