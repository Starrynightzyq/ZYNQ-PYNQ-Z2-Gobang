`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/02 17:27:51
// Design Name: 
// Module Name: hold
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


module hold
	#(
	parameter HOLD_TIME = 6'd60
	)
	(
	input wire clk,
	input wire rst_n,
	input wire trick_i,
	output reg trick_o
    );

    localparam IDLE = 1'b0;
    localparam HOLD = 1'b1;

    reg state_reg;
    reg state_next;

    reg [5:0] counter;
    reg count_done = 1'b0;

    wire rst_p;
    assign rst_p = !rst_n;

    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
    		// reset
    		state_reg <= IDLE;
    	end
    	else begin
    		state_reg <= state_next;
    	end
    end

    always @(*) begin
    	state_next = state_reg;
    	case(state_reg)
    		IDLE:begin
    			if (trick_i) begin
    				state_next = HOLD;
    			end else begin
    				state_next = state_reg;
    			end
    		end
    		HOLD:begin
    			if (count_done) begin
    				state_next = IDLE;
    			end else begin
    				state_next = state_reg;
    			end
    		end
    		default:begin
    			state_next = IDLE;
    		end
    	endcase
    end

    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
    		// reset
    		counter <= 6'b0;
    		count_done <= 1'b0;
    	end
    	else begin
    	case(state_reg)
    		IDLE:begin
    			counter <= 6'b0;
    			count_done <= 1'b0;
    		end
    		HOLD:begin
    			if (counter == HOLD_TIME) begin
    				counter <= 6'b0;
    				count_done <= 1'b1;
    			end else begin
    				counter <= counter + 6'b1;
    				count_done <= 1'b0;
    			end
    		end
    		default:begin
	    		counter <= 6'b0;
	    		count_done <= 1'b0;
    		end
    	endcase
    	end
    end

    always @(posedge clk or posedge rst_p) begin
    	if (rst_p) begin
    		// reset
    		trick_o <= 1'b0;
    	end
    	else if (state_reg == HOLD) begin
    		trick_o <= 1'b1;
    	end else begin
    		trick_o <= 1'b0;
    	end
    end

endmodule
