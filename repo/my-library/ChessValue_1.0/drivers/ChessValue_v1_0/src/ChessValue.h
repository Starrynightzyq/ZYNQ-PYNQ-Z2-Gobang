
#ifndef CHESSVALUE_H
#define CHESSVALUE_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"
#include "xparameters.h"

#define CHESSVALUE_S_AXI_SLV_REG0_OFFSET 0
#define CHESSVALUE_S_AXI_SLV_REG1_OFFSET 4
#define CHESSVALUE_S_AXI_SLV_REG2_OFFSET 8
#define CHESSVALUE_S_AXI_SLV_REG3_OFFSET 12


/**************************** Type Definitions *****************************/
/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/* Unique ID  of device */
	UINTPTR BaseAddress;	/* Device base address */
} ChessValue_Config;

/**
 */
typedef struct {
	UINTPTR BaseAddress;	/* Device base address */
	u32 IsReady;		/* Device is initialized and ready */
} ChessValue;
/**
 *
 * Write a value to a CHESSVALUE register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the CHESSVALUEdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void CHESSVALUE_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define CHESSVALUE_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a CHESSVALUE register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the CHESSVALUE device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 CHESSVALUE_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define CHESSVALUE_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))

/************************** Function Prototypes ****************************/
/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the CHESSVALUE instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus CHESSVALUE_Reg_SelfTest(void * baseaddr_p);

ChessValue_Config *ChessValue_LookupConfig(u16 DeviceId);

int ChessValue_CfgInitialize(ChessValue * InstancePtr, ChessValue_Config * Config,
                        UINTPTR EffectiveAddr);

void ChessValue_Active(ChessValue * InstancePtr);

void ChessValue_Clr(ChessValue * InstancePtr);

void ChessValue_GetSeat(ChessValue * InstancePtr, u8 *black_j, u8 *black_i, u8 *white_j, u8 *white_i);

void ChessValue_GetValue(ChessValue * InstancePtr, u16 *black_value, u16 *white_value);

//0x02 is black win, 0x01 is white win
u8 ChessValue_CheckWin(ChessValue * InstancePtr, u8 *win_begin_j, u8 *win_begin_i, u8 *win_end_j, u8 *win_end_i);

#endif // CHESSVALUE_H
