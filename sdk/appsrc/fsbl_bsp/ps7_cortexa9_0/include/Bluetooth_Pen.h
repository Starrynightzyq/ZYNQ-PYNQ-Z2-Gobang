
#ifndef BLUETOOTH_PEN_H
#define BLUETOOTH_PEN_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xil_io.h"

#define BLUETOOTH_PEN_S_AXI_SLV_REG0_OFFSET 0
#define BLUETOOTH_PEN_S_AXI_SLV_REG1_OFFSET 4
#define BLUETOOTH_PEN_S_AXI_SLV_REG2_OFFSET 8
#define BLUETOOTH_PEN_S_AXI_SLV_REG3_OFFSET 12

enum click_type {
	NO_CLICK = 0, LEFT_CLICK = 1, LEFT_DUE_CLICK = 2, LEFT_LONG_CLICK = 3, RIGHT_CLICK = 4
};

enum zone_type {
	//0 光标在空白区域， 1 光标在棋盘区域， 2 光标在第一屏的按钮区域， 3 光标在第二屏的按钮区域
	BLANK_ZONE = 0, BOARD_ZONE = 1, BTN_1_ZONE = 1, BTN_2_ZONE = 3
};

enum vga_btn_value {
	//0 无，1 player ai, 2 black, 3 ok, 4 undo, 5 restart
	NO_BTN = 0, PLAYER_BTN = 1, COLOR_BTN = 2, OK_BTN = 3, UNDO_BTN = 4, RESTART_BTN = 5, HINT_BTN = 6, BOARD_BTN = 7
};

/**************************** Type Definitions *****************************/
/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/* Unique ID  of device */
	UINTPTR BaseAddress;	/* Device base address */
} Bluetooth_Pen_Config;

/**
 */
typedef struct {
	UINTPTR BaseAddress;	/* Device base address */
	u32 IsReady;		/* Device is initialized and ready */
} Bluetooth_Pen;
/**
 *
 * Write a value to a BLUETOOTH_PEN register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the BLUETOOTH_PENdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void BLUETOOTH_PEN_mWriteReg(u32 BaseAddress, unsigned RegOffset, u32 Data)
 *
 */
#define BLUETOOTH_PEN_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/**
 *
 * Read a value from a BLUETOOTH_PEN register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the BLUETOOTH_PEN device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	u32 BLUETOOTH_PEN_mReadReg(u32 BaseAddress, unsigned RegOffset)
 *
 */
#define BLUETOOTH_PEN_mReadReg(BaseAddress, RegOffset) \
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
 * @param   baseaddr_p is the base address of the BLUETOOTH_PEN instance to be worked on.
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
XStatus BLUETOOTH_PEN_Reg_SelfTest(void * baseaddr_p);

Bluetooth_Pen_Config *Bluetooth_Pen_LookupConfig(u16 DeviceId);

int Bluetooth_Pen_CfgInitialize(Bluetooth_Pen * InstancePtr, Bluetooth_Pen_Config * Config,
                        UINTPTR EffectiveAddr);

// 获取鼠标指向的棋盘坐标
u8 Bluetooth_Pen_GetSeat(Bluetooth_Pen * InstancePtr, u8 *seat_x, u8 *seat_y);

// 获取屏幕上的按钮值
u8 Bluetooth_Pen_GetVgaBtn(Bluetooth_Pen * InstancePtr, u8 *VgaBtn);

// 获取蓝牙笔的按钮值
u8 Bluetooth_Pen_GetPenBtn(Bluetooth_Pen * InstancePtr);

// 获取光标所在的区域
u8 Bluetooth_Pen_GetCursorZone(Bluetooth_Pen * InstancePtr);

// 获取reg0所有值
void Bluetooth_Pen_GetAll(Bluetooth_Pen * InstancePtr, u8 *seat_x, 
	u8 *seat_y, u8 *VgaBtn, u8 *PenBtn, u8 *CursorZone);

#endif // BLUETOOTH_PEN_H
