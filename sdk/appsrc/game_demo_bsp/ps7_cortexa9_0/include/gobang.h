
#ifndef GOBANG_H
#define GOBANG_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"

#define GOBANG_S_AXI_SLV_REG0_OFFSET 0
#define GOBANG_S_AXI_SLV_REG1_OFFSET 4
#define GOBANG_S_AXI_SLV_REG2_OFFSET 8
#define GOBANG_S_AXI_SLV_REG3_OFFSET 12


/**************************** Type Definitions *****************************/
/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/* Unique ID  of device */
	UINTPTR BaseAddress;	/* Device base address */
} XGame_Config;

/**
 */
typedef struct {
	UINTPTR BaseAddress;	/* Device base address */
	u32 IsReady;		/* Device is initialized and ready */
} XGame;
/**
 *
 * Write a value to a GOBANG register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the GOBANGdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void GOBANG_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define GOBANG_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a GOBANG register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the GOBANG device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 GOBANG_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define GOBANG_mReadReg(BaseAddress, RegOffset) \
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
 * @param   baseaddr_p is the base address of the GOBANG instance to be worked on.
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
XStatus GOBANG_Reg_SelfTest(void * baseaddr_p);
XGame_Config *XGame_LookupConfig(u16 DeviceId);
int XGame_CfgInitialize(XGame * InstancePtr, XGame_Config * Config,
                        UINTPTR EffectiveAddr);

void XGame_ClrBoard(XGame * InstancePtr);

void XGame_isPlayer(XGame * InstancePtr, u32 mask);

//0x01 is running, 0x00 is stoped
void XGame_GameRun(XGame * InstancePtr, u32 mask);

//0x01 is white, 0x00 is black
void XGame_CrtPlayer(XGame * InstancePtr, u32 mask);

//0x02 is black win, 0x01 is white win
void XGame_Winner(XGame * InstancePtr, u32 mask);

// play chess, write_i/j 0x00 - 0x0f, write_color 0x01 is white, 0x00 is black
void XGame_PlayChess(XGame * InstancePtr, u32 write_i, u32 write_j, u32 write_color);

// retract, retract_i/j 0x00 - 0x0f, retract_color 0x01 is white, 0x00 is black
void XGame_RetractChess(XGame * InstancePtr, u32 retract_i, u32 retract_j, u32 retract_color);

// show the cursor coords
void XGame_CursorCoord(XGame * InstancePtr, u32 cursor_i, u32 cursor_j);

//标记5枚连成线的棋子
void XGame_MarkFivepPiece(XGame * InstancePtr, u32 first_row, u32 first_col, u32 last_row, u32 last_col);

//取消标记
void XGame_UnMark(XGame * InstancePtr);

//显示开始页面
void XGame_StartPage(XGame * InstancePtr, u32 StartPage_en);



// choice the cursor shape
void XGame_CursorShape(XGame * InstancePtr,u32 cursor_shape);

void XGame_SoundOnOff(XGame * InstancePtr,u32 sound_onoff);

#endif // GOBANG_H
