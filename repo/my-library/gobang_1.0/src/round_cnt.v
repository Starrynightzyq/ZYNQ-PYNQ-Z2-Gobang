`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/05 20:44:37
// Design Name: 
// Module Name: round_cnt
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


//统计回合数
module round_cnt(
	input wire clk,                    //25MHz
	input wire rst_p,			       //reset 高电平有效

	input wire write,                  //落子
	input wire write_color,            //棋子颜色 0：黑 1：白
	input wire retract,                //悔棋
	input wire clr,                    //清空棋盘

	output reg[3:0] round_cnt_unit,         //回合数个位
	output reg[3:0] round_cnt_tens,         //回合数十位
	output reg[3:0] round_cnt_hund          //回合数百位
    );

wire wrt_flag;
wire rtc_flag;
reg wrt_reg;
reg rtc_reg;
always @(posedge clk or posedge rst_p) begin
	if (rst_p) begin
		wrt_reg <= 1'b0;
		rtc_reg <= 1'b0;
	end else begin
		wrt_reg <= write;
		rtc_reg <= retract;
	end
end
assign wrt_flag = (wrt_reg==0) && (write==1);
assign rtc_flag = (rtc_reg==0) && (retract==1);

always @(posedge clk or posedge rst_p) begin
	if (rst_p) begin
		// reset
		round_cnt_unit[3:0] <= 4'b0;
		round_cnt_tens[3:0] <= 4'b0;
		round_cnt_hund[3:0] <= 4'b0;
	end else if (clr) begin
		round_cnt_unit[3:0] <= 4'b0;
		round_cnt_tens[3:0] <= 4'b0;
		round_cnt_hund[3:0] <= 4'b0;
	end else if ((write_color == 0) && (wrt_flag == 1)) begin          //落黑子 回合数+1
		if (round_cnt_unit < 9)begin
			round_cnt_unit <= round_cnt_unit + 1'b1;
			round_cnt_tens <= round_cnt_tens;
			round_cnt_hund <= round_cnt_hund;
		end else if (round_cnt_tens < 9) begin
			round_cnt_unit <= 4'b0;
			round_cnt_tens <= round_cnt_tens + 1'b1;
			round_cnt_hund <= round_cnt_hund;
		end else begin
			round_cnt_unit <= 4'b0;
			round_cnt_tens <= 4'b0;
			round_cnt_hund <= round_cnt_hund + 1'b1;
		end
	end else if ((write_color == 0) &&rtc_flag == 1) begin                               //悔棋 回合数-1
		if (round_cnt_unit > 0) begin
			round_cnt_unit <= round_cnt_unit - 1'b1;
			round_cnt_tens <= round_cnt_tens;
			round_cnt_hund <= round_cnt_hund;
		end else if (round_cnt_tens > 0) begin
			round_cnt_unit <= 4'b1001;
			round_cnt_tens <= round_cnt_tens - 1'b1;
			round_cnt_hund <= round_cnt_hund;
		end else begin
			round_cnt_unit <= 4'b1001;
			round_cnt_tens <= 4'b1001;
			round_cnt_hund <= round_cnt_hund - 1'b1;
		end
	end else begin                                                  //保持不变
		round_cnt_unit <= round_cnt_unit;
		round_cnt_tens <= round_cnt_tens;
		round_cnt_hund <= round_cnt_hund;
	end
end

endmodule
