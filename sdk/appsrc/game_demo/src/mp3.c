/*
 * mp3.c
 *
 *  Created on: 2018年12月4日
 *      Author: admin
 */
#include "mp3.h"
#include "xparameters.h"
#include "xuartps.h"
#include "xil_printf.h"
#include "sleep.h"

#define UARTPS1_DEVICE_ID                  XPAR_XUARTPS_1_DEVICE_ID
#define SEND_BUFFER_SIZE	10

static XUartPs Uart_Ps_1;		/* The instance of the UART Driver */

static u8 SendBuffer[SEND_BUFFER_SIZE];	/* Buffer for Transmitting Data */

int MP3_Uart_Init(void) {
	int Status;
	XUartPs_Config *Config;
	/*
	 * Initialize the UART driver so that it's ready to use
	 * Look up the configuration in the config table and then initialize it.
	 */
	Config = XUartPs_LookupConfig(UARTPS1_DEVICE_ID);
	if (NULL == Config) {
		return XST_FAILURE;
	}

	Status = XUartPs_CfgInitialize(&Uart_Ps_1, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XUartPs_SetBaudRate(&Uart_Ps_1, 9600);

	return XST_SUCCESS;
}

int MP3_Send_CMD(void) {
//	u8 i = 0;
	int SentCount = 0;
//	for(i = 0; i < SEND_BUFFER_SIZE; i++) {
//		XUartPs_Send(&Uart_Ps_1, &SendBuffer[i], 1);
//	}

	while (SentCount < SEND_BUFFER_SIZE) {
		/* Transmit the data */
		SentCount += XUartPs_Send(&Uart_Ps_1,
					   &SendBuffer[SentCount], 1);
	}

	usleep(50000);
	return SentCount;
}

//循环播放背景音乐
void MP3_Loop_Bgm(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x17;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x01;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xE3;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}

//调节音量到最大
void MP3_Set_Volume_Max(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x06;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x1E;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xD7;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}

//"ADVERT"文件夹，曲目为"0002"
//按键音
void MP3_Play_Btn(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x13;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x02;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xE6;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}

//"ADVERT"文件夹，曲目为"0003"
//赢棋声音
void MP3_Play_Win(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x13;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x03;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xE5;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}

//"ADVERT"文件夹，曲目为"0004"
//输棋声音
void MP3_Play_Lose(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x13;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x04;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xE4;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}


//"ADVERT"文件夹，曲目为"0005"
//下棋声音
void MP3_Play_chess(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x13;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x05;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xE3;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}

// 停止播放
void MP3_Pause(void) {
	SendBuffer[0] = 0x7E;
	SendBuffer[1] = 0xFF;
	SendBuffer[2] = 0x06;
	SendBuffer[3] = 0x16;
	SendBuffer[4] = 0x00;
	SendBuffer[5] = 0x00;
	SendBuffer[6] = 0x00;
	SendBuffer[7] = 0xFE;
	SendBuffer[8] = 0xE5;
	SendBuffer[9] = 0xEF;
	MP3_Send_CMD();
}

