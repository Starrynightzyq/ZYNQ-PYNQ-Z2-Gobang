`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module sum_xy(input[7:0] x,y,btn,   //
              input clk,reset,
              valid,//
               output reg[9:0]x_sum_1_o,
                                x_sum_2_o,
                                x_sum_3_o,
                                x_sum_4_o,
                                x_sum_5_o,
                                y_sum_1_o,
                                y_sum_2_o,
                                y_sum_3_o,
                                y_sum_4_o,
                                y_sum_5_o,
              output reg ram_on,//
                         xie_on,//
                         color_on,
                         xiangpica_on
    );
       localparam x_max=640;  //
       localparam y_max=480;   //
       localparam x_start=320;  //起始坐标
       localparam y_start=240;  //起始坐标
       localparam fuzhu_8=128;

       reg [6:0]x_reg,y_reg;
       reg [9:0]x_sum_5_reg,x_sum_5_next,
                y_sum_5_reg,y_sum_5_next,
                x_sum_4_reg,x_sum_4_next,
                y_sum_4_reg,y_sum_4_next,
                x_sum_3_reg,x_sum_3_next,
                y_sum_3_reg,y_sum_3_next,
                x_sum_2_reg,x_sum_2_next,
                y_sum_2_reg,y_sum_2_next,
                x_sum_1_reg,x_sum_1_next,
                y_sum_1_reg,y_sum_1_next;

        wire[9:0]x_sum_1,
                x_sum_2,
                x_sum_3,
                x_sum_4,
                x_sum_5,
                y_sum_1,
                y_sum_2,
                y_sum_3,
                y_sum_4,
                y_sum_5;

       always@(posedge clk,posedge reset)
       begin
                 if(reset)     //
                   begin
                     x_sum_5_reg<=x_start;
                     y_sum_5_reg<=y_start;
                     x_sum_1_reg<=x_start;
                     y_sum_1_reg<=y_start;
                     x_sum_2_reg<=x_start;
                     y_sum_2_reg<=y_start;
                     x_sum_3_reg<=x_start;
                     y_sum_3_reg<=y_start;
                     x_sum_4_reg<=x_start;
                     y_sum_4_reg<=y_start;
                    end
                    else
                    begin
                    x_sum_5_reg<=x_sum_5;
                    y_sum_5_reg<=y_sum_5;
                    x_sum_4_reg<=x_sum_4;
                    y_sum_4_reg<=y_sum_4;
                    x_sum_3_reg<=x_sum_3;
                    y_sum_3_reg<=y_sum_3;
                    x_sum_2_reg<=x_sum_2;
                    y_sum_2_reg<=y_sum_2;
                    x_sum_1_reg<=x_sum_1;
                    y_sum_1_reg<=y_sum_1;
                    end
       end
        always@(posedge clk)
               if(valid)  //
                   begin  
                    if(x[7]==1)  //                
                         x_reg=fuzhu_8-x[6:0];  //
                     if(y[7]==1)                       
                         y_reg=fuzhu_8-y[6:0];//
                   end

assign x_sum_1=(valid)?((x[7]==1)?((x_sum_5_reg>x_reg)?x_sum_5_reg-x_reg[6:1]/5:0):((x_sum_5_reg+x[6:0])<(x_max-9))?x_sum_5_reg+x[6:1]/5:x_sum_1_reg):x_sum_1_reg;
assign y_sum_1=(valid)?((y[7]==1)?((y_sum_5_reg>y_reg)?y_sum_5_reg-y_reg[6:1]/5:0):((y_sum_5_reg+y[6:0])<(y_max-9))?y_sum_5_reg+y[6:1]/5:y_sum_1_reg):y_sum_1_reg;
assign x_sum_2=(valid)?((x[7]==1)?((x_sum_5_reg>x_reg)?x_sum_5_reg-x_reg[6:1]/5*2:0):((x_sum_5_reg+x[6:0])<(x_max-9))?x_sum_5_reg+x[6:1]/5*2:x_sum_2_reg):x_sum_2_reg;
assign y_sum_2=(valid)?((y[7]==1)?((y_sum_5_reg>y_reg)?y_sum_5_reg-y_reg[6:1]/5*2:0):((y_sum_5_reg+y[6:0])<(y_max-9))?y_sum_5_reg+y[6:1]/5*2:y_sum_2_reg):y_sum_2_reg;
assign x_sum_3=(valid)?((x[7]==1)?((x_sum_5_reg>x_reg)?x_sum_5_reg-x_reg[6:1]/5*3:0):((x_sum_5_reg+x[6:0])<(x_max-9))?x_sum_5_reg+x[6:1]/5*3:x_sum_3_reg):x_sum_3_reg;
assign y_sum_3=(valid)?((y[7]==1)?((y_sum_5_reg>y_reg)?y_sum_5_reg-y_reg[6:1]/5*3:0):((y_sum_5_reg+y[6:0])<(y_max-9))?y_sum_5_reg+y[6:1]/5*3:y_sum_3_reg):y_sum_3_reg;
assign x_sum_4=(valid)?((x[7]==1)?((x_sum_5_reg>x_reg)?x_sum_5_reg-x_reg[6:1]/5*4:0):((x_sum_5_reg+x[6:0])<(x_max-9))?x_sum_5_reg+x[6:1]/5*4:x_sum_4_reg):x_sum_4_reg;
assign y_sum_4=(valid)?((y[7]==1)?((y_sum_5_reg>y_reg)?y_sum_5_reg-y_reg[6:1]/5*4:0):((y_sum_5_reg+y[6:0])<(y_max-9))?y_sum_5_reg+y[6:1]/5*4:y_sum_4_reg):y_sum_4_reg;                   
assign x_sum_5=(valid)?((x[7]==1)?((x_sum_5_reg>x_reg)?x_sum_5_reg-x_reg[6:1]:0):((x_sum_5_reg+x[6:0])<(x_max-9))?x_sum_5_reg+x[6:1]:x_sum_5_reg):x_sum_5_reg;
assign y_sum_5=(valid)?((y[7]==1)?((y_sum_5_reg>y_reg)?y_sum_5_reg-y_reg[6:1]:0):((y_sum_5_reg+y[6:0])<(y_max-9))?y_sum_5_reg+y[6:1]:y_sum_5_reg):y_sum_5_reg;

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      x_sum_5_o<=x_sum_5;
      y_sum_5_o<=y_sum_5;
      x_sum_1_o<=x_sum_1;
      y_sum_1_o<=y_sum_1;
      x_sum_2_o<=x_sum_2;
      y_sum_2_o<=y_sum_2;
      x_sum_3_o<=x_sum_3;
      y_sum_3_o<=y_sum_3;
      x_sum_4_o<=x_sum_4;
      y_sum_4_o<=y_sum_4;
    end else begin
      x_sum_5_o<=x_sum_5;
      y_sum_5_o<=y_sum_5;
      x_sum_4_o<=x_sum_4;
      y_sum_4_o<=y_sum_4;
      x_sum_3_o<=x_sum_3;
      y_sum_3_o<=y_sum_3;
      x_sum_2_o<=x_sum_2;
      y_sum_2_o<=y_sum_2;
      x_sum_1_o<=x_sum_1;
      y_sum_1_o<=y_sum_1;
    end
  end

//       always@(posedge clk)
//         if(valid)  //
//             begin  
//              if(x[7]==1)  //
//                  begin
//                    x_reg=fuzhu_8-x[6:0];  //
//                    if(x_sum_5_reg>x_reg) //
//                        begin
//                        x_sum_1_next<=x_sum_5_reg-x_reg[6:1]*(3>>4); 
//                        x_sum_2_next<=x_sum_5_reg-x_reg[6:1]*(6>>4);
//                        x_sum_3_next<=x_sum_5_reg-x_reg[6:1]*(10>>4);
//                        x_sum_4_next<=x_sum_5_reg-x_reg[6:1]*(13>>4);
//                        x_sum_5_next<=x_sum_5_reg-x_reg[6:1];  
//                        end
//                    else
//                       x_sum_5_next=0; //           
//                 end            
//             else   //
//            begin                
//                     if((x_sum_5_reg+x[6:0])<(x_max-9))
//                      x_sum_5_next=x_sum_5_reg+x[6:1];  //
//                 end
//               if(y[7]==1)   //
//                   begin
//                     y_reg=fuzhu_8-y[6:0];//
//                     if(y_sum_5_reg>y_reg)   //
//                        y_sum_5_next=y_sum_5_reg-y_reg[6:1];
//                      else
//                        y_sum_5_next=0;    //
//                  end            
//                  else    //                
//                     if(y_sum_5_reg<y_max-9-y[6:0])
//                           y_sum_5_next<=y_sum_5_reg+y[6:1];  //               
//                 end   
//   assign x_sum_1=x_sum_1_reg;
//assign x_sum_2=x_sum_2_reg;
//assign x_sum_3=x_sum_3_reg;
//assign x_sum_4=x_sum_4_reg;
//assign x_sum_5=x_sum_5_reg;
//   assign y_sum_1=y_sum_1_reg;
//assign y_sum_2=y_sum_2_reg;
//assign y_sum_3=y_sum_3_reg;
//assign y_sum_4=y_sum_4_reg;
//assign y_sum_5=y_sum_5_reg;
        always@(posedge clk)
          if(btn==3)   //
             begin
                ram_on=0;
                xie_on=1;
                color_on=0;
                xiangpica_on=0;
             end
          else if(btn==4) //
               begin
                  ram_on=1;
                  xie_on=0;
                  color_on=0;
                  xiangpica_on=0;
               end
          else if(btn==2)
           begin
             ram_on=0;
             xie_on=0;
            color_on=1;
            xiangpica_on=0;
           end
           else if(btn==5)
           begin
               ram_on=0;
               xie_on=0;
               color_on=0;
              xiangpica_on=1;
              end
          else      
                begin  
                   ram_on=0;
                   xie_on=0;
                   color_on=0;
                   xiangpica_on=0;
                end 
                                                                      
endmodule

