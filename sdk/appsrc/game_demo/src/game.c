/*
 * game.c
 *
 *  Created on: 2018��9��30��
 *      Author: admin
 */

#include "game.h"
#include "game_base.h"
#include "pen.h"
#include "keyboard.h"
#include "mp3.h"

void Play_Game(void) {
	u8 first_x, first_y, last_x, last_y = 0;
	u8 pen_color_cur = 0;

	//WIFI接收到数据控制
	if(flag_uartlite_recive == 1) {
		Game_CtrlbyWiFi();
		flag_uartlite_recive = 0;
	}

	//笔控制
	Pen_Ctrl_Two(Player_Cur->color, Mode);

	//键盘控制
	Keyboard_Ctrl();


	if(flag_game_over == false) {	//游戏进行中
		if(Is_AI_or_Human(Player_Cur) == true) {	//AI下棋
			if(Game_AI_Choice()){
				Game_Laozi();
				//检查输赢
				if(Game_CheckWin(&first_x, &first_y, &last_x, &last_y)) {
					xil_printf("five in line y%d,x%d,y%d,x%d\r\n",first_x, first_y, last_x, last_y);
					if(Player_Cur->color == BLACK) {
						XGame_Winner(&Gobang, BLACK_WIN);
						SendWifiData(0, 0, BLACK, ID_WIN);
					}
					else {
						XGame_Winner(&Gobang, WHITE_WIN);
						SendWifiData(0, 0, WHITE, ID_WIN);
					}
					XGame_MarkFivepPiece(&Gobang, first_y, first_x, last_y, last_x);
					Game_end_music();
					flag_game_over = true;
				}
				Game_Change_PlayerCur();
			}
		}
		else {	//人类下棋
			if(flag_game_hint == true) {	//提示
				bool hint_done = Game_Hint();
				if(hint_done) {
					flag_game_hint = false;
				}
			}
			if(flag_laozi == true) {	//落子
				if(board[Cursor.y][Cursor.x] == NO_GHESS) {
					Game_MAN_Choice();
					Game_Laozi();
					//检查输赢
					if(Game_CheckWin(&first_x, &first_y, &last_x, &last_y)) {
						xil_printf("five in line y%d,x%d,y%d,x%d\r\n",first_y, first_x, last_y, last_x);
						if(Player_Cur->color == BLACK) {
							XGame_Winner(&Gobang, BLACK_WIN);
							SendWifiData(0, 0, BLACK, ID_WIN);
						}
						else {
							XGame_Winner(&Gobang, WHITE_WIN);
							SendWifiData(0, 0, WHITE, ID_WIN);
						}
						XGame_MarkFivepPiece(&Gobang, first_y, first_x, last_y, last_x);
						Game_end_music();
						flag_game_over = true;
					}
					//修改玩家
					Game_Change_PlayerCur();
				}
				flag_laozi = false;
			}
			else if(flag_retract == true) {	//悔棋
				Game_Retract();
				flag_retract = false;
			}
		}
	}
	else {	//ֹ游戏未进行
		if(flag_mode_select == true){	//模式选择
			Game_ModeSelect();
			flag_mode_select = false;
		}
		else if(flag_start_game == true){	//开始游戏
			flag_game_over = false;
			XGame_StartPage(&Gobang, flag_game_over);
			SendWifiData(0, 0, 0, ID_START_GAME);
			flag_start_game = false;
		}
	}

	if(flag_clr_board == true) {	//清空棋盘
		Game_Restart();
		flag_clr_board = false;
	}

	if(flag_mute_btn == true) {	//静音按钮
		flag_mute_btn = false;
		flag_mute = !flag_mute;

		if(flag_mute == true) {
			MP3_Pause();
		}
		else {
			MP3_Loop_Bgm();
		}

		XGame_SoundOnOff(&Gobang, !flag_mute);
	}

}
