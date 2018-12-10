/*
 * pen.c
 *
 *  Created on: 2018年11月18日
 *      Author: admin
 */

#include "pen.h"
#include "gobang.h"
#include "mp3.h"

static _pen Pen_B;	//黑棋笔
static _pen Pen_W;	//白棋笔

extern XGame Gobang;

static u8 Cursor_Shape = 0;

//初始化蓝牙笔
void Pen_Init() {
	Bluetooth_Pen_Config *Bluetooth_Pen_Cfg;
	Bluetooth_Pen_Cfg = Bluetooth_Pen_LookupConfig(BLUETOOTH_PEN_B_DEV_ID);
	Bluetooth_Pen_CfgInitialize(&(Pen_B.Bluetooth), Bluetooth_Pen_Cfg,
			Bluetooth_Pen_Cfg->BaseAddress);
	Bluetooth_Pen_Cfg = Bluetooth_Pen_LookupConfig(BLUETOOTH_PEN_W_DEV_ID);
	Bluetooth_Pen_CfgInitialize(&(Pen_W.Bluetooth), Bluetooth_Pen_Cfg,
			Bluetooth_Pen_Cfg->BaseAddress);
	Pen_Init_soft();
}

//初始化pen software
void Pen_Init_soft() {
	Pen_B.color = 1;	//黑色
	Pen_W.color = 2;	//白色
}

//初始化蓝牙笔中断
void Pen_Intr_Init(XScuGic *Intc_CfgPtr) {
	//Connect pens interrupt
	XScuGic_Connect(Intc_CfgPtr, BLUETOOTH_PEN_B_INTR_ID,
	                (Xil_ExceptionHandler)Pen_B_IntrHandler,
	                &(Pen_B.Bluetooth));
	XScuGic_Connect(Intc_CfgPtr, BLUETOOTH_PEN_W_INTR_ID,
	                (Xil_ExceptionHandler)Pen_W_IntrHandler,
	                &(Pen_W.Bluetooth));
	//Enable interrupts
	XScuGic_Enable(Intc_CfgPtr, BLUETOOTH_PEN_B_INTR_ID);
	XScuGic_Enable(Intc_CfgPtr, BLUETOOTH_PEN_W_INTR_ID);
}

//黑笔中断服务函数
void Pen_B_IntrHandler(void *CallBackRef, int Bank, u32 Status) {
	Bluetooth_Pen *Pen_InstancePtr = (Bluetooth_Pen *) CallBackRef;
//	Pen_B.pen_btn = Bluetooth_Pen_GetPenBtn(&(Pen_B.Bluetooth));
	Bluetooth_Pen_GetAll(&(Pen_B.Bluetooth), &(Pen_B.y), &(Pen_B.x), &(Pen_B.vga_btn), &(Pen_B.pen_btn), &(Pen_B.pen_zone));
	/*读取函数要放在中断里读取，否则会多次读取*/
	Pen_B.flag.pen_btn = true;
//	xil_printf("Bluetooth Pen Black Event\r\n");
}

//白笔中断服务函数
void Pen_W_IntrHandler(void *CallBackRef, int Bank, u32 Status) {
	Bluetooth_Pen *Pen_InstancePtr = (Bluetooth_Pen *) CallBackRef;
//	Pen_W.pen_btn = Bluetooth_Pen_GetPenBtn(&(Pen_W.Bluetooth));
	Bluetooth_Pen_GetAll(&(Pen_W.Bluetooth), &(Pen_W.y), &(Pen_W.x), &(Pen_W.vga_btn), &(Pen_W.pen_btn), &(Pen_W.pen_zone));
	Pen_W.flag.pen_btn = true;
//	xil_printf("Bluetooth Pen White Event\r\n");
}

//笔控制
void Pen_Ctrl(_pen *Pen_CfgPtr, u8 color_cur, u8 mode) {
//	Bluetooth_Pen_GetAll(&(Pen_CfgPtr->Bluetooth), &(Pen_CfgPtr->y), &(Pen_CfgPtr->x), &(Pen_CfgPtr->vga_btn), &(Pen_CfgPtr->pen_btn), &(Pen_CfgPtr->pen_zone));
	xil_printf("vga_btn:%d ",Pen_CfgPtr->vga_btn);
	xil_printf("pen_btn:%d\r\n", Pen_CfgPtr->pen_btn);
	switch(Pen_CfgPtr->vga_btn) {
	case PLAYER_BTN:{
		if((Pen_CfgPtr->pen_btn == RIGHT_CLICK) && (flag_game_over == true)) {
			flag_mode_select = true;
			Mode = (Mode+1)%4;
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case COLOR_BTN:{
		if((Pen_CfgPtr->pen_btn == RIGHT_CLICK) && (flag_game_over == true)) {
			flag_mode_select = true;
			if(Mode == AI_FIRST) {
				Mode = AI_SECOND;
			}
			else if(Mode == AI_SECOND) {
				Mode = AI_FIRST;
			}
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case OK_BTN:{
		if((Pen_CfgPtr->pen_btn == RIGHT_CLICK) && (flag_game_over == true)) {
			flag_start_game = true;
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case UNDO_BTN:{
		if((Pen_CfgPtr->pen_btn == RIGHT_CLICK) && (flag_game_over == false)) {
			flag_retract = true;
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case RESTART_BTN:{
		if(Pen_CfgPtr->pen_btn == RIGHT_CLICK) {
			flag_clr_board = true;
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case BOARD_BTN:{
		if((Pen_CfgPtr->pen_btn == RIGHT_CLICK) && (flag_game_over == false)) {
			if(mode == 3) {	/*人人对战*/
				if(color_cur == Pen_CfgPtr->color) {
					flag_laozi = true;
					Cursor.y = Pen_CfgPtr->y - 1;
					Cursor.x = Pen_CfgPtr->x - 1;
					XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);
				}
			}
			else {
				flag_laozi = true;
				Cursor.y = Pen_CfgPtr->y - 1;
				Cursor.x = Pen_CfgPtr->x - 1;
				XGame_CursorCoord(&Gobang, Cursor.y, Cursor.x);
			}
		}
		break;
	}
	case HINT_BTN:{
		if((Pen_CfgPtr->pen_btn == RIGHT_CLICK) && (flag_game_over == false)) {
			flag_game_hint = true;
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case MUTE_BTN:{
		if(Pen_CfgPtr->pen_btn == RIGHT_CLICK) {
			flag_mute_btn = true;
		}
		//播放音效
		if(flag_mute == false) {
			MP3_Play_Btn();
		}
		break;
	}
	case NO_BTN:{
		if(Pen_CfgPtr->pen_btn == LEFT_DUE_CLICK) {
			Cursor_Shape = (Cursor_Shape+1)%3;
			XGame_CursorShape(&Gobang, Cursor_Shape);	//修改鼠标形状
		}
		break;
	}
	}

//	//播放音效
//	if(flag_mute == false) {
//		MP3_Play_Btn();
//	}
}

//笔控制 封装
void Pen_Ctrl_Two(u8 color_cur, u8 mode) {
	if(Pen_B.flag.pen_btn == true) {
		Pen_Ctrl(&Pen_B, color_cur, mode);
		Pen_B.flag.pen_btn = false;
	}
	else if(Pen_W.flag.pen_btn == true) {
		Pen_Ctrl(&Pen_W, color_cur, mode);
		Pen_W.flag.pen_btn = false;
	}
}

