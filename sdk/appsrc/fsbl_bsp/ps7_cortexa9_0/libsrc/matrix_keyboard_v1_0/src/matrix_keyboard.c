

/***************************** Include Files *******************************/
#include "matrix_keyboard.h"

/************************** Function Definitions ***************************/

/*
* The configuration table for devices
*/

XKeyboard_Config XKeyboard_ConfigTable[XPAR_MATRIX_KEYBOARD_NUM_INSTANCES] =
{
	{
		XPAR_MATRIX_KEYBOARD_0_DEVICE_ID,
		XPAR_MATRIX_KEYBOARD_0_S_AXI_BASEADDR,
	}
};

XKeyboard_Config *XKeyboard_LookupConfig(u16 DeviceId)
{
	XKeyboard_Config *CfgPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_GOBANG_NUM_INSTANCES; Index++) {
		if (XKeyboard_ConfigTable[Index].DeviceId == DeviceId) {
			CfgPtr = &XKeyboard_ConfigTable[Index];
			break;
		}
	}

	return CfgPtr;
}

int XKeyboard_CfgInitialize(XKeyboard * InstancePtr, XKeyboard_Config * Config,
                            UINTPTR EffectiveAddr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Set some default values. */
	InstancePtr->BaseAddress = EffectiveAddr;

	MATRIX_KEYBOARD_mWriteReg(InstancePtr->BaseAddress, MATRIX_KEYBOARD_S_AXI_SLV_REG0_OFFSET, 0x0000);

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}

void XKeyboard_Enable(XKeyboard * InstancePtr) {
	MATRIX_KEYBOARD_mWriteReg(InstancePtr->BaseAddress, MATRIX_KEYBOARD_S_AXI_SLV_REG0_OFFSET, 0xFFFF);
}

void XKeyboard_Disable(XKeyboard * InstancePtr) {
	MATRIX_KEYBOARD_mWriteReg(InstancePtr->BaseAddress, MATRIX_KEYBOARD_S_AXI_SLV_REG0_OFFSET, 0x0000);
}

u32 XKeyboard_ReadData(XKeyboard * InstancePtr) {
	u32 Data_reg1;
	Data_reg1 = MATRIX_KEYBOARD_mReadReg(InstancePtr->BaseAddress, MATRIX_KEYBOARD_S_AXI_SLV_REG1_OFFSET);
	return Data_reg1;
}