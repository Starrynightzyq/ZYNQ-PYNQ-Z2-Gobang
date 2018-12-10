`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ball_moving(
  input wire clk,reset,reset_ram,color_on,xiangpica_on,
  input wire video_on,
  input wire we,   //BRAM°ßo1?°ß1
  input wire [9:0] ball_x,ball_y, 
                    ball_x_1,ball_y_1,
                    ball_x_2,ball_y_2,
                    ball_x_3,ball_y_3,
                    ball_x_4,ball_y_4,//?°ßa°ß°ß??®¢??®§°ßo
  input wire [9:0]pix_x,pix_y,
  output reg [2:0]graph_rgb,
  output refr_tick //??1??®§°ßa?2?°ßo1?°ß1D?o?
    );
    
 //3?®∫°ßoy°ß??D?o?°ß|°ß°‰???
 //Xo°ßaY?e°ßo??|®¨??°ß??®∫?°Ï0,0?®∫?|®¨??®∫?°Ï639,479?®∫?
  localparam MAX_X=640;
  localparam MAX_Y=480;
  
  
  //----------------------------------
  //??D??°ß°„
  //----------------------------------
  localparam BALL_SIZE=8;
  //??D??°ß°„?®¢°ß?°ß?°ß°„?®§???
   wire [9:0] ball_x_l,
              ball_x_r,
              ball_y_t,
              ball_y_b,
              
                ball_x_l_1,
                ball_x_r_1,
                ball_y_t_1,
                ball_y_b_1,
                
                ball_x_l_2,
                ball_x_r_2,
                ball_y_t_2,
                ball_y_b_2,
                
                ball_x_l_3,
                ball_x_r_3,
                ball_y_t_3,
                ball_y_b_3,
                
                ball_x_l_4,
                ball_x_r_4,
                ball_y_t_4,
                ball_y_b_4;
  //?°ß2?®¢°ß°‰??D??°ß°„?®¢°ß?2°ß°Ë°ß??°ß|?2°ß°Ë????????
  reg[9:0] ball_x_reg, ball_y_reg,
           ball_x_reg_1, ball_y_reg_1,
           ball_x_reg_2, ball_y_reg_2,
           ball_x_reg_3, ball_y_reg_3,
           ball_x_reg_4, ball_y_reg_4;
  reg[9:0] ball_x_next,ball_y_next,
           ball_x_next_1,ball_y_next_1,
           ball_x_next_2,ball_y_next_2,
           ball_x_next_3,ball_y_next_3,
           ball_x_next_4,ball_y_next_4;
  
  //?-?®§°ßo??®§??
  localparam D=8;      //°ßoy?Y??
  localparam WEI=3;   //|®¨???°Ë??
  
   //----------------------------------
  //?2D??°ß°„
  //----------------------------------
   wire [WEI-1:0] rom_addr,rom_col,
                  rom_addr_1,rom_col_1,
                  rom_addr_2,rom_col_2,
                  rom_addr_3,rom_col_3,
                  rom_addr_4,rom_col_4;
   reg [D-1:0] rom_data,
               rom_data_1, 
               rom_data_2, 
               rom_data_3, 
               rom_data_4;
               
   wire rom_bit,
         rom_bit_1,
         rom_bit_2,
         rom_bit_3,
         rom_bit_4;  
   
   //°ßo?3?D?o?
   wire sq_ball_on,rd_ball_on,
           sq_ball_on_1,rd_ball_on_1,
           sq_ball_on_2,rd_ball_on_2,
           sq_ball_on_3,rd_ball_on_3,
           sq_ball_on_4,rd_ball_on_4;
   reg[2:0] ball_rgb;
   
    //----------------------------------
    //°ßo°ß??|®¨SRAM
    //-----------------------------------
    
    wire [19:0] addr_r,addr_w;   
    wire [2:0] dout;
    //wire stick_on;
     wire stick_on_r;
     wire stick_on_g;
     wire stick_on_b;
     wire stick_on_1;
     wire stick_on_2;
     wire stick_on_3;
    //??°Ï°ß°„?°ß°È????????????®¢?°Ë?®¢°ß°‰????|®¨??®¢??®§°ßo
    reg [9:0] dot_x_reg,dot_y_reg;
    wire [9:0] dot_x_next,dot_y_next;
    
   //???°ß??
   //°ß°Ëy??£§?????°ß2RAM
   dual_port_ram_sync #(.ADDR_WIDTH(19),.DATA_WIDTH(3)) dual_port_ram_sync_uni
                       (.clk(clk),.we(we),.reset_ram(reset_ram),.addr_a(addr_w),.addr_b(addr_r),
                        .din_a(ball_rgb),.dout_a(),.dout_b(dout));
   
   //°ßo°ß??|®¨RAM?°ß??°ß2
    assign addr_w=dot_y_reg*MAX_X+dot_x_reg;
    assign addr_r=pix_y*MAX_X+pix_x;
    
 
   //-----------------------------------
   //?2D??°ß°„
   //-----------------------------------
   always@*
     case(rom_addr)
     16'h0:rom_data=16'b0011_1100;
     16'h1:rom_data=16'b0111_1110; 
     16'h2:rom_data=16'b1111_1111;
     16'h3:rom_data=16'b1111_1111;
     16'h4:rom_data=16'b1111_1111;
     16'h5:rom_data=16'b1111_1111;
     16'h6:rom_data=16'b0111_1110;
     16'h7:rom_data=16'b0011_1100;
     endcase
     always@*
            case(rom_addr_1)
            16'h0:rom_data_1=16'b0011_1100;
            16'h1:rom_data_1=16'b0111_1110; 
            16'h2:rom_data_1=16'b1111_1111;
            16'h3:rom_data_1=16'b1111_1111;
            16'h4:rom_data_1=16'b1111_1111;
            16'h5:rom_data_1=16'b1111_1111;
            16'h6:rom_data_1=16'b0111_1110;
            16'h7:rom_data_1=16'b0011_1100;
            endcase
            always@*
            case(rom_addr_2)
            16'h0:rom_data_2=16'b0011_1100;
            16'h1:rom_data_2=16'b0111_1110; 
            16'h2:rom_data_2=16'b1111_1111;
            16'h3:rom_data_2=16'b1111_1111;
            16'h4:rom_data_2=16'b1111_1111;
            16'h5:rom_data_2=16'b1111_1111;
            16'h6:rom_data_2=16'b0111_1110;
            16'h7:rom_data_2=16'b0011_1100;
            endcase
            always@*
            case(rom_addr_3)
            16'h0:rom_data_3=16'b0011_1100;
            16'h1:rom_data_3=16'b0111_1110; 
            16'h2:rom_data_3=16'b1111_1111;
            16'h3:rom_data_3=16'b1111_1111;
            16'h4:rom_data_3=16'b1111_1111;
            16'h5:rom_data_3=16'b1111_1111;
            16'h6:rom_data_3=16'b0111_1110;
            16'h7:rom_data_3=16'b0011_1100;
            endcase
            always@*
            case(rom_addr_4)
            16'h0:rom_data_4=16'b0011_1100;
            16'h1:rom_data_4=16'b0111_1110; 
            16'h2:rom_data_4=16'b1111_1111;
            16'h3:rom_data_4=16'b1111_1111;
            16'h4:rom_data_4=16'b1111_1111;
            16'h5:rom_data_4=16'b1111_1111;
            16'h6:rom_data_4=16'b0111_1110;
            16'h7:rom_data_4=16'b0011_1100;
            endcase
     //16'h0:rom_data=16'b0000_0111_1110_0000;
     //16'h1:rom_data=16'b0000_1111_1111_0000; 
     //16'h2:rom_data=16'b0001_1111_1111_1000;
     //16'h3:rom_data=16'b0011_1111_1111_1100;
     //16'h4:rom_data=16'b0111_1111_1111_1110;
     //16'h5:rom_data=16'b1111_1111_1111_1111;
     //16'h6:rom_data=16'b1111_1111_1111_1111;
     //16'h7:rom_data=16'b1111_1111_1111_1111;
    // 16'h8:rom_data=16'b1111_1111_1111_1111;
     //16'h9:rom_data=16'b1111_1111_1111_1111;
     //16'ha:rom_data=16'b1111_1111_1111_1111;
     //16'hb:rom_data=16'b0111_1111_1111_1110;
     //16'hc:rom_data=16'b0011_1111_1111_1100;
     //16'hd:rom_data=16'b0001_1111_1111_1000;
     //16'he:rom_data=16'b0000_1111_1111_0000;
     //16'hf:rom_data=16'b0000_0111_1110_0000;
     //endcase
     
 //????????
  always@(posedge clk,posedge reset)
    if(reset)
     begin 
       ball_x_reg<=50;
       ball_y_reg<=50;
        ball_x_reg_1<=50;
        ball_y_reg_1<=50;
        ball_x_reg_2<=50;
        ball_y_reg_2<=50;
        ball_x_reg_3<=50;
        ball_y_reg_3<=50;
        ball_x_reg_4<=50;
        ball_y_reg_4<=50;
                                   
       /////////////
      dot_x_reg<=0;
      dot_y_reg<=0;
       
    end
    else 
     begin
       ball_x_reg<=ball_x_next;
       ball_y_reg<=ball_y_next;
       ball_x_reg_1<=ball_x_next_1;
       ball_y_reg_1<=ball_y_next_1;
       ball_x_reg_2<=ball_x_next_2;
        ball_y_reg_2<=ball_y_next_2;
        ball_x_reg_3<=ball_x_next_3;
        ball_y_reg_3<=ball_y_next_3;
        ball_x_reg_4<=ball_x_next_4;
        ball_y_reg_4<=ball_y_next_4;
       ////////////////////////
        dot_x_reg<=dot_x_next;
        dot_y_reg<=dot_y_next;                    
     end
     
 //?°ß°È????®¶D??°ßo?a60Hz?®∫?rerf_tick?®§°ßa°ßo???1??®§°ßa?2??a°ßo?
  assign refr_tick=(pix_y==481)&&(pix_x==0);
  
  //--------------------------------------------
  //??°ßo??°ß°„
  //--------------------------------------------
  //?®§???
  assign ball_x_l=ball_x_reg;
  assign ball_x_r=ball_x_l+BALL_SIZE-1;
  assign ball_y_t=ball_y_reg;
  assign ball_y_b=ball_y_t+BALL_SIZE-1;
  //?®§???1
  assign ball_x_l_1=ball_x_reg_1;
  assign ball_x_r_1=ball_x_l_1+BALL_SIZE-1;
  assign ball_y_t_1=ball_y_reg_1;
  assign ball_y_b_1=ball_y_t_1+BALL_SIZE-1;
  //?®§???2
  assign ball_x_l_2=ball_x_reg_2;
  assign ball_x_r_2=ball_x_l_2+BALL_SIZE-1;
  assign ball_y_t_2=ball_y_reg_2;
  assign ball_y_b_2=ball_y_t_2+BALL_SIZE-1;
  //?®§???3
  assign ball_x_l_3=ball_x_reg_3;
  assign ball_x_r_3=ball_x_l_3+BALL_SIZE-1;
  assign ball_y_t_3=ball_y_reg_3;
  assign ball_y_b_3=ball_y_t_3+BALL_SIZE-1;
  //?®§???4
  assign ball_x_l_4=ball_x_reg_4;
  assign ball_x_r_4=ball_x_l_4+BALL_SIZE-1;
  assign ball_y_t_4=ball_y_reg_4;
  assign ball_y_b_4=ball_y_t_4+BALL_SIZE-1;
  //?°ß°„??°ßo???°ß?°ß°„
  assign sq_ball_on=(ball_x_l<=pix_x)&&(ball_x_r>=pix_x)&&
                      (ball_y_t<=pix_y)&&(ball_y_b>=pix_y);
 //?°ß°„1??°ßo???°ß?°ß°„
  assign sq_ball_on_1=(ball_x_l_1<=pix_x)&&(ball_x_r_1>=pix_x)&&
                      (ball_y_t_1<=pix_y)&&(ball_y_b_1>=pix_y);
 //?°ß°„2??°ßo???°ß?°ß°„
  assign sq_ball_on_2=(ball_x_l_2<=pix_x)&&(ball_x_r_2>=pix_x)&&
                      (ball_y_t_2<=pix_y)&&(ball_y_b_2>=pix_y);
 //?°ß°„3??°ßo???°ß?°ß°„
 assign sq_ball_on_3=(ball_x_l_3<=pix_x)&&(ball_x_r_3>=pix_x)&&
                      (ball_y_t_3<=pix_y)&&(ball_y_b_3>=pix_y);
 //?°ß°„4??°ßo???°ß?°ß°„
 assign sq_ball_on_4=(ball_x_l_4<=pix_x)&&(ball_x_r_4>=pix_x)&&
                      (ball_y_t_4<=pix_y)&&(ball_y_b_4>=pix_y);
  //°ß?3°ß|?|®¨?®§????????®¢??®§°ßo|®¨?ROM|®¨???°Ë°ß°ÈD????
    assign rom_addr=pix_y[WEI-1:0]-ball_y_t[WEI-1:0];
    assign rom_col=pix_x[WEI-1:0]-ball_x_l[WEI-1:0];
    assign rom_bit=rom_data[D-1-rom_col];
    
    assign rom_addr_1=pix_y[WEI-1:0]-ball_y_t_1[WEI-1:0];
    assign rom_col_1=pix_x[WEI-1:0]-ball_x_l_1[WEI-1:0];
    assign rom_bit_1=rom_data_1[D-1-rom_col_1];
    
    assign rom_addr_2=pix_y[WEI-1:0]-ball_y_t_2[WEI-1:0];
    assign rom_col_2=pix_x[WEI-1:0]-ball_x_l_2[WEI-1:0];
    assign rom_bit_2=rom_data_2[D-1-rom_col_2];
    
    assign rom_addr_3=pix_y[WEI-1:0]-ball_y_t_3[WEI-1:0];
    assign rom_col_3=pix_x[WEI-1:0]-ball_x_l_3[WEI-1:0];
    assign rom_bit_3=rom_data_3[D-1-rom_col_3];
    
    assign rom_addr_4=pix_y[WEI-1:0]-ball_y_t_4[WEI-1:0];
    assign rom_col_4=pix_x[WEI-1:0]-ball_x_l_4[WEI-1:0];
    assign rom_bit_4=rom_data_4[D-1-rom_col_4];
   //?°ß°„??????°ßo???°ß?°ß°„
    assign rd_ball_on=sq_ball_on&&rom_bit;
    //?°ß°„1??????°ßo???°ß?°ß°„
    assign rd_ball_on_1=sq_ball_on_1&&rom_bit_1;
    //?°ß°„2??????°ßo???°ß?°ß°„
    assign rd_ball_on_2=sq_ball_on_2&&rom_bit_2;
    //?°ß°„3??????°ßo???°ß?°ß°„
    assign rd_ball_on_3=sq_ball_on_3&&rom_bit_3;
    //?°ß°„4??????°ßo???°ß?°ß°„
    assign rd_ball_on_4=sq_ball_on_4&&rom_bit_4;
  //?°ß°„??°ßo??ao°ß?°ß|?
  //assign ball_rgb=3'b100; 
 //?®§?°ß|? 
 reg [2:0] i;   
//assign i=(reset)?0:(color_on)?i+1:(xiangpica_on)?7:i;
   always@(posedge reset,posedge color_on,posedge xiangpica_on)
      begin 
        if(reset)
            i<=0;
        
          else if(xiangpica_on) 
           i<=7; 
          else 
            begin
            if(i==6)
              i<=0;
            else          
            i<=i+1; 
              end   
       end
  always@(posedge clk)
begin
  case(i)
0:ball_rgb=3'b001;
1:ball_rgb=3'b010;
2: ball_rgb=3'b011;
3: ball_rgb=3'b100;
4: ball_rgb=3'b101;
5: ball_rgb=3'b110;
6: ball_rgb=3'b001;
7: ball_rgb=3'b000;
default:ball_rgb=3'b000;
endcase
end
  //    if(i==0)
   //  ball_rgb=3'b001;
    //  else if(i==1)
   // ball_rgb=3'b010;
   //    else if(i==2)
   // ball_rgb=3'b011;  
  //     else if(i==3)
  // ball_rgb=3'b100; 
  //     else if(i==4)
  //  ball_rgb=3'b101; 
  //     else if(i==5)
  //  ball_rgb=3'b110; 
   //  else if(i==6)
   //     ball_rgb=3'b001;
    //   else if(i==7)
  //  ball_rgb=3'b000; 
   
  //?®¢?°Ë?®¢°ß°‰????|®¨??®¢??®§°ßo
  assign dot_x_next=(rd_ball_on||rd_ball_on_1||rd_ball_on_2||rd_ball_on_3||rd_ball_on_4)?pix_x:dot_x_reg;
  assign dot_y_next=(rd_ball_on||rd_ball_on_1||rd_ball_on_2||rd_ball_on_3||rd_ball_on_4)?pix_y:dot_y_reg;
//  assign dot_x_next=(rd_ball_on)?pix_x:dot_x_reg;
//  assign dot_y_next=(rd_ball_on)?pix_y:dot_y_reg;
  assign stick_on_r=(dout==3'b001);
  assign stick_on_g=(dout==3'b010);
  assign stick_on_b=(dout==3'b011);
   assign stick_on_1=(dout==3'b100);
   assign stick_on_2=(dout==3'b101);
   assign stick_on_3=(dout==3'b110);
  //?°ß°„°ß°„???£§|®¨?D?|®¨??e°ßo??®¢??®§°ßo
  always@*
   begin 
    ball_x_next=ball_x_reg;   //2???£§
    ball_y_next=ball_y_reg;   //2???£§
       if(refr_tick)
        begin
            if((ball_x_r<=(MAX_X-1))&&(ball_x_l>=0))
            ball_x_next=ball_x-BALL_SIZE/2;   
            if((ball_y_t>=0)&&(ball_y_b<=MAX_Y-1))
            ball_y_next=ball_y-BALL_SIZE/2;   
            
            if((ball_x_r_1<=(MAX_X-1))&&(ball_x_l_1>=0))
            ball_x_next_1=ball_x_1-BALL_SIZE/2;   
            if((ball_y_t_1>=0)&&(ball_y_b_1<=MAX_Y-1))
            ball_y_next_1=ball_y_1-BALL_SIZE/2;   
            
            if((ball_x_r_2<=(MAX_X-1))&&(ball_x_l_2>=0))
            ball_x_next_2=ball_x_2-BALL_SIZE/2;   
            if((ball_y_t_2>=0)&&(ball_y_b_2<=MAX_Y-1))
            ball_y_next_2=ball_y_2-BALL_SIZE/2;   
            
            if((ball_x_r_3<=(MAX_X-1))&&(ball_x_l_3>=0))
            ball_x_next_3=ball_x_3-BALL_SIZE/2;   
            if((ball_y_t_3>=0)&&(ball_y_b_3<=MAX_Y-1))
            ball_y_next_3=ball_y_3-BALL_SIZE/2;   
            
            if((ball_x_r_4<=(MAX_X-1))&&(ball_x_l_4>=0))
            ball_x_next_4=ball_x_4-BALL_SIZE/2;   
            if((ball_y_t_4>=0)&&(ball_y_b_4<=MAX_Y-1))
            ball_y_next_4=ball_y_4-BALL_SIZE/2;   
        end
   end
   
 //??°ßo?????|®¨???°Ë
 always@*
    if(!video_on)
      graph_rgb=3'b000;
    else 
    if(rd_ball_on)
      graph_rgb=ball_rgb;
    else
    if(stick_on_r)
       graph_rgb=3'b001;
    else   
    if(stick_on_g)
       graph_rgb=3'b010; 
    else
    if(stick_on_b)
       graph_rgb=3'b011; 
    else
    if(stick_on_1)
    graph_rgb=3'b100;
    else if(stick_on_2)
    graph_rgb=3'b101;
    else if(stick_on_3)
    graph_rgb=3'b110;
    else
      graph_rgb=3'b111; //?®§3????a???®¢°ß|?           
 endmodule  
