/*
 * debug.h
 *
 *  Created on: 2018Äê10ÔÂ7ÈÕ
 *      Author: admin
 */

#ifndef SRC_DEBUG_H_
#define SRC_DEBUG_H_

# define __DEBUG 1

#include "xil_types.h"

void Print_Board(u8 board[15][15]) {
	int i, j;

	for(j = 0; j < 15; j++) {
		for (i = 0; i < 15; i++) {
			xil_printf("%d ", board[j][i]);
		}
		xil_printf("\r\n");
	}
}

#endif /* SRC_DEBUG_H_ */
