`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/20 10:26:25
// Design Name: 
// Module Name: decoder
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


module decoder(
	input clk,
	input rx_done,
	input [7:0]data_in,
	input rst,
	output reg[7:0] x,
	output reg[7:0] y,
	output reg[7:0] btn,
	output reg valid
    );
	
	localparam  IDLE = 4'd0,
				Head1= 4'd1,
				Head2=4'd2,
				Head3=4'd3,
				GetBtn=4'd4,
				GetX=4'd5,
				GetY=4'd6,
				Check=4'd7,
				Get=4'd8,
				Clean = 4'd9,
				SendOut = 4'd10;

	reg [3:0] state,nextstate;
	reg [1:0]rx_done_reg;
	reg [7:0]SUM;
	reg [7:0]x_temp;
	reg [7:0]y_temp;
	reg [7:0]btn_temp;
	reg clr;
	wire rx_flag;
	reg save;
	reg save_x,save_y,save_btn;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			SUM <= 8'd0;
		end
		else if (clr) begin
			SUM <= 8'd0;
		end
		else if(rx_flag)begin
			SUM <= SUM + data_in;
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			x_temp <= 8'd0;
			y_temp <= 8'd0;
			btn_temp <= 8'd0;
		end
		else begin
			if(save_x)
				x_temp <= data_in;
			if(save_y)
				y_temp <= data_in;
			if(save_btn)
				btn_temp <= data_in;
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			x <= 8'd0;
			y <= 8'd0;
			btn <= 8'd0;
		end
		else if (save) begin
			x <= x_temp;
			y <= y_temp;
			btn <= btn_temp;
		end
	end

	assign rx_flag = rx_done_reg == 2'b01;
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
			state <= Clean;
			rx_done_reg <= 2'b00;
		end
		else begin
			state <= nextstate;
			rx_done_reg <= {rx_done_reg[0],rx_done};
		end
	end

	always @(*)begin
		nextstate = state;
		save = 0;save_btn = 0;save_y = 0;save_x = 0;clr = 0;valid = 0;
		case(state)
		IDLE:begin
			if(rx_flag) begin
				if(data_in == 8'haa) begin
					nextstate = Head1;
				end
			end
		end
		Head1:begin
			if(rx_flag) begin
				if(data_in == 8'haa) begin
					nextstate = Head2;
				end
				else begin
					nextstate = Clean;
				end
			end
		end
		Head2:begin
			if(rx_flag) begin
				if(data_in == 8'h07) begin
					nextstate = Head3;
				end
				else begin
					nextstate = Clean;
				end
			end
		end
		Head3:begin
			if(rx_flag) begin
				if(data_in == 8'h03) begin
					nextstate = GetBtn;
				end
				else begin
					nextstate = Clean;
				end
			end
		end
		GetBtn:begin
			save_btn = 1;
			if(rx_flag) begin
				nextstate = GetX;
			end
		end
		GetX:begin
			save_x = 1;
			if(rx_flag) begin
				nextstate = GetY;
			end
		end
		GetY:begin
			save_y = 1;
			if(rx_flag) begin
				nextstate = Check;
			end
		end
		Check:begin
			if(rx_flag) begin
				if(SUM == data_in)
					nextstate = Get;
				else begin
					nextstate = Clean;
				end
			end
		end
		Clean:begin
			clr = 1;
			nextstate = IDLE;
		end
		Get:begin
			clr = 1;
			save = 1;
			nextstate = SendOut;
		end
		SendOut:begin
			valid = 1;
			nextstate = IDLE;
		end
		default:begin
			nextstate = Clean;
		end
		endcase
	end

endmodule
