/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
//#include "matrix_keyboard.h"
#include "sleep.h"
#include "xscutimer.h"
#include "xgpio.h"
#include "xscugic.h"		//中断控制器
#include "Xil_exception.h"
#include "xstatus.h"
#include "gobang.h"
#include "ChessValue.h"
#include "game.h"
#include "game_base.h"
//#include "game_controller.h"
#include "xuartlite.h"
#include "xuartlite_l.h"
#include "wifi.h"
#include "Bluetooth_Pen.h"
#include "pen.h"
#include "keyboard.h"
#include "mp3.h"
#include <stdbool.h>

#define TIMER_DEV_ID	XPAR_XSCUTIMER_0_DEVICE_ID
#define GPIO_DEV_ID		XPAR_GPIO_0_DEVICE_ID
#define INTC_DEV_ID		XPAR_SCUGIC_SINGLE_DEVICE_ID
#define GOBANG_DEV_ID 	XPAR_GOBANG_0_DEVICE_ID
#define CHESSVALUE_DEV_ID XPAR_CHESSVALUE_0_DEVICE_ID

#define TIMER_INTR_ID	XPAR_SCUTIMER_INTR
#define GPIO_INTR_ID	XPAR_FABRIC_GPIO_0_VEC_ID
#define CHESSVALUE_INTR_ID XPAR_FABRIC_CHESSVALUE_0_HOLD_TRICK_O_INTR

#define TIMER_LOAD_VALUE	0x4FFFFFFF
#define CHANNEL_LEDS		1
#define CHANNEL_BTNS		2


u8 player_data = 0;

XScuTimer Timer;
XGpio Gpio;
XScuGic Intc;
XGame Gobang;
ChessValue GameValue;


void init(void);
void Timer_IntrHandler(void *CallBackRef);
void Gpio_IntrHandler(void *CallBackRef);
void ChessValue_IntrHandler(void *ChessValue);

int main()
{
	u32 data;
    init_platform();

    print("Hello World\n\r");

    init();

	//接收
//	XUartLite_Recv(&UartWifi, ReceiveBuffer, RECV_BUFFER_SEZE);
//    GetWifiData();
	//send
//	SendWifiData(0x00,0x00,0x00,0x00);
//	initHASH();
//	BoardInit(AI_SECOND);
//	flag_game_over = false;
	Game_Init();
	xil_printf("start loop\r\n");
    while(1) {
    	Play_Game();
//    	Game_Loop();
    }

    cleanup_platform();
    return 0;
}

void init(void) {
	int Status;
	//初始化矩阵键盘
	Keyboard_Init();

	//初始化UartWifi，连接wifi
	UartWifi_Init();

	//初始化uart MP3
	MP3_Uart_Init();

    //初始化 PS Timer
    XScuTimer_Config *TimerCfg;
    TimerCfg = XScuTimer_LookupConfig(TIMER_DEV_ID);
    XScuTimer_CfgInitialize(&Timer, TimerCfg, TimerCfg->BaseAddr);
    //Load Timer
    XScuTimer_LoadTimer(&Timer, TIMER_LOAD_VALUE);
    XScuTimer_EnableAutoReload(&Timer);
	//start timer
	XScuTimer_Start(&Timer);
	//enable interrupt on the timer
	XScuTimer_EnableInterrupt(&Timer);

	//初始化 PL GPIO
	XGpio_Config *GpioCfg;
	GpioCfg = XGpio_LookupConfig(GPIO_DEV_ID);
	XGpio_CfgInitialize(&Gpio, GpioCfg, GpioCfg->BaseAddress);
	XGpio_SetDataDirection(&Gpio, CHANNEL_LEDS, 0x0000);
	XGpio_SetDataDirection(&Gpio, CHANNEL_BTNS, 0xFFFF);
	//gpio interrupt
	XGpio_InterruptGlobalEnable(&Gpio);
	XGpio_InterruptEnable(&Gpio, XGPIO_IR_CH2_MASK);
	XGpio_InterruptDisable(&Gpio, XGPIO_IR_CH1_MASK);

	//初始化五子棋模块
	XGame_Config *GobangCfg;
	GobangCfg = XGame_LookupConfig(GOBANG_DEV_ID);
	XGame_CfgInitialize(&Gobang, GobangCfg,
			GobangCfg->BaseAddress);
//	Game_Restart();	//此处不能执行，因为需要使用uart中断发送，而中断控制器还没初始化好

	//初始化评分模块
	ChessValue_Config *ChessValueCfg;
	ChessValueCfg = ChessValue_LookupConfig(CHESSVALUE_DEV_ID);
	ChessValue_CfgInitialize(&GameValue, ChessValueCfg, ChessValueCfg->BaseAddress);

	//初始化蓝牙笔模块
	Pen_Init();

    //初始化中断
    XScuGic_Config *IntcCfg;
    IntcCfg = XScuGic_LookupConfig(INTC_DEV_ID);
	XScuGic_CfgInitialize(&Intc, IntcCfg, IntcCfg->CpuBaseAddress);

	//Connect timer interrupt
	XScuGic_Connect(&Intc, TIMER_INTR_ID,
	                (Xil_ExceptionHandler)Timer_IntrHandler,
	                &Timer);
	//Connect gpio interrupt
	XScuGic_Connect(&Intc, GPIO_INTR_ID,
	                (Xil_ExceptionHandler)Gpio_IntrHandler,
	                &Gpio);
	//Connect ChessValue interrupt
	XScuGic_Connect(&Intc, CHESSVALUE_INTR_ID,
	                (Xil_ExceptionHandler)ChessValue_IntrHandler,
	                &GameValue);
	//初始化蓝牙笔中断
	Pen_Intr_Init(&Intc);
	//Connect keyboard interrupt
	Keyboard_Intr_Init(&Intc);
	//初始化UartWifi中断
	UartWifi_Intr_Init(&Intc);

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
	                             (Xil_ExceptionHandler)XScuGic_InterruptHandler,
								 &Intc);

	XScuGic_Enable(&Intc, TIMER_INTR_ID);
//	XScuGic_Disable(&Intc, TIMER_INTR_ID);

//	XScuGic_Enable(&Intc, GPIO_INTR_ID);
	XScuGic_Disable(&Intc, GPIO_INTR_ID);

	XScuGic_Enable(&Intc, UARTLITE_INTR_ID);
	XScuGic_Enable(&Intc, CHESSVALUE_INTR_ID);

	Xil_ExceptionEnableMask(XIL_EXCEPTION_ALL);
}

void Timer_IntrHandler(void *CallBackRef)
{
	XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
	XScuTimer_ClearInterruptStatus(TimerInstancePtr);
//	printf("****Timer Event!!!!!!!!!!!!!****\n\r");

	//检查UartLite是否出错，如果出错，reset
	UartWifi_Check();

//	xil_printf("cur_color = %d, game_over = %d, cur_chess = %d,mode = %d\r\n",Player_Cur->color, flag_game_over, Player_Cur->chess_type,Mode);

//	puts(ReceiveBuffer);
}

void Gpio_IntrHandler(void *CallBackRef) {
	XGpio *GpioInstancePtr = (XGpio *)CallBackRef;
	XGpio_InterruptClear(GpioInstancePtr, XGPIO_IR_CH2_MASK);
	xil_printf("****GPIO Event!!!!!!!!!!!!!****\n\r");
}

void ChessValue_IntrHandler(void *ChessValue) {
	xil_printf("****ChessValue Event!!!!!!!!!!!!!****\n\r");
	flag_value_intr = true;
}
