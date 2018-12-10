

/***************************** Include Files *******************************/
#include "Bluetooth_Pen.h"

Bluetooth_Pen_Config Bluetooth_Pen_ConfigTable[XPAR_BLUETOOTH_PEN_NUM_INSTANCES] =
{
	{
		XPAR_BLUETOOTH_PEN_0_DEVICE_ID,
		XPAR_BLUETOOTH_PEN_0_S_AXI_BASEADDR,
	},
	{
		XPAR_BLUETOOTH_PEN_1_DEVICE_ID,
		XPAR_BLUETOOTH_PEN_1_S_AXI_BASEADDR,
	}
};

Bluetooth_Pen_Config *Bluetooth_Pen_LookupConfig(u16 DeviceId)
{
	Bluetooth_Pen_Config *CfgPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_BLUETOOTH_PEN_NUM_INSTANCES; Index++) {
		if (Bluetooth_Pen_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &Bluetooth_Pen_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}

int Bluetooth_Pen_CfgInitialize(Bluetooth_Pen * InstancePtr, Bluetooth_Pen_Config * Config,
                        UINTPTR EffectiveAddr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Set some default values. */
	InstancePtr->BaseAddress = EffectiveAddr;

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}

// 获取鼠标指向的棋盘坐标
u8 Bluetooth_Pen_GetSeat(Bluetooth_Pen * InstancePtr, u8 *seat_x, u8 *seat_y) {
	u32 data_reg0;
	u8 value_choice;
	data_reg0 = BLUETOOTH_PEN_mReadReg(InstancePtr->BaseAddress, BLUETOOTH_PEN_S_AXI_SLV_REG0_OFFSET);
	*seat_x = (u8)(data_reg0 & 0x0f);	//slv_reg0[3:0]  棋盘x坐标
	data_reg0 = data_reg0 >> 4;
	*seat_y = (u8)(data_reg0 & 0x0f);	//slv_reg0[7:4]  棋盘y坐标
	data_reg0 = data_reg0 >> 8;
	value_choice  = (u8)(data_reg0 & 0x03);	//slv_reg0[13:12] 0 光标在空白区域， 1 光标在棋盘区域， 2 光标在第一屏的按钮区域， 3 光标在第二屏的按钮区域

	if (value_choice == 1)	//光标落在棋盘上
	{
		return 1;	//表示该次读取的棋盘坐标有效
	}
	else {					//光标在棋盘外
		return 0;	//表示该次读取的棋盘坐标无效
	}
}


// 获取屏幕上的按钮值
u8 Bluetooth_Pen_GetVgaBtn(Bluetooth_Pen * InstancePtr, u8 *VgaBtn) {
	u32 data_reg0;
	u8 value_choice;
	data_reg0 = BLUETOOTH_PEN_mReadReg(InstancePtr->BaseAddress, BLUETOOTH_PEN_S_AXI_SLV_REG0_OFFSET);
	data_reg0 = data_reg0 >> 8;
	*VgaBtn = (u8)(data_reg0 & 0x0f);	//slv_reg0[11:8]  屏幕上的按钮值： 0 无，1 player ai, 2 black, 3 ok, 4 undo, 5 restart, 6 tips, 7 棋盘
	data_reg0 = data_reg0 >> 4;
	value_choice = (u8)(data_reg0 & 0x03); //slv_reg0[13:12] 0 光标在空白区域， 1 光标在棋盘区域， 2 光标在第一屏的按钮区域， 3 光标在第二屏的按钮区域

	if ((*VgaBtn == 1) || (*VgaBtn == 2) || (*VgaBtn == 3)) //如果按键值是 1 2 3
	{
		if (value_choice == 2)								//判断光标是否在第一屏按钮区域
		{
			return 1;										//取值有效
		}
		else
		{
			return 0;										//反之无效
		}
	}
	else if ((*VgaBtn == 4) || (*VgaBtn == 5) || (*VgaBtn == 6))  //如果按键值是 4 5 6
	{
		if (value_choice == 3)								//判断光标是否在第2屏按钮区域
		{
			return 1;										//取值有效
		}
		else
		{
			return 0;										//反之无效
		}
	}
	else if (*VgaBtn == 7)
	{
		if (value_choice == 1)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else													//如果按键值12345都不是（是0）
	{
		if (value_choice == 0)								//判断光标不在任一屏按钮区域
		{
			return 1;										//取值有效
		}
		else
		{
			return 0;										//反之无效
		}
	}
	//一些逻辑, 参考 Bluetooth_Pen_GetSeat(Bluetooth_Pen * InstancePtr, u8 *seat_x, u8 *seat_y) 
}

// 获取蓝牙笔的按钮值
u8 Bluetooth_Pen_GetPenBtn(Bluetooth_Pen * InstancePtr) {
	u8 PenBtn;
	u32 data_reg0;
	data_reg0 = BLUETOOTH_PEN_mReadReg(InstancePtr->BaseAddress, BLUETOOTH_PEN_S_AXI_SLV_REG0_OFFSET);
	data_reg0 = data_reg0 >> 14;
	PenBtn = (u8)data_reg0;
	//一些逻辑, 直接返回按键值
	//slv_reg0[21:14]

	return PenBtn;
}

// 获取光标所在的区域
u8 Bluetooth_Pen_GetCursorZone(Bluetooth_Pen * InstancePtr) {
	u8 CursorZone;
	u32 data_reg0;
	data_reg0 = BLUETOOTH_PEN_mReadReg(InstancePtr->BaseAddress, BLUETOOTH_PEN_S_AXI_SLV_REG0_OFFSET);
	data_reg0 = data_reg0 >> 12;
	CursorZone = (u8)(data_reg0 & 0x03);

	return CursorZone;
}

// 获取reg0所有值
void Bluetooth_Pen_GetAll(Bluetooth_Pen * InstancePtr, u8 *seat_x, 
	u8 *seat_y, u8 *VgaBtn, u8 *PenBtn, u8 *CursorZone) {
	u32 data_reg0;
	data_reg0 = BLUETOOTH_PEN_mReadReg(InstancePtr->BaseAddress, BLUETOOTH_PEN_S_AXI_SLV_REG0_OFFSET);
	*seat_x = (u8)(data_reg0 & 0x0f);	//slv_reg0[3:0]  棋盘x坐标
	data_reg0 = data_reg0 >> 4;
	*seat_y = (u8)(data_reg0 & 0x0f);	//slv_reg0[7:4]  棋盘y坐标
	data_reg0 = data_reg0 >> 4;
	*VgaBtn = (u8)(data_reg0 & 0x0f);	//slv_reg0[11:8] vga按键值
	data_reg0 = data_reg0 >> 4;
	*CursorZone = (u8)(data_reg0 & 0x03);	
	//slv_reg0[13:12] 0 光标在空白区域， 1 光标在棋盘区域， 2 光标在第一屏的按钮区域， 3 光标在第二屏的按钮区域
	data_reg0 = data_reg0 >> 2;
	*PenBtn = (u8)(data_reg0 & 0xff);
}

/************************** Function Definitions ***************************/
