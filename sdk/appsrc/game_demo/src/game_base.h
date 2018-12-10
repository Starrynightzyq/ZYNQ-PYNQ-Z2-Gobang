/*
 * game_base.h
 *
 *  Created on: 2018年10月5日
 *      Author: admin
 */

#ifndef SRC_GAME_BASE_H_
#define SRC_GAME_BASE_H_

#include "xil_types.h"
#include "stdio.h"
#include "string.h"
#include <stdbool.h>

#define GRID_N 15
//#define GRID_DN 19
//#define CHESS_TYPE_N 17
#define SEAT_MAX 113

enum chess_type {
	NO_GHESS = 0, AI1_CHESS = 1, AI2_CHESS = 2, H1_CHESS = 3, H2_CHESS = 4
};

enum chess_color {
	BLACK = 1, WHITE = 2
};

enum chess_mode {
	AI1_VS_AI2 = 0, AI_FIRST = 1, AI_SECOND = 2, H1_VS_H2 = 3
};

enum win_mode {
	NO_WIN = 0, BLACK_WIN = 2, WHITE_WIN = 1
};

//typedef u8 Chessid;

typedef struct {
	u8 y;	//纵坐标j
	u8 x;	//横坐标i
} Point;

typedef struct {
	Point seat;	//选择坐标
	u16 score;	//得分
} Choice;

typedef struct {
	u8 color;					//执子颜色 BLACK or WHITE
	u8 chess_type;				//NO_GHESS = 0, AI1_CHESS = 1, AI2_CHESS = 2, H1_CHESS = 3, H2_CHESS = 4
	u32 step;					//步数
	Choice this_choice;			//当前落子选择
	Point all_seat[SEAT_MAX];	//储存棋谱
} Player;

extern bool flag_laozi;	//落子标志
extern bool flag_retract;		//悔棋标志
extern u8 currect_color;
extern u8 flag_laozi_black;	//黑棋落子标志
extern u8 flag_laozi_white;
extern u8 flag_game_over;	//游戏结束标志
extern u8 flag_clr_board;	//清空棋盘标志
extern u8 seat_cursor_i, seat_cursor_j;	//光标位置
extern u8 flag_retract_black;	//黑棋悔棋标志
extern u8 flag_retract_white;	//白旗悔棋标志
extern u8 flag_pVSp;	//人人对战标
extern u8 flag_black_is_people;	//黑子是人类玩家  0否、1是
extern u8 flag_white_is_people;	//白子时人类玩家
extern bool flag_mode_select;	//模式选择
extern bool flag_game_hint;	//提示
extern bool flag_start_game;	//开始游戏按鈕標志
extern bool flag_mute;			//静音
extern bool flag_mute_btn;			//静音

extern u8 board[GRID_N][GRID_N];	//棋盘

extern Player Player_Black;	//玩家
extern Player Player_White;
extern Player *Player_Cur;		//当前玩家

extern Point Cursor;	//光标

extern u8 Mode;	//游戏模式 AI1_VS_AI2 = 0, AI_FIRST = 1, AI_SECOND = 2, H1_VS_H2 = 3

extern u32 remaining_seat;	//棋盘剩余空位置

extern bool flag_value_intr;	//value模块计算出结果标志位
extern bool flag_man_choice_on;	//人类选择有效标志位

extern u8 Winner;	//0x01 is white win , 0x02 is black win

//初始化玩家
void Init_player_l(u8 black_chess_type, u8 white_chess_type);

//初始化棋盘
void Init_board_l(void);

//初始化光标
void Init_marker_l(u8 x, u8 y);

//判断是否是AI 还是 HUMAN ，AI返回 1， 否则返回0
u8 Is_AI_or_Human(Player *player);

//游戏初始化
void Game_Init(void);

//游戏模式选择
void Game_ModeSelect(void);

//游戏重新开始
void Game_Restart(void);

//游戏悔棋
void Game_Retract(void);

//游戏落子 未进行非空判断
void Game_Laozi(void);

//游戏AI选择落子位置
bool Game_AI_Choice(void);

//游戏人类玩家选择落子位置
void Game_MAN_Choice(void);

//游戏提示
bool Game_Hint(void);

//游戏切换玩家
void Game_Change_PlayerCur(void);

//检查是否赢棋， 返回 BLACK_WIN or WHITE_WIN
bool Game_CheckWin(u8 *first_x, u8 *first_y, u8 *last_x, u8 *last_y);

//通过WiFi的数据控制棋盘
void Game_CtrlbyWiFi(void);

//just for test
void Game_draw_board(void);

//游戏结束时播放音乐
void Game_end_music(void);

#endif /* SRC_GAME_BASE_H_ */
