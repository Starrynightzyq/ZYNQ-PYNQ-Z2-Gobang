/*
 * game.h
 *
 *  Created on: 2018年9月30日
 *      Author: admin
 */

#ifndef SRC_GAME_H_
#define SRC_GAME_H_

#include "xil_types.h"
#include "gobang.h"
#include "sleep.h"
#include "wifi.h"
#include <stdbool.h>

# define SPA 0
# define BLACK_CHESS 1
# define WHITE_CHESS 2    /* 空位置设为0 ，玩家下的位置设为1 ，电脑下的位置设为2 */

//# define MAN 1
//# define COM 2    /* 空位置设为0 ，玩家下的位置设为1 ，电脑下的位置设为2 */

# define CURRECT_BLACK 0x01
# define CURRECT_WHITE 0x02

extern XGame Gobang;
extern u8 seat_palyer_b_i, seat_palyer_b_j;	//黑子玩家下子坐标（默认 人类玩家）
extern u8 seat_palyer_w_i, seat_palyer_w_j;	//白子玩家下子坐标（默认 AI玩家）

void Play_Game(void);

//串口打印棋盘
void draw();	//just for test

#endif /* SRC_GAME_H_ */
