/*
 * keyboard.c
 *
 *  Created on: 2018年11月19日
 *      Author: admin
 */

#include "keyboard.h"
#include "xstatus.h"

extern XGame Gobang;
static _keyboard Keyboard;

//初始化矩阵键盘
void Keyboard_Init() {
	int status;
	XKeyboard_Config *KeyboardCfg;
    KeyboardCfg = XKeyboard_LookupConfig(KEYBOARD_DEV_ID);
    status = XKeyboard_CfgInitialize(&(Keyboard.MXKboard), KeyboardCfg, KeyboardCfg->BaseAddress);
	xil_printf("init keyboard %d\r\n", status);
    if(status != XST_SUCCESS) {
    	xil_printf("init keyboard failed\r\n");
    }
    XKeyboard_Enable(&(Keyboard.MXKboard));
}

//初始化矩阵键盘中断
void Keyboard_Intr_Init(XScuGic *Intc_CfgPtr) {
	XScuGic_Connect(Intc_CfgPtr, KEYBOARD_INT_ID,
	                (Xil_ExceptionHandler)Keyboard_IntrHandler,
	                &(Keyboard.MXKboard));

	XScuGic_Enable(Intc_CfgPtr, KEYBOARD_INT_ID);
}


//矩阵键盘中断服务函数
void Keyboard_IntrHandler(void *CallBackRef, int Bank, u32 Status) {
//	u32 keyboard_data;
	Keyboard.flag.keyboard_btn = true;
	xil_printf("keyboard = %x\r\n",Keyboard.key_value); //just for test
}


//矩阵键盘控制
void Keyboard_Ctrl() {
	if(Keyboard.flag.keyboard_btn == true) {
		Keyboard.key_value = (u8)(XKeyboard_ReadData(&(Keyboard.MXKboard)));
		xil_printf("keyboard = %x\r\n",Keyboard.key_value); //just for test
		switch(Keyboard.key_value){
		case KEY_LAOZI:	//落子
			flag_laozi = true;
			break;
		case KEY_UP:
			if(Cursor.y == 0) {
				Cursor.y = 14;
			}
			else {
				Cursor.y--;
			}
			XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//修改光标位置
			break;
		case KEY_DOWN:
			if(Cursor.y == 14) {
				Cursor.y = 0;
			}
			else {
				Cursor.y++;
			}
			XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//修改光标位置
			break;
		case KEY_LEFT:
			if(Cursor.x == 0) {
				Cursor.x = 14;
			}
			else {
				Cursor.x--;
			}
			XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//修改光标位置
			break;
		case KEY_RIGHT:
			if(Cursor.x == 14) {
				Cursor.x = 0;
			}
			else {
				Cursor.x++;
			}
			XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);	//修改光标位置
			break;
		case KEY_CLRBOARD:	//清空棋盘
			flag_clr_board = true;
			break;
		case KEY_RETRACT:	//悔棋
			flag_retract = true;
			break;
		case KEY_GAMESTART:	//游戏开始
			flag_start_game = true;
			break;
		case KEY_CHANGE_PLAYER:	//游戏模式选择
			if(flag_game_over == true) {
				flag_mode_select = true;
				Mode = (Mode+1)%4;
			}
	//		xil_printf("Mode is %d\r\n",Mode);
			break;
		case KEY_HINT:	//提示
			if(flag_game_over == false) {
				flag_game_hint = true;
			}
			break;
		}
		Keyboard.flag.keyboard_btn = false;
	}
}

