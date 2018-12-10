

/***************************** Include Files *******************************/
#include "gobang.h"
#include "xparameters.h"

/************************** Function Definitions ***************************/

/*
* The configuration table for devices
*/

XGame_Config XGame_ConfigTable[XPAR_GOBANG_NUM_INSTANCES] =
{
	{
		XPAR_GOBANG_0_DEVICE_ID,
		XPAR_GOBANG_0_S_AXI_BASEADDR,
	}
};

XGame_Config *XGame_LookupConfig(u16 DeviceId)
{
	XGame_Config *CfgPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_GOBANG_NUM_INSTANCES; Index++) {
		if (XGame_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &XGame_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}

int XGame_CfgInitialize(XGame * InstancePtr, XGame_Config * Config,
                        UINTPTR EffectiveAddr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Set some default values. */
	InstancePtr->BaseAddress = EffectiveAddr;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, 0x0060);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, 0x0000);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET, 0x0000);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, 0x0028);

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}

void XGame_ClrBoard(XGame * InstancePtr) {
	u32 data;
	u32 data_read;
	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET);
	data = 0x0040 | (data_read & 0x003f);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, data);
	data = data_read & 0x003f;
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, data);
}

//0x00 both are AI, 0x01 white is player, 0x02 black is player, 0x03 both are player
void XGame_isPlayer(XGame * InstancePtr, u32 mask) {
	u32 data;
	u32 data_read;
	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET);
	data = ((mask & 0x0003) << 4) | (data_read & 0x004f);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, data);
}

//0x01 is running, 0x00 is stoped
void XGame_GameRun(XGame * InstancePtr, u32 mask) {
	u32 data;
	u32 data_read;
	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET);
	data = ((mask & 0x0001) << 3) | (data_read & 0x0077);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, data);
}

//0x01 is black, 0x02 is white
void XGame_CrtPlayer(XGame * InstancePtr, u32 mask) {
	u32 data;
	u32 data_read;
	mask++;
	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET);
	data = ((mask & 0x0001) << 2) | (data_read & 0x007b);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, data);
}

//0x02 is black win, 0x01 is white win
void XGame_Winner(XGame * InstancePtr, u32 mask) {
	u32 data;
	u32 data_read;
	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET);
	data = (mask & 0x0003) | (data_read & 0xfffc);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG1_OFFSET, data);
}

//落子 write_i/j 0x00 - 0x0f, write_color 0x01 is black, 0x02 is white
void XGame_PlayChess(XGame * InstancePtr, u32 write_i, u32 write_j, u32 write_color) {
	u32 data_reg2;
	u32 data_reg3;
	u32 data_reg3_read;

	write_color++;
	data_reg3_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET);

	data_reg3 = ((write_i & 0x000f) << 4) | (write_j & 0x000f) | (data_reg3_read & 0xFFFFFF00);
	data_reg2 = (write_color & 0x0001) & (~(0x0003 << 1));

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, data_reg2);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET, data_reg3);

	data_reg2 = (write_color & 0x0001) | (0x0001 << 2);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, data_reg2);

	data_reg2 = (write_color & 0x0001) & (~(0x0001 << 2));
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, data_reg2);
}

//悔棋 retract_i/j 0x00 - 0x0f, retract_color 0x01 is black, 0x02 is white
void XGame_RetractChess(XGame * InstancePtr, u32 retract_i, u32 retract_j, u32 retract_color) {
	u32 data_reg2;
	u32 data_reg3;
	u32 data_reg2_read;
	u32 data_reg3_read;

	retract_color++;

	data_reg2_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET);
	data_reg3_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET);

	data_reg3 = ((retract_i & 0x000f) << 4) | (retract_j & 0x000f) | (data_reg3_read & 0xFFFFFF00);
	data_reg2 = (retract_color & 0x0001) & (~(0x0003 << 1));

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, data_reg2);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET, data_reg3);

	data_reg2 = (retract_color & 0x0001) | (0x0001 << 1);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, data_reg2);

	data_reg2 = (retract_color & 0x0001) & (~(0x0001 << 1));
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG2_OFFSET, data_reg2);
}

//光标位置
void XGame_CursorCoord(XGame * InstancePtr, u32 cursor_i, u32 cursor_j) {
	u32 data;
	u32 data_read;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET);

	data = ((cursor_i & 0x000f) << 20) | ((cursor_j & 0x000f) << 16) | (data_read & 0x00ff);
	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG3_OFFSET, data);
}

//标记5枚连成线的棋子
void XGame_MarkFivepPiece(XGame * InstancePtr, u32 first_row, u32 first_col, u32 last_row, u32 last_col)
{
	u32 data;
	u32 data_read;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET);
	data_read = data_read & 0xfffe0000;
	data = 0x00010000 | (first_row << 12) | (first_col << 8) | (last_row << 4) | last_col;
	data = data | data_read;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET, data);
}

//取消标记
void XGame_UnMark(XGame * InstancePtr)
{
	u32 data;
	u32 data_read;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET);
	data = data_read & 0xfffe0000;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET, data);
}

//显示开始页面
void XGame_StartPage(XGame * InstancePtr, u32 StartPage_en)
{
	u32 data_read;
	u32 data;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET);
	data_read = data_read & 0xfff7ffff;
	data = (StartPage_en << 19);
	data = data | data_read;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET, data);
}

//显示方框
void XGame_SquareDisplay(XGame * InstancePtr,u32 squaredisplay)
{
	u32 data_read;
	u32 data;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET);
	data_read = data_read & 0xffcfffff;
	data = squaredisplay << 20;
	data = data | data_read;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET, data);
}

//point the undo or point the restart
//0 不指向按钮，1 指向悔棋按钮, 2 指向提示按钮, 3 指向重启按钮
void XGame_PointBtn(XGame * InstancePtr,u32 point_btn)
{
	u32 data_read;
	u32 data;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET);
	data_read = data_read & 0xff3fffff;
	data = point_btn << 22;
	data = data | data_read;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET, data);
}

// choice the cursor shape
void XGame_CursorShape(XGame * InstancePtr,u32 cursor_shape)
{
	u32 data_read;
	u32 data;

	data_read = GOBANG_mReadReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET);
	data_read = data_read & 0xfcffffff;
	data = cursor_shape << 24;
	data = data | data_read;

	GOBANG_mWriteReg(InstancePtr->BaseAddress, GOBANG_S_AXI_SLV_REG0_OFFSET, data);
}
