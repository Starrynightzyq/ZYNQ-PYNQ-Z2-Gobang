/*
 * mp3.h
 *
 *  Created on: 2018年12月4日
 *      Author: admin
 */

#ifndef SRC_MP3_H_
#define SRC_MP3_H_

int MP3_Uart_Init(void);

int MP3_Send_CMD(void);

//循环播放背景音乐
void MP3_Loop_Bgm(void);

//调节音量到最大
void MP3_Set_Volume_Max(void);

//"ADVERT"文件夹，曲目为"0002"
//按键音
void MP3_Play_Btn(void);

// 停止播放
void MP3_Pause(void);

//"ADVERT"文件夹，曲目为"0003"
//赢棋声音
void MP3_Play_Win(void);

//"ADVERT"文件夹，曲目为"0004"
//输棋声音
void MP3_Play_Lose(void);

//"ADVERT"文件夹，曲目为"0005"
//下棋声音
void MP3_Play_chess(void);

#endif /* SRC_MP3_H_ */
