`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(
 input clk,reset,
 output hsync,
        vsync,
        video_on,
        p_tick,   //??那?∩??赤㏒“?米赤3?米?那㏒?
  output wire [9:0] pixel_x,pixel_y     // ℅?㊣那
    );
    
  //3㏒那y?“辰?
  //VGA640*480赤?2?2?那y
   localparam HD=640;  //??????那???車辰
   localparam HF=48;   //????谷“?豕℅車㊣???
   localparam HB=16;   //????谷“?豕車辰㊣???
   localparam HR=96;   //??????????
   //------------------------------
   localparam VD=480;  //∩1?㊣??那???車辰
   localparam VF=10;   //∩1?㊣谷“?豕?ㄓ2?㊣???
   localparam VB=33;   //∩1?㊣谷“?豕米℅2?㊣???
   localparam VR=2;    //∩1?㊣??????
   
   //?㏒4??那y?¯
   reg [1:0]mod4_reg;
   wire [1:0]mod4_next; 
   //赤?2???那y?¯
   reg [9:0] h_count_reg;
   wire [9:0] h_count_next;
   reg [9:0] v_count_reg;
   wire [9:0] v_count_next;
   //那?3??o3??¯
   reg v_sync_reg,h_sync_reg;
   wire v_sync_next,h_sync_next;
   //℅∩足?D?o?
   wire h_end,v_end;
   
  always@(posedge clk,posedge reset)
   if(reset)
    begin
     mod4_reg<=0;
     h_count_reg<=0;
     v_count_reg<=0;
     v_sync_reg<=0;
     h_sync_reg<=0;
    end
   else
    begin
     mod4_reg<=mod4_next;
     h_count_reg<=h_count_next;
     v_count_reg<=v_count_next;
     v_sync_reg<=v_sync_next;
     h_sync_reg<=h_sync_next;
    end
    
   //?㏒4??那y?¯2迆谷迆25MHz那㊣?車那1?邦D?o?
   assign mod4_next=(mod4_reg==1)?0:mod4_reg+1;
   //?辰??assign mod4_next=mod4_reg+1;
   assign p_tick=(mod4_reg==0)?1:0;
   
   //℅∩足?D?o?
   //????谷“?豕??那y?¯?芍那?D?o?㏒“799㏒?
   assign h_end=(h_count_reg==(HD+HF+HB+HR-1));
   //∩1?㊣谷“?豕??那y?¯?芍那?D?o?㏒“524㏒?
   assign v_end=(v_count_reg==(VD+VF+VB+VR-1));
   
   //????赤?2?谷“?豕?㏒800??那y?¯??辰????-℅∩足?
  // always@*
  //  if(p_tick)        //25MHZ??3?
   //  begin
   //   if(h_end)
   //      h_count_next=0;
   //   else
   //      h_count_next=h_count_reg+1;
   //   end
   //  else
   //     h_count_next=h_count_reg;
   assign h_count_next=(p_tick)?((h_end)?0:h_count_reg+1):h_count_reg;
        
    //∩1?㊣赤?2?谷“?豕?㏒525??那y?¯??辰????-℅∩足?
   // always@*
   //  if(p_tick&&h_end)       
   //   begin
    //   if(v_end)
    //      v_count_next=0;
    //   else
    //      v_count_next=v_count_reg+1;
    //   end
   //   else
    //     v_count_next=v_count_reg;
   assign v_count_next=(p_tick&&h_end)?((v_end)?0:v_count_reg+1):v_count_reg;
         
   //赤?2??o3??¯
   //h_sync_nextD?o??迆??那y?¯??那y?米?a656o赤751那㊣?3?米
   assign h_sync_next=(!(h_count_reg>=(HD+HB)&&h_count_reg<=(HD+HB+HR-1)));
   
   //v_sync_nextD?o??迆??那y?¯??那y?米?a490o赤491那㊣?3?米
   assign v_sync_next=(!(v_count_reg>=(VD+VF+31)&&v_count_reg<=(VD+VF+VR+31-1)));
   
   //2迆谷迆video_onD?o?
   assign video_on=(h_count_reg<HD)&&(v_count_reg<HD);
   
   //那?3?
   assign hsync=h_sync_reg;
   assign vsync=v_sync_reg;
   assign pixel_x=h_count_reg;
   assign pixel_y=v_count_reg;       
endmodule
