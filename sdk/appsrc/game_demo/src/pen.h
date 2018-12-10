/*
 * pen.h
 *
 *  Created on: 2018年11月18日
 *      Author: admin
 */

#ifndef SRC_PEN_H_
#define SRC_PEN_H_

#include "xil_types.h"
#include "Bluetooth_Pen.h"
#include "xscugic.h"		//中断控制器
#include "Xil_exception.h"
#include "game_base.h"
#include <stdbool.h>

#define BLUETOOTH_PEN_B_DEV_ID XPAR_BLUETOOTH_PEN_0_DEVICE_ID
#define BLUETOOTH_PEN_W_DEV_ID XPAR_BLUETOOTH_PEN_1_DEVICE_ID
#define BLUETOOTH_PEN_B_INTR_ID XPAR_FABRIC_BLUETOOTH_PEN_0_HOLD_TRICK_O_INTR
#define BLUETOOTH_PEN_W_INTR_ID XPAR_FABRIC_BLUETOOTH_PEN_1_HOLD_TRICK_O_INTR

typedef struct {
	bool pen_btn;
} _pen_flag;

typedef struct {
	Bluetooth_Pen Bluetooth;
	u8 color;					//执子颜色 BLACK or WHITE
	u8 x;
	u8 y;
	u8 vga_btn;
	u8 pen_btn;
	u8 pen_zone;
	_pen_flag flag;
} _pen;

//初始化蓝牙笔
void Pen_Init();

//初始化pen software
void Pen_Init_soft();

//初始化蓝牙笔中断
void Pen_Intr_Init(XScuGic *Intc_CfgPtr);

//黑笔中断服务函数
void Pen_B_IntrHandler(void *CallBackRef, int Bank, u32 Status);

//白笔中断服务函数
void Pen_W_IntrHandler(void *CallBackRef, int Bank, u32 Status);

//笔控制
void Pen_Ctrl(_pen *Pen_CfgPtr, u8 color_cur, u8 mode);

//笔控制 封装
void Pen_Ctrl_Two(u8 color_cur, u8 mode);

#endif /* SRC_PEN_H_ */
