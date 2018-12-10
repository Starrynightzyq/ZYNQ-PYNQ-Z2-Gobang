`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module dual_port_ram_sync
  #(
     parameter ADDR_WIDTH=19,
     parameter DATA_WIDTH=3
   )
   (
     input wire clk,reset_ram,
     input wire we,
     input wire [ADDR_WIDTH-1:0] addr_a,addr_b,
     input wire [DATA_WIDTH-1:0] din_a,
     output wire [DATA_WIDTH-1:0] dout_a,dout_b
    );
    
  //信号声明
  wire [ADDR_WIDTH-1:0]addr;
  wire [DATA_WIDTH-1:0]din_a_t;
   reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
   reg [ADDR_WIDTH-1:0] addr_a_reg,addr_b_reg;
   
  //主体部分
   always@(posedge clk)
   begin
        addr_a_reg<=addr_a;
        addr_b_reg<=addr_b;
        if(we||reset_ram) //写操作
        ram[addr]<=din_a_t;
   end
    
    assign addr=reset_ram?addr_b:addr_a;
    assign din_a_t=reset_ram?3'b111:din_a;
   //两次读操作
    assign dout_a=ram[addr_a_reg];
    assign dout_b=ram[addr_b_reg];
   
endmodule
