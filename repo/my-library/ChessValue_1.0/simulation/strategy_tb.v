`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/13 21:36:42
// Design Name: 
// Module Name: strategy_tb
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


module strategy_tb();
	
	reg clk;
	reg rst;
	reg clr;
	reg active;
	reg random;
    reg [8:0] black_i;              // Row information
    reg [8:0] black_j;              // Column information
    reg [8:0] black_ij;             // Main diagonal information
    reg [8:0] black_ji;             // Counter diagonal information
    reg [8:0] white_i;
    reg [8:0] white_j;
    reg [8:0] white_ij;
    reg [8:0] white_ji;

    wire [3:0] get_i;                // Current row considered
    wire [3:0] get_j;                // Current column considered
    wire [12:0] black_best_score;    // Best possible score
    wire [3:0] black_best_i;         // Best row
    wire [3:0] black_best_j;         // Best column
    wire [12:0] white_best_score;
    wire [3:0] white_best_i;
    wire [3:0] white_best_j;
    wire data_valued;

    localparam T = 10;

    gobang_strategy tb_strategy(
            .clk(clk),
            .rst(rst),
            .clr(clr),
            .active(active),
            .random(random),
            .black_i(black_i),
            .black_j(black_j),
            .black_ij(black_ij),
            .black_ji(black_ji),
            .white_i(white_i),
            .white_j(white_j),
            .white_ij(white_ij),
            .white_ji(white_ji),
            .get_i(get_i),
            .get_j(get_j),
            .black_best_score(black_best_score),
            .black_best_i(black_best_i),
            .black_best_j(black_best_j),
            .white_best_score(white_best_score),
            .white_best_i(white_best_i),
            .white_best_j(white_best_j),
            .data_valued(data_valued)
        );

    always begin
    	#(T/2) clk = !clk;
    end

    initial begin
    	clk = 1'b0;
    	rst = 1'b1;
    	active = 1'b0;
    	random = 1'b1;
    	clr = 1'b0;

    	#(2*T) rst = 1'b0;
    	#(2*T) rst = 1'b1;

    	#(4*T) active = 1'b1;
    	#(2*T) active = 1'b0;

    	#(800*T) clr = 1'b1;
    	#(2*T) clr = 1'b0;
    	
    	#(4*T) active = 1'b1;
    	#(2*T) active = 1'b0;
    end

    initial begin
	    black_i = 9'b0;              // Row information
	    black_j = 9'b0;              // Column information
	    black_ij = 9'b0;             // Main diagonal information
	    black_ji = 9'b0;             // Counter diagonal information
	    white_i = 9'b0;
	    white_j = 9'b0;
	    white_ij = 9'b0;
	    white_ji = 9'b0;
    end

endmodule
