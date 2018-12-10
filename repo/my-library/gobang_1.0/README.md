# gobang_display 接口

## 信号说明

> input wire

- 系统

  - clk		//100MHz

  - rst_p       //高电平有效

    ---

  - clr            //清空棋盘

- VGA信号

  - [11:0] pixel_x
  - [11:0] pixel_y
  - video_on

- 棋盘控制信号

  - black_is_player  //1'b1: 黑子是人类玩家，1'b0: 黑子是AI玩家

  - white_is_player  //同black_is_player 

  - game_running    //游戏使能，影响 crt_player 作用

  - crt_player            // 当前玩家指示，0 is black， 1 is white

  - [1:0] winner         //Who wins the game , winner[1] == 1 is black win, winner[0] == 1 is white win

    ---

  - [3:0] cursor_i       //当前光标横坐标位置

  - [3:0] cursor_j       //当前光标纵坐标位置

    ---

  - write                     //落子使能

  - retract                   //悔棋使能

  - write_color            //落子/悔棋 颜色，0黑色，1白色

    ---

  - [3:0] write_i           //落子/悔棋 纵坐标

  - [3:0] write_j           //落子/悔棋 横坐标



---

> output wire

- VGA信号
  - [3:0] r_dout
  - [3:0] g_dout
  - [3:0] b_dout

## 寄存器分配

- reg0 bassaddr

  w/r

  | 31 - 0   |
  | -------- |
  | reserved |

- reg1 signal_ctrl

  w/r

  | 31 - 7   | 6    | 5               | 4               | 3            | 2          | 1 - 0  |
  | -------- | ---- | --------------- | --------------- | ------------ | ---------- | ------ |
  | reserved | clr  | black_is_player | white_is_player | game_running | crt_player | winner |

- reg2 chess_ctrl

  w/r

  | 31 - 3   | 2     | 1       | 0           |
  | -------- | ----- | ------- | ----------- |
  | reserved | write | retract | write_color |

- reg3 chess_coord

  w/r

  | 31 - 24  | 23 - 20  | 19 - 16  | 15 - 8   | 7 - 4   | 3 - 0   |
  | -------- | -------- | -------- | -------- | ------- | ------- |
  | reserved | cursor_i | cursor_j | reserved | write_i | write_j |




## C函数

- 
- 