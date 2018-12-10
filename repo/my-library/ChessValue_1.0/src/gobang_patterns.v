`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// _ = empty | * = my chess | o = opponent's chess
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Recognize 活五 ***** 50000 ok
//------------------------------------------------------------------------------
module pattern_lfive(
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
// Recognize 活四 _****_ 4320 ok
//------------------------------------------------------------------------------
module pattern_lfour(
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
// Recognize 冲四 o****_ | _****o | *_*** | ***_* | **_** 720 ok
//------------------------------------------------------------------------------
module pattern_sfour(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && my[1] && my[2] && my[3] && my[4] && empty[5]) ||  /* o****_ */
            (op[1] && my[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (op[2] && my[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (op[3] && my[4] && my[5] && my[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && my[2] && my[3] && my[4] && op[5]) ||  /* _****o */
            (empty[1] && my[2] && my[3] && my[4] && my[5] && op[6]) ||
            (empty[2] && my[3] && my[4] && my[5] && my[6] && op[7]) ||
            (empty[3] && my[4] && my[5] && my[6] && my[7] && op[8]) ||

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
// Recognize 活三 __***_ | __***_ | _**_*_ | _*_**_ 720 ok
//------------------------------------------------------------------------------
module pattern_lthree(
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
// Recognize 眠三 o_***__ | __***_o | o**_*_ | _*_**o | o*_**_ | _**_*o | ok
//               **__* | *__** | *_*_* | _***_
//------------------------------------------------------------------------------
module pattern_sthree(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && empty[1] && my[2] && my[3] && my[4]) && empty[5] && empty[6] ||   /* o_***__ */
            (op[1] && empty[2] && my[3] && my[4] && my[5]) && empty[6] && empty[7] ||
            (op[2] && empty[3] && my[4] && my[5] && my[6]) && empty[7] && empty[8] ||

            (empty[0] && empty[1] && my[2] && my[3] && my[4] && empty[5] && op[6]) ||   /* __***_o */
            (empty[1] && empty[2] && my[3] && my[4] && my[5] && empty[6] && op[7]) ||
            (empty[2] && empty[3] && my[4] && my[5] && my[6] && empty[7] && op[8]) ||

            (op[0] && my[1] && my[2] && empty[3] && my[4] && empty[5]) ||   /* o**_*_ */
            (op[1] && my[2] && my[3] && empty[4] && my[5] && empty[6]) ||
            (op[2] && my[3] && my[4] && empty[5] && my[6] && empty[7]) ||
            (op[3] && my[4] && my[5] && empty[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && empty[2] && my[3] && my[4] && op[5]) ||   /* _*_**o */
            (empty[1] && my[2] && empty[3] && my[4] && my[5] && op[6]) ||
            (empty[2] && my[3] && empty[4] && my[5] && my[6] && op[7]) ||
            (empty[3] && my[4] && empty[5] && my[6] && my[7] && op[8]) ||

            (op[0] && my[1] && empty[2] && my[3] && my[4] && empty[5]) ||   /* o*_**_ */
            (op[1] && my[2] && empty[3] && my[4] && my[5] && empty[6]) ||
            (op[2] && my[3] && empty[4] && my[5] && my[6] && empty[7]) ||
            (op[3] && my[4] && empty[5] && my[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && my[2] && empty[3] && my[4] && op[5]) ||   /* _**_*o */
            (empty[1] && my[2] && my[3] && empty[4] && my[5] && op[6]) ||
            (empty[2] && my[3] && my[4] && empty[5] && my[6] && op[7]) ||
            (empty[3] && my[4] && my[5] && empty[6] && my[7] && op[8]) ||

            (my[0] && my[1] && empty[2] && empty[3] && my[4]) ||           /* **__* */
            (my[1] && my[2] && empty[3] && empty[4] && my[5]) ||
            (my[2] && my[3] && empty[4] && empty[5] && my[6]) ||
            (my[3] && my[4] && empty[5] && empty[6] && my[7]) ||
            (my[4] && my[5] && empty[6] && empty[7] && my[8]) ||

            (my[0] && empty[1] && empty[2] && my[3] && my[4]) ||           /* *__** */
            (my[1] && empty[2] && empty[3] && my[4] && my[5]) ||
            (my[2] && empty[3] && empty[4] && my[5] && my[6]) ||
            (my[3] && empty[4] && empty[5] && my[6] && my[7]) ||
            (my[4] && empty[5] && empty[6] && my[7] && my[8]) ||

            (my[0] && empty[1] && my[2] && empty[3] && my[4]) ||           /* *_*_* */
            (my[1] && empty[2] && my[3] && empty[4] && my[5]) ||
            (my[2] && empty[3] && my[4] && empty[5] && my[6]) ||
            (my[3] && empty[4] && my[5] && empty[6] && my[7]) ||
            (my[4] && empty[5] && my[6] && empty[7] && my[8]) ||

            (empty[0] && my[1] && my[2] && my[3] && empty[4]) ||           /* _***_ */
            (empty[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (empty[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (empty[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (empty[4] && my[5] && my[6] && my[7] && empty[8])
            )
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 活二 __**__ | _*_*_ | _*__*_
//------------------------------------------------------------------------------
module pattern_ltwo(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && empty[1] && my[2] && my[3] && empty[4] && empty[5]) || /* __**__ */
            (empty[1] && empty[2] && my[3] && my[4] && empty[5] && empty[6]) ||
            (empty[2] && empty[3] && my[4] && my[5] && empty[6] && empty[7]) ||
            (empty[3] && empty[4] && my[5] && my[6] && empty[7] && empty[8]) ||

            (empty[0] && my[1] && empty[2] && my[3] && empty[4]) ||             /* _*_*_ */
            (empty[1] && my[2] && empty[3] && my[4] && empty[5]) ||
            (empty[2] && my[3] && empty[4] && my[5] && empty[6]) ||
            (empty[3] && my[4] && empty[5] && my[6] && empty[7]) ||
            (empty[4] && my[5] && empty[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && empty[2] && empty[3] && my[4] && empty[5]) ||   /* _*__*_ */
            (empty[1] && my[2] && empty[3] && empty[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && empty[4] && empty[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && empty[5] && empty[6] && my[7] && empty[8])
            )
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 眠二 o**___ | ___**o | o*_*__ | __*_*o | o*__*_ | _*__*o | *___*
//------------------------------------------------------------------------------
module pattern_stwo(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && my[1] && my[2] && empty[3] && empty[4] && empty[5]) || /* o**___ */
            (op[1] && my[2] && my[3] && empty[4] && empty[5] && empty[6]) ||
            (op[2] && my[3] && my[4] && empty[5] && empty[6] && empty[7]) ||
            (op[3] && my[4] && my[5] && empty[6] && empty[7] && empty[8]) ||

            (empty[0] && empty[1] && empty[2] && my[3] && my[4] && op[5]) || /* ___**o */
            (empty[1] && empty[2] && empty[3] && my[4] && my[5] && op[6]) ||
            (empty[2] && empty[3] && empty[4] && my[5] && my[6] && op[7]) ||
            (empty[3] && empty[4] && empty[5] && my[6] && my[7] && op[8]) ||

            (op[0] && my[1] && empty[2] && my[3] && empty[4] && empty[5]) || /* o*_*__ */
            (op[1] && my[2] && empty[3] && my[4] && empty[5] && empty[6]) ||
            (op[2] && my[3] && empty[4] && my[5] && empty[6] && empty[7]) ||
            (op[3] && my[4] && empty[5] && my[6] && empty[7] && empty[8]) ||

            (empty[0] && empty[1] && my[2] && empty[3] && my[4] && op[5]) || /* __*_*o */
            (empty[1] && empty[2] && my[3] && empty[4] && my[5] && op[6]) ||
            (empty[2] && empty[3] && my[4] && empty[5] && my[6] && op[7]) ||
            (empty[3] && empty[4] && my[5] && empty[6] && my[7] && op[8]) ||

            (op[0] && my[1] && empty[2] && empty[3] && my[4] && empty[5]) || /* o*__*_ */
            (op[1] && my[2] && empty[3] && empty[4] && my[5] && empty[6]) ||
            (op[2] && my[3] && empty[4] && empty[5] && my[6] && empty[7]) ||
            (op[3] && my[4] && empty[5] && empty[6] && my[7] && empty[8]) ||

            (empty[0] && my[1] && empty[2] && empty[3] && my[4] && op[5]) || /* _*__*o */
            (empty[1] && my[2] && empty[3] && empty[4] && my[5] && op[6]) ||
            (empty[2] && my[3] && empty[4] && empty[5] && my[6] && op[7]) ||
            (empty[3] && my[4] && empty[5] && empty[6] && my[7] && op[8]) ||

            (my[0] && empty[1] && empty[2] && empty[3] && my[4]) ||             /* *___* */
            (my[1] && empty[2] && empty[3] && empty[4] && my[5]) ||
            (my[2] && empty[3] && empty[4] && empty[5] && my[6]) ||
            (my[3] && empty[4] && empty[5] && empty[6] && my[7]) ||
            (my[4] && empty[5] && empty[6] && empty[7] && my[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize 活一 ___*__ | __*___ 
//------------------------------------------------------------------------------
module pattern_lone(
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
