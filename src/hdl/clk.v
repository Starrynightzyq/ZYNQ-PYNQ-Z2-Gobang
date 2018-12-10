`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: clk
//////////////////////////////////////////////////////////////////////////////////


module clk #(parameter DVSR = 651) (
    input wire clk,reset,
    output reg tick
    );
    
    reg [31:0]count;
    
    always@(posedge clk,posedge reset)
    if(reset)begin
        tick <= 0;
        count <= 0;
    end
    else if(count < DVSR)begin
            tick <= 0;
            count <= count + 1'b1;
        end
    else begin
            tick <= 1;
            count <= 0;
    end
    
endmodule
