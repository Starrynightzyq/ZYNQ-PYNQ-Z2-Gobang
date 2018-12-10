/*
 * wifi.h
 *
 *  Created on: 2018年10月1日
 *      Author: admin
 */

#ifndef SRC_WIFI_H_
#define SRC_WIFI_H_

#include "xil_types.h"
#include "xuartlite.h"
#include "xscugic.h"		//中断控制器
#include "xil_printf.h"
#include "stdio.h"
#include <stdbool.h>

#include "xuartlite_l.h"

#define UARTLITE_DEV_ID XPAR_UARTLITE_0_DEVICE_ID
#define UARTLITE_INTR_ID XPAR_FABRIC_AXI_UARTLITE_0_HOLD_TRICK_O_INTR

# define SEND_BUFFER_SIZE        9
# define RECV_BUFFER_SEZE        9

//ID状态
# define ID_PVA_EASY 	1	//人机简单
# define ID_PVA_GENERAL 2 	//人机一般
# define ID_PVA_HARD 	3	//人机困难
# define ID_PVP			4	//人人
# define ID_AVA			5	//AI VS AI
# define ID_LAOZI 		6	//下棋
# define ID_RETRACT		7	//悔棋
# define ID_WIN 		8	//获胜
# define ID_RESTART		9	//清空棋盘（再来一局）
# define ID_START_GAME  10	//开始游戏
# define ID_RECV_ERROR 	11	//接收错误
# define ID_HINT		12	//提示

//extern XUartLite UartWifi;

extern u8 flag_uartlite_recive;

//UartWifi 初始化
void UartWifi_Init();

//UartWifi 中断初始化
void UartWifi_Intr_Init(XScuGic *Intc_CfgPtr);

//UartWifi 检查是否出错
void UartWifi_Check();

//uartlite 中断函数
void UartSendHandler(void *CallBackRef, unsigned int EventData);
void UartRecvHandler(void *CallBackRef, unsigned int EventData);

//接收 UART wifi 信息
void GetWifiData(u8 *seat_j, u8 *seat_i, u8 *color, u8 *ID);

//发送WiFi信息
void SendWifiData(u8 seat_j, u8 seat_i, u8 color, u8 ID);

//清空wifi标记位
void WifiClrFlag();

#endif /* SRC_WIFI_H_ */
