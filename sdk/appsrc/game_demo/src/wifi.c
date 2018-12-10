/*
 * wifi.c
 *
 *  Created on: 2018年10月1日
 *      Author: admin
 */
#include "wifi.h"

static XUartLite UartWifi;

u8 flag_uartlite_recive = 0;
static u8 flag_uartlite_send = 0;
static bool flag_is_wifi = false;		//控制信号来自wifi，不要回传

static u8 SendBuffer[SEND_BUFFER_SIZE] = {0};
static u8 ReceiveBuffer[RECV_BUFFER_SEZE] = {0};

//UartWifi 初始化
void UartWifi_Init() {
	//初始化UartLite0(连接esp8266)
	XUartLite_Config *UartWifiCfg;
	UartWifiCfg = XUartLite_LookupConfig(UARTLITE_DEV_ID);
	XUartLite_CfgInitialize(&UartWifi,
			UartWifiCfg, UartWifiCfg->RegBaseAddr);
	//reset fifos
	XUartLite_ResetFifos(&UartWifi);
}

//UartWifi 中断初始化
void UartWifi_Intr_Init(XScuGic *Intc_CfgPtr) {
	//设置Uartlite中断函数
	XUartLite_SetSendHandler(&UartWifi, (XUartLite_Handler)UartSendHandler, &UartWifi);
	XUartLite_SetRecvHandler(&UartWifi, (XUartLite_Handler)UartRecvHandler, &UartWifi);
	//使能uart中断
	XUartLite_EnableInterrupt(&UartWifi);
	//Connect uartlite interrupt
	XScuGic_Connect(Intc_CfgPtr, UARTLITE_INTR_ID,
	                (Xil_ExceptionHandler)XUartLite_InterruptHandler,
	                &UartWifi);

	XUartLite_Recv(&UartWifi, ReceiveBuffer, RECV_BUFFER_SEZE);
}

//UartWifi 检查是否出错
void UartWifi_Check() {
	u32 data = 0;

	data = XUartLite_GetStatusReg(UartWifi.RegBaseAddress);

	if(data != 0x14) {
		xil_printf("time uart status = %x\r\n",data);	//just for test
	}

	if((data == 0x17)||(data == 0x37)||(data == 0x15)) {
		XUartLite_ResetFifos(&UartWifi);
	}
}

void UartSendHandler(void *CallBackRef, unsigned int EventData) {
	xil_printf("uart send data %d\r\n", EventData); //just for test
}

void UartRecvHandler(void *CallBackRef, unsigned int EventData) {
	xil_printf("uart receive event, eventdata = %d\r\n", EventData); //just for test
	if(EventData >= RECV_BUFFER_SEZE) {
		flag_uartlite_recive = true;
		flag_is_wifi = true;
	}
}

//接收 UART wifi 信息
void GetWifiData(u8 *seat_j, u8 *seat_i, u8 *color, u8 *ID) {
//	u8 *ReceiveBuffer_temp;
//	ReceiveBuffer_temp = ReceiveBuffer;
//	static u32 Status = 0;

	*ID = (ReceiveBuffer[1] - 48) + (ReceiveBuffer[0] - 48)*10;
	*color = (ReceiveBuffer[3] - 48) + (ReceiveBuffer[2] - 48)*10;
	*seat_j = (ReceiveBuffer[5] - 48) + (ReceiveBuffer[4] - 48)*10;
	*seat_i = (ReceiveBuffer[7] - 48) + (ReceiveBuffer[6] - 48)*10;

	if((ReceiveBuffer[RECV_BUFFER_SEZE - 1] != '$') ||
			(*ID < 0) || (*ID >16) ||
			(*color < 0) || (*color > 2) ||
			(*seat_j < 0) || (*seat_j > 14) ||
			(*seat_i < 0) || (*seat_i >14)) {
		xil_printf("get wifi data error!\r\n");
		SendWifiData(0x00, 0x00, 0x00, ID_RECV_ERROR);
		*ID = ID_RECV_ERROR;
	}

	//just for test
	xil_printf("get wifi data ");
	puts(ReceiveBuffer);
	xil_printf("\r\n");
	xil_printf("ID %d,color %d,seat_j %d,seat_i %d\r\n",
			*ID, *color, *seat_j, *seat_i);

	//wait for tx done
//	Status = XUartLite_GetStatusReg(UartWifi.RegBaseAddress);
//	while((Status & 0x04) != 0x04);

	//reset fifos
	XUartLite_ResetFifos(&UartWifi);

	//new receive
	XUartLite_Recv(&UartWifi, ReceiveBuffer, RECV_BUFFER_SEZE);
}

//发送WiFi信息
void SendWifiData(u8 seat_j, u8 seat_i, u8 color, u8 ID) {
	if(flag_is_wifi == false) {
		//reset fifos
		XUartLite_ResetFifos(&UartWifi);

		sprintf(SendBuffer, "%02d%02d%02d%02d$", ID, color, seat_j, seat_i);
		XUartLite_Send(&UartWifi, SendBuffer, SEND_BUFFER_SIZE);

		//just for test
		xil_printf("send to wifi data is ");
		puts(SendBuffer);
	}
	else {
		flag_is_wifi = false;
	}
}

//清空wifi标记位
void WifiClrFlag() {
	flag_is_wifi = false;
}

