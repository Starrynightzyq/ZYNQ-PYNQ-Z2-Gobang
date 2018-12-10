`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Module Name: uart_tx

//////////////////////////////////////////////////////////////////////////////////


module uart_tx #(parameter DATA_WIDTH = 8, SB_TICK = 16)(
    input wire clk,reset,s_tick,tx_start,
    input wire [DATA_WIDTH-1:0]din,
    output reg tx,
    output reg tx_done
    );
    
    localparam [1:0]
        idle = 2'b00,
        start = 2'b01,
        data = 2'b10,
        stop = 2'b11;
        
    reg [1:0]state,state_next;
    reg [DATA_WIDTH-1:0]data_reg,data_next;
    reg tx_next,tx_done_next;
    reg [3:0]s,s_next;
    reg [3:0]n,n_next;   //the max number of bits is 16
    
    always@(posedge clk,posedge reset)
    if(reset)begin
        state <= idle;
        tx <= 1;
        s <= 0;
        n <= 0;
        tx_done <= 0;
        data_reg <= 0;
    end
    else begin
        state <= state_next;
        tx <= tx_next;
        s <= s_next;
        n <= n_next;
        tx_done <= tx_done_next;
        data_reg <= data_next;
    end
        
    always@(state or s_tick or tx_start)begin
        state_next = state;
        tx_next = tx;
        s_next = s;
        n_next = n;
        tx_done_next = tx_done;
        data_next = data_reg;
        case(state)
            idle:begin
                if(tx_start)begin
                    data_next= din;
                    s_next = 0;
                    state_next = start;  
                    tx_done_next = 0;                  
                end
                else
                    tx_next = 1;
            end
            
            start:begin
                tx_next = 0;
                if(s_tick)
                    if(s == 4'd15)begin
                        state_next = data;
                        s_next = 0;
                        n_next = 0;
                    end
                    else
                        s_next = s + 1'b1;
            end
            
            data:begin
                tx_next = data_reg[0];
                if(s_tick)
                    if(s == 4'd15)begin
                        data_next = data_reg >>1;
                        s_next = 0;
                        if(n == DATA_WIDTH-1)begin
                            state_next = stop;
                            n_next = 0;
                        end
                        else
                            n_next = n + 1'b1;                      
                    end
                    else
                        s_next = s + 1'b1;
            end
            
            stop:begin
                tx_next = 1'b1; 
                if(s_tick)
                    if(s == SB_TICK-1)begin                        
                        tx_done_next = 1'b1;
                        state_next = idle;
                    end
                    else
                        s_next = s + 1'b1;
            end
            
        endcase
    end
        
    
endmodule
