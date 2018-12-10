/*
 * game_base.c
 *
 *  Created on: 2018年10月5日
 *      Author: admin
 */

#include "game_base.h"
#include "gobang.h"
#include "ChessValue.h"
#include "wifi.h"
#include "sleep.h"
#include "pen.h"
#include "mp3.h"

bool flag_laozi = false;	//落子标志
bool flag_retract = false;		//悔棋标志
//u32 remaining_seat = 225;	//棋盘剩余空位置
u8 currect_color = 0;
u8 flag_laozi_black = 0;	//黑棋落子标志
u8 flag_laozi_white = 0;
u8 flag_game_over = 1;	//游戏结束标志
u8 flag_clr_board = 0;	//清空棋盘标志
u8 flag_retract_black = 0;	//黑棋悔棋标志
u8 flag_retract_white = 0;	//白旗悔棋标志
u8 flag_pVSp = 0;	//人人对战标志
u8 flag_black_is_people = 0;	//黑子是人类玩家  0否、1是
u8 flag_white_is_people = 0;	//白子时人类玩家
bool flag_mode_select = false;	//模式选择
bool flag_game_hint = false;	//提示
bool flag_start_game = false;	//开始游戏按鈕標志
bool flag_mute = false;			//静音
bool flag_mute_btn = false;			//静音

Player Player_Black;	//玩家
Player Player_White;
Player *Player_Cur;		//当前玩家
Choice Hint_Choice;		//推荐步骤

u8 board[GRID_N][GRID_N];	//棋盘

Point Cursor;	//光标

u8 Mode = 0;	//游戏模式 AI1_VS_AI2 = 0, AI_FIRST = 1, AI_SECOND = 2, H1_VS_H2 = 3

u32 remaining_seat = 225;	//棋盘剩余空位置

bool flag_value_intr = false;	//value模块计算出结果标志位
bool flag_man_choice_on = false;	//人类选择有效标志位

u8 Winner = 0;	//0x01 is white win , 0x02 is black win

extern XGame Gobang;
extern ChessValue GameValue;

//初始化玩家
void Init_player_l(u8 black_chess_type, u8 white_chess_type) {
	Player_Black.color = BLACK;
	Player_Black.chess_type = black_chess_type;
	Player_Black.step = 0;
	Player_Black.this_choice.seat.x = 0;
	Player_Black.this_choice.seat.y = 0;
	Player_Black.this_choice.score = 0;
	memset(Player_Black.all_seat,0,sizeof(Player_Black.all_seat));

	Player_White.color = WHITE;
	Player_White.chess_type = white_chess_type;
	Player_White.step = 0;
	Player_White.this_choice.seat.x = 0;
	Player_White.this_choice.seat.y = 0;
	Player_White.this_choice.score = 0;
	memset(Player_White.all_seat,0,sizeof(Player_White.all_seat));

	Hint_Choice.score = 2;
	Hint_Choice.seat.x = 7;
	Hint_Choice.seat.y = 7;

	Player_Cur = &Player_Black;	//当前玩家为黑子玩家
}

//初始化棋盘
void Init_board_l(void) {
	memset(board,0,sizeof(board));
}

//初始化光标
void Init_marker_l(u8 x, u8 y) {
	Cursor.y = y;	//光标初始位置
	Cursor.x = x;
}

//判断是否是AI 还是 HUMAN ，AI返回 1， 否则返回0
u8 Is_AI_or_Human(Player *player) {
	if((player->chess_type == AI1_CHESS)||(player->chess_type == AI2_CHESS)) {
		return 1;
	}
	else {
		return 0;
	}
}

//-----------对外接口---------------

//游戏初始化
void Game_Init(void) {
	Init_board_l();			//初始化棋盘 清空board[][]
	Init_marker_l(7,7);		//初始化光标

	flag_game_over = true;	//初始化flag

	remaining_seat = 225;

	Winner = NO_WIN;

	XGame_ClrBoard(&Gobang);		//硬件清空棋盘
	XGame_Winner(&Gobang, NO_WIN);	//硬件清空输赢
	XGame_UnMark(&Gobang);	//硬件清空五子路径
	XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//光标
	XGame_StartPage(&Gobang, flag_game_over);	//显示第一页
	XGame_CursorShape(&Gobang, 1);
//	Game_ModeSelect();		//初始化玩家

	if ( Mode == AI1_VS_AI2 ) {
		Init_player_l(AI1_CHESS, AI2_CHESS);
//		SendWifiData(0, 0, 0, ID_AVA);
	}
	else
	if ( Mode == AI_FIRST ) {
		Init_player_l(AI1_CHESS, H1_CHESS);
//		SendWifiData(0, 0, WHITE, ID_PVA_EASY);
	}
	else if ( Mode == AI_SECOND ) {
		Init_player_l(H1_CHESS, AI1_CHESS);
//		SendWifiData(0, 0, BLACK, ID_PVA_EASY);
	}
	else { // if ( Mode==3 )
		Init_player_l(H1_CHESS, H2_CHESS);
//		SendWifiData(0, 0, 0, ID_PVP);
	}
	XGame_StartPage(&Gobang, flag_game_over);
	XGame_isPlayer(&Gobang, Mode);
	XGame_CrtPlayer(&Gobang, BLACK);

	Pen_Init_soft();	//初始化Pen的颜色

	SendWifiData(0, 0, 0, ID_RESTART);	//发送重新开始信号

	//循环播放背景音乐
	MP3_Loop_Bgm();
	MP3_Set_Volume_Max();

	//打开声音图标
	XGame_SoundOnOff(&Gobang, 1);
}

//游戏模式选择
void Game_ModeSelect(void) {
	if ( Mode == AI1_VS_AI2 ) {
		Init_player_l(AI1_CHESS, AI2_CHESS);
		SendWifiData(0, 0, 0, ID_AVA);
	}
	else
	if ( Mode == AI_FIRST ) {
		Init_player_l(AI1_CHESS, H1_CHESS);
		SendWifiData(0, 0, WHITE, ID_PVA_EASY);
	}
	else if ( Mode == AI_SECOND ) {
		Init_player_l(H1_CHESS, AI1_CHESS);
		SendWifiData(0, 0, BLACK, ID_PVA_EASY);
	}
	else { // if ( Mode==3 )
		Init_player_l(H1_CHESS, H2_CHESS);
		SendWifiData(0, 0, 0, ID_PVP);
	}
	XGame_StartPage(&Gobang, flag_game_over);
	XGame_isPlayer(&Gobang, Mode);
	XGame_CrtPlayer(&Gobang, BLACK);
}

//游戏重新开始
void Game_Restart(void) {
	Init_board_l();			//初始化棋盘 清空board[][]
	Init_marker_l(7,7);		//初始化光标

	flag_game_over = true;	//初始化flag

	remaining_seat = 225;

	Winner = NO_WIN;

	XGame_ClrBoard(&Gobang);		//硬件清空棋盘
	XGame_Winner(&Gobang, NO_WIN);	//硬件清空输赢
	XGame_UnMark(&Gobang);	//硬件清空五子路径
	XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//光标
	XGame_StartPage(&Gobang, flag_game_over);	//显示第一页
	XGame_CursorShape(&Gobang, 1);
//	Game_ModeSelect();		//初始化玩家
	if ( Mode == AI1_VS_AI2 ) {
		Init_player_l(AI1_CHESS, AI2_CHESS);
	}
	else
	if ( Mode == AI_FIRST ) {
		Init_player_l(AI1_CHESS, H1_CHESS);
	}
	else if ( Mode == AI_SECOND ) {
		Init_player_l(H1_CHESS, AI1_CHESS);
	}
	else { // if ( Mode==3 )
		Init_player_l(H1_CHESS, H2_CHESS);
	}
	XGame_isPlayer(&Gobang, Mode);
	XGame_CrtPlayer(&Gobang, BLACK);
	SendWifiData(0, 0, 0, ID_RESTART);	//发送重新开始信号

	Pen_Init_soft();	//初始化Pen的颜色

}

//游戏悔棋
void Game_Retract(void) {
	u8 b_y = Player_Black.all_seat[Player_Black.step].y;
	u8 b_x = Player_Black.all_seat[Player_Black.step].x;
	u8 w_y = Player_White.all_seat[Player_White.step].y;
	u8 w_x = Player_White.all_seat[Player_White.step].x;

	if((board[b_y][b_x] != NO_GHESS) &&
			(board[w_y][w_x] != NO_GHESS)) {
		board[b_y][b_x] = NO_GHESS;
		board[w_y][w_x] = NO_GHESS;

		Player_Black.step -= 1;
		Player_White.step -= 1;

		remaining_seat += 2;

		XGame_RetractChess(&Gobang, b_y, b_x, BLACK);
		XGame_RetractChess(&Gobang, w_y, w_x, WHITE);

		SendWifiData(0, 0, 0, ID_RETRACT);
//		SendWifiData(b_y, b_x, BLACK, ID_RETRACT);
//		SendWifiData(w_x, w_x, WHITE, ID_RETRACT);
	}
	else {
		xil_printf("No retract!\r\n");
	}
}

//游戏落子 未进行非空判断
void Game_Laozi(void) {
	u8 x = Player_Cur->this_choice.seat.x;
	u8 y = Player_Cur->this_choice.seat.y;
	u32 step = 0;
	u8 color = Player_Cur->color;

	//软件落子
	board[y][x] = Player_Cur->chess_type;
	/*just for test*/
//	Game_draw_board();

	Player_Cur->step += 1;
	remaining_seat -= 2;

	step = Player_Cur->step;
	Player_Cur->all_seat[step] = Player_Cur->this_choice.seat;

	//AI 第一次落子延迟2s
	if(Player_Cur->chess_type == AI1_CHESS) {
		if(Player_Cur->step == 1 && (Mode == AI1_VS_AI2 || Mode == AI_FIRST)) {
			sleep(2);
		}
	}

	//硬件落子
	XGame_PlayChess(&Gobang, y, x, color);
	//修改光标位置
	Cursor = Player_Cur->this_choice.seat;
	XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);

	SendWifiData(y, x, color, ID_LAOZI);

	//播放音效
	if((Player_Cur->chess_type == H1_CHESS) || (Player_Cur->chess_type == H2_CHESS)) {
		MP3_Play_chess();
	}
}

//游戏AI选择落子位置
bool Game_AI_Choice(void) {
	Choice w_choice, b_choice;

	ChessValue_Active(&GameValue);

	if(flag_value_intr == true) {
		flag_value_intr = false;
		ChessValue_GetSeat(&GameValue, &(b_choice.seat.x), &(b_choice.seat.y), &(w_choice.seat.x), &(w_choice.seat.y));
		ChessValue_GetValue(&GameValue, &(b_choice.score), &(w_choice.score));

		xil_printf("b_score = %d, w_s_core = %d\r\n",b_choice.score, w_choice.score);

		if(Player_Cur->step == 0) {	//第一步落中心
			if(board[7][7] == NO_GHESS) {
				Player_Cur->this_choice.seat.x = 7;
				Player_Cur->this_choice.seat.y = 7;
				Player_Cur->this_choice.score = 2;
			}
			else {
				Player_Cur->this_choice.seat.x = 8;
				Player_Cur->this_choice.seat.y = 8;
				Player_Cur->this_choice.score = 0;
			}
		}
		else if(Player_Cur->color == BLACK) {
			if(b_choice.score == w_choice.score) {
				Player_Cur->this_choice = b_choice;
			}
			else if(b_choice.score > w_choice.score) {
				Player_Cur->this_choice = b_choice;
			}
			else {
				Player_Cur->this_choice = w_choice;
			}
		}
		else {
			if(b_choice.score == w_choice.score) {
				Player_Cur->this_choice = w_choice;
			}
			else if(b_choice.score > w_choice.score) {
				Player_Cur->this_choice = b_choice;
			}
			else {
				Player_Cur->this_choice = w_choice;
			}
		}

		return true;
	}
	else {
		return false;
	}
}

//游戏人类玩家选择落子位置
void Game_MAN_Choice(void) {
	Player_Cur->this_choice.seat = Cursor;
}

//游戏提示
bool Game_Hint(void) {
	Choice w_choice, b_choice;

	ChessValue_Active(&GameValue);

	if(flag_value_intr == true) {
		flag_value_intr = false;
		ChessValue_GetSeat(&GameValue, &(b_choice.seat.x), &(b_choice.seat.y), &(w_choice.seat.x), &(w_choice.seat.y));
		ChessValue_GetValue(&GameValue, &(b_choice.score), &(w_choice.score));

//		xil_printf("b_score = %d, w_s_core = %d\r\n",b_choice.score, w_choice.score);

		if(Player_Cur->step == 0) {	//第一步落中心
			if(board[7][7] == NO_GHESS) {
				Hint_Choice.seat.x = 7;
				Hint_Choice.seat.y = 7;
				Hint_Choice.score = 2;
			}
			else {
				Hint_Choice.seat.x = 8;
				Hint_Choice.seat.y = 8;
				Hint_Choice.score = 0;
			}
		}
		else if(Player_Cur->color == BLACK) {
			if(b_choice.score == w_choice.score) {
				Hint_Choice = b_choice;
			}
			else if(b_choice.score > w_choice.score) {
				Hint_Choice = b_choice;
			}
			else {
				Hint_Choice = w_choice;
			}
		}
		else {
			if(b_choice.score == w_choice.score) {
				Hint_Choice = w_choice;
			}
			else if(b_choice.score > w_choice.score) {
				Hint_Choice = b_choice;
			}
			else {
				Hint_Choice = w_choice;
			}
		}

		xil_printf("Hint_score = %d, Hint_Choice = %d,%d\r\n",
				Hint_Choice.score, Hint_Choice.seat.x, Hint_Choice.seat.y);

		/*显示光标*/
		Cursor = Hint_Choice.seat;
		XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//修改光标位置

		/*发送wifi数据*/
		WifiClrFlag();
		SendWifiData(Hint_Choice.seat.y, Hint_Choice.seat.x, Player_Cur->color, ID_HINT);

		return true;
	}
	else {
		return false;
	}
}

//游戏切换玩家
void Game_Change_PlayerCur(void) {
	if(Player_Cur == (&Player_Black)) {
		Player_Cur = &Player_White;
		xil_printf("cur_player b -> w\r\n");
	}
	else if(Player_Cur == (&Player_White)) {
		Player_Cur = &Player_Black;
		xil_printf("cur_player w -> b\r\n");
	}
	XGame_CrtPlayer(&Gobang, Player_Cur->color);
}

bool Game_CheckWin(u8 *first_x, u8 *first_y, u8 *last_x, u8 *last_y) {
	int r, c, cnt;
	r=Player_Cur->this_choice.seat.x, c=Player_Cur->this_choice.seat.y, cnt=0;
	*first_x = Player_Cur->this_choice.seat.x;
	*first_y = Player_Cur->this_choice.seat.y;
	*last_x = Player_Cur->this_choice.seat.x;
	*last_y = Player_Cur->this_choice.seat.y;
	while (c<GRID_N && board[c][r] == Player_Cur->chess_type) {
		*last_y = c;
		cnt++, c++;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;
	c = Player_Cur->this_choice.seat.y-1;
	while ( c>=0 && board[c][r] == Player_Cur->chess_type) {
		*first_y = c;
		cnt++, c--;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;

	r=Player_Cur->this_choice.seat.x, c=Player_Cur->this_choice.seat.y, cnt=0;
	*first_x = Player_Cur->this_choice.seat.x;
	*first_y = Player_Cur->this_choice.seat.y;
	*last_x = Player_Cur->this_choice.seat.x;
	*last_y = Player_Cur->this_choice.seat.y;
	while ( r<GRID_N && board[c][r] == Player_Cur->chess_type) {
		*last_x = r;
		cnt++, r++;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;
	r = Player_Cur->this_choice.seat.x-1;
	while (  r>=0 && board[c][r] == Player_Cur->chess_type) {
		*first_x = r;
		cnt++, r--;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;

	r=Player_Cur->this_choice.seat.x, c=Player_Cur->this_choice.seat.y, cnt=0;
	*first_x = Player_Cur->this_choice.seat.x;
	*first_y = Player_Cur->this_choice.seat.y;
	*last_x = Player_Cur->this_choice.seat.x;
	*last_y = Player_Cur->this_choice.seat.y;
	while ( c<GRID_N && r<GRID_N && board[c][r] == Player_Cur->chess_type) {
		*last_y = c;
		*last_x = r;
		cnt++,c++,r++;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;
	c=Player_Cur->this_choice.seat.y-1, r=Player_Cur->this_choice.seat.x-1;
	while ( r>=0  && c>=0  && board[c][r] == Player_Cur->chess_type) {
		*first_y = c;
		*first_x = r;
		cnt++, c--, r--;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;

	r=Player_Cur->this_choice.seat.x, c=Player_Cur->this_choice.seat.y, cnt=0;
	*first_x = Player_Cur->this_choice.seat.x;
	*first_y = Player_Cur->this_choice.seat.y;
	*last_x = Player_Cur->this_choice.seat.x;
	*last_y = Player_Cur->this_choice.seat.y;
	while ( c<GRID_N && r>=0  && board[c][r] == Player_Cur->chess_type) {
		*first_y = c;
		*first_x = r;
		cnt++, c++, r--;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;
	c=Player_Cur->this_choice.seat.y-1, r=Player_Cur->this_choice.seat.x+1;
	while ( c>=0  && r<GRID_N && board[c][r] == Player_Cur->chess_type) {
		*last_y = c;
		*last_x = r;
		cnt++, c--, r++;
//		if(cnt >= 5) {
//			break;
//		}
	}
	if (cnt>=5) return 1;

	return 0;

//	if(Winner == WHITE_WIN) { //white win
//		XGame_Winner(&Gobang, WHITE_WIN);
//		return true;
//	}
//	else if(Winner == BLACK_WIN) {	//black win
//		XGame_Winner(&Gobang, BLACK_WIN);
//		return true;
//	}
//	else {
//		XGame_Winner(&Gobang, 0x00);
//		return false;
//	}
}


//通过WiFi的数据控制棋盘
void Game_CtrlbyWiFi(void) {
	static u8 seat_y, seat_x = 0;
	static u8 color = 0;
	static u8 ID = 0;
	GetWifiData(&seat_y, &seat_x, &color, &ID);
	switch(ID) {
	case ID_PVA_EASY:
		if(flag_game_over == true) {
			flag_mode_select = true;
			if(color == BLACK) {	//人类玩家黑子，先手
				Mode = AI_SECOND;
			}
			else if(color == WHITE) {	//人类玩家白子，后手
				Mode = AI_FIRST;
			}
		}
		break;
	case ID_PVA_GENERAL:
		if(flag_game_over == true) {
			flag_mode_select = true;
			if(color == BLACK) {	//人类玩家黑子，先手
				Mode = AI_SECOND;
			}
			else if(color == WHITE) {	//人类玩家白子，后手
				Mode = AI_FIRST;
			}
		}
		break;
	case ID_PVA_HARD:
		if(flag_game_over == true) {
			flag_mode_select = true;
			if(color == BLACK) {	//人类玩家黑子，先手
				Mode = AI_SECOND;
			}
			else if(color == WHITE) {	//人类玩家白子，后手
				Mode = AI_FIRST;
			}
		}
		break;
	case ID_PVP:
		if(flag_game_over == true) {
			flag_mode_select = true;
			Mode = H1_VS_H2;
		}
		break;
	case ID_AVA:
		if(flag_game_over == true) {
			flag_mode_select = true;
			Mode = AI1_VS_AI2;
		}
		break;
	case ID_LAOZI:	//落子
		flag_laozi = true;
		Cursor.y = seat_y;
		Cursor.x = seat_x;
//		Game_MAN_Choice();
		XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);
		break;
	case ID_RETRACT:	//悔棋
		flag_retract = true;
		break;
	case ID_WIN:

		break;
	case ID_RESTART:	//清空棋盘
		flag_clr_board = 1;
		break;
	case ID_RECV_ERROR:

		break;
	case ID_HINT:
		if(flag_game_over == false) {
			flag_game_hint = true;
		}
		break;
	case ID_START_GAME:
		flag_start_game = true;
		break;
	}
}

//just for test
void Game_draw_board(void) {
	int i = 0;
	int j = 0;
	for(i = 0; i < 15; i++) {
		for(j = 0; j < 15; j++) {
			xil_printf("%d ", board[i][j]);
		}
		xil_printf("\r\n");
	}
	xil_printf("\r\n");
}

//游戏结束时播放音乐
void Game_end_music(void) {
	switch(Mode) {
	case AI1_VS_AI2:
		MP3_Play_Win();
		break;
	case AI_FIRST:	//AI black
		if(Player_Cur->color == BLACK) {
			MP3_Play_Lose();
		}
		else if(Player_Cur->color == WHITE) {
			MP3_Play_Win();
		}
		break;
	case AI_SECOND:	//AI white
		if(Player_Cur->color == BLACK) {
			MP3_Play_Win();
		}
		else if(Player_Cur->color == WHITE) {
			MP3_Play_Lose();
		}
		break;
	case H1_VS_H2:
		MP3_Play_Win();
		break;
	}
}
