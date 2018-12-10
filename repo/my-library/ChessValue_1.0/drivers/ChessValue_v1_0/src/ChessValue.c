

/***************************** Include Files *******************************/
#include "ChessValue.h"
#include <sleep.h>

/************************** Function Definitions ***************************/

/*
* The configuration table for devices
*/

ChessValue_Config ChessValue_ConfigTable[XPAR_CHESSVALUE_NUM_INSTANCES] =
{
	{
		XPAR_CHESSVALUE_0_DEVICE_ID,
		XPAR_CHESSVALUE_0_S_AXI_BASEADDR,
	}
};

ChessValue_Config *ChessValue_LookupConfig(u16 DeviceId)
{
	ChessValue_Config *CfgPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_CHESSVALUE_NUM_INSTANCES; Index++) {
		if (ChessValue_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &ChessValue_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}

int ChessValue_CfgInitialize(ChessValue * InstancePtr, ChessValue_Config * Config,
                        UINTPTR EffectiveAddr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Set some default values. */
	InstancePtr->BaseAddress = EffectiveAddr;

	ChessValue_Clr(InstancePtr);

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}

void ChessValue_Active(ChessValue * InstancePtr) {
	ChessValue_Clr(InstancePtr);
	CHESSVALUE_mWriteReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG0_OFFSET, 0x01);
	usleep(500);
	CHESSVALUE_mWriteReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG0_OFFSET, 0x00);
}

void ChessValue_Clr(ChessValue * InstancePtr) {
	CHESSVALUE_mWriteReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG0_OFFSET, 0x02);
	usleep(500);
	CHESSVALUE_mWriteReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG0_OFFSET, 0x00);
}

void ChessValue_GetSeat(ChessValue * InstancePtr, u8 *black_j, u8 *black_i, u8 *white_j, u8 *white_i) {
	u32 data_reg1;
	data_reg1= CHESSVALUE_mReadReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG1_OFFSET);
	*white_i = (u8)(data_reg1 & 0x0f);
	data_reg1 = data_reg1>>4;
	*white_j = (u8)(data_reg1 & 0x0f);
	data_reg1 = data_reg1>>4;
	*black_i = (u8)(data_reg1 & 0x0f);
	data_reg1 = data_reg1>>4;
	*black_j = (u8)(data_reg1 & 0x0f);
}

void ChessValue_GetValue(ChessValue * InstancePtr, u16 *black_value, u16 *white_value) {
	u32 data_reg2;
	data_reg2 = CHESSVALUE_mReadReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG2_OFFSET);
	*white_value = (u16)(data_reg2 & 0xffff);
	data_reg2 = data_reg2>>16;
	*black_value = (u16)(data_reg2 & 0xffff);
}

//0x02 is black win, 0x01 is white win
u8 ChessValue_CheckWin(ChessValue * InstancePtr, u8 *win_begin_j, u8 *win_begin_i, u8 *win_end_j, u8 *win_end_i) {
	u32 data_reg3;
	u8 win;
	data_reg3 = CHESSVALUE_mReadReg(InstancePtr->BaseAddress, CHESSVALUE_S_AXI_SLV_REG2_OFFSET);
	*win_end_i = (u8)(data_reg3 & 0x0000000f);

	data_reg3 = data_reg3 >> 4;
	*win_end_j = (u8)(data_reg3 & 0x0000000f);

	data_reg3 = data_reg3 >> 4;
	*win_begin_i = (u8)(data_reg3 & 0x0000000f);

	data_reg3 = data_reg3 >> 4;
	*win_begin_j = (u8)(data_reg3 & 0x0000000f);

	data_reg3 = data_reg3 >> 4;
	win = (u8)(data_reg3 & 0x00000003);

	return win;
}

