`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// _ = empty | * = my chess | o = opponent's chess
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Recognize 活五 ***** 50000 ok
//------------------------------------------------------------------------------
module five_checker(
    input wire [8:0] my,
    output reg [3:0] coord,
    output reg ret
    );

    always @(*) begin
        if (my[0] && my[1] && my[2] && my[3] && my[4]) begin
            ret = 1'b1;
            coord = 4'd2;
        end else if (my[1] && my[2] && my[3] && my[4] && my[5]) begin
            ret = 1'b1;
            coord = 4'd3;
        end else if (my[2] && my[3] && my[4] && my[5] && my[6]) begin
            ret = 1'b1;
            coord = 4'd4;
        end else if (my[3] && my[4] && my[5] && my[6] && my[7]) begin
            ret = 1'b1;
            coord = 4'd5;
        end else if (my[4] && my[5] && my[6] && my[7] && my[8]) begin
            ret = 1'b1;
            coord = 4'd6;
        end else begin
            ret = 1'b0;
            coord = 4'd0;
        end
    end

endmodule