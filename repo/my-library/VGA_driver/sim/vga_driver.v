`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/02/08 21:21:56
// Design Name: 
// Module Name: vga_driver
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


module vga_driver(
	input clk_25M,
	input rst_p,
	output hsync,
	output vsync,
	output [11:0] pixel_x,
	output [11:0] pixel_y,
	output video_on
    );

	//定义常数
	//VGA 640 * 480 同步参数
	localparam HD = 640;	//水平显示区域
	localparam HF = 48;		//水平扫描左边界
	localparam HB = 16;		//水平扫描右边界
	localparam HR = 96;		//水平折回区
	localparam VD = 480;	//垂直显示区域
	localparam VF = 10;		//垂直扫描顶部边界
	localparam VB = 33;		//垂直扫描底部边界
	localparam VR = 2;		//垂直折回区

	//同步计数器
	reg [9:0] h_count_reg,h_count_next;
	reg [9:0] v_count_reg,v_count_next;
	//输出缓冲器
	reg v_sync_reg,h_sync_reg;
	wire v_sync_next,h_sync_next;
	//状态信号
	wire h_end,v_end;

	//寄存器部分
	always @(posedge clk_25M or posedge rst_p) begin
		if (rst_p) begin
			// rst_p
			v_count_reg <= 0;
			h_count_reg <= 0;
			v_sync_reg <= 1'b0;
			h_sync_reg <= 1'b0;
		end
		else begin
			v_count_reg <= v_count_next;
			h_count_reg <= h_count_next;
			v_sync_reg <= v_sync_next;
			h_sync_reg <= h_sync_next;
		end
	end

	//状态信号
	//水平扫描结束信号（799）
	assign h_end = (h_count_reg==(HD+HF+HB+HR-1));
	//垂直扫描计数器结束信号
	assign v_end = (v_count_reg==(VD+VF+VB+VR-1));

	//水平同步扫描模800计数器下一状态
	always @(*) begin
		if (h_end) begin
			h_count_next = 0;
		end else begin
			h_count_next = h_count_reg + 1;
		end
	end

	//垂直同步扫描模525计数器新下一状态
	always @(*) begin
		if (h_end) begin
			if (v_end) begin
				v_count_next = 0;
			end else begin
				v_count_next = v_count_reg + 1;
			end
		end else begin
			v_count_next = v_count_reg;
		end
	end
	
	//同步缓冲器
	//h_sync_next 信号在计数器数值为656和751时赋值
	assign h_sync_next = (h_count_reg >= (HD+HB)&&h_count_reg <= (HD+HB+HR-1))?1'b0:1'b1;
	//v_sync_next 信号在计数器数值为490和491时赋值
	assign v_sync_next = (v_count_reg >= (VD+VB)&&v_count_reg <= (VD+VB+VR-1))?1'b0:1'b1;

	//产生video_on 信号
	assign video_on = (h_count_reg < HD) && (v_count_reg < VD);

	//输出
	assign hsync = h_sync_reg;
	assign vsync = v_sync_reg;
	assign pixel_x = h_count_reg;
	assign pixel_y = v_count_reg;

endmodule
