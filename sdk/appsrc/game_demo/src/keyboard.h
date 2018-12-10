/*
 * keyboard.h
 *
 *  Created on: 2018年11月19日
 *      Author: admin
 */

#ifndef SRC_KEYBOARD_H_
#define SRC_KEYBOARD_H_

#include "matrix_keyboard.h"
#include "xscugic.h"		//中断控制器
#include "Xil_exception.h"
#include "xparameters.h"
#include "game_base.h"
#include "gobang.h"
#include <stdbool.h>

#define KEYBOARD_DEV_ID XPAR_MATRIX_KEYBOARD_0_DEVICE_ID
#define KEYBOARD_INT_ID XPAR_FABRIC_MATRIX_KEYBOARD_0_HOLD_TRICK_O_INTR

#define KEY_UP 1
#define KEY_DOWN 9
#define KEY_RIGHT 4
#define KEY_LEFT 6
#define KEY_LAOZI 5
#define KEY_CLRBOARD 0x0F
#define KEY_RETRACT 0x0C
#define KEY_GAMESTART 0x03
#define KEY_CHANGE_PLAYER 0x07
#define KEY_HINT	0x0B

typedef struct {
	bool keyboard_btn;
} _keyboard_flag;

typedef struct {
	u8 key_value;
	_keyboard_flag flag;
	XKeyboard MXKboard;
} _keyboard;

//extern _keyboard Keyboard;

//初始化矩阵键盘
void Keyboard_Init();

//初始化矩阵键盘中断
void Keyboard_Intr_Init(XScuGic *Intc_CfgPtr);

//矩阵键盘中断服务函数
void Keyboard_IntrHandler(void *CallBackRef, int Bank, u32 Status);

//矩阵键盘控制
void Keyboard_Ctrl();

#endif /* SRC_KEYBOARD_H_ */
