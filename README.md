# 基于FPGA的机器博弈五子棋游戏

这是参加2018第二届全国大学生创新设计邀请赛的作品，还没有完全整理好，先占坑。

1. ## 如何使用该工程

   1. 将工程下载到本地；
   2. 该工程使用了一个[Digilent Vivado library](https://github.com/Digilent/vivado-library.git)里面的IP，将该目录下载到本地，放到ZYNQ-PYNQ-Z2-Gobang\repo下；
   3. 进入ZYNQ-PYNQ-Z2-Gobang目录，调用“python ./digilent_vivado_scripts/git_vivado.py checkout”，默认参数将在“<project repo> / proj / <project name> .xpr”中创建XPR；
   4. sdk工程文件在<project repo> / sdk下。

2. ## 接口说明

   - 矩阵键盘接PMODB
   - ESP8266接PMODA，A3 -> uart_rtl_txd，A4 -> uart_rtl_rxd
   - 蓝牙1tx接A1，蓝牙2tx接A7

3. ## 功能说明

   - 人机对战，默认人类玩家执黑子，AI执白子；
   - 使用矩阵键盘下棋；
   - 悔棋功能；
   - 清空棋盘重新开始功能；

4. ## 程序说明

   - i 为横坐标，j 为纵坐标，范围 0-14；

5. ## 与云端交互

   - ID状态表：

     |      |                      |                |
     | ---- | -------------------- | -------------- |
     | 1    | 人机简单             | ID_PVA_EASY    |
     | 2    | 人机一般             | ID_PVA_GENERAL |
     | 3    | 人机困难             | ID_PVA_HARD    |
     | 4    | 人人                 | ID_PVP         |
     | 5    | AI VS AI             | ID_AVA         |
     | 6    | 下棋                 | ID_LAOZI       |
     | 7    | 悔棋                 | ID_RETRACT     |
     | 8    | 获胜                 | ID_WIN         |
     | 9    | 清空棋盘（再来一局） | ID_RESTART     |
     | 10   | 开始游戏             | ID_START_GAME  |
     | 11   | 接收错误             | ID_RECV_ERROR  |
     | 12   | 落子提示             | ID_HINT        |

   - 数据格式:

     > 每一帧数据包括8个子帧，如下表：

     | 0 - 1      | 2               | 3 - 4  | 5 - 6  | 7      |
     | ---------- | --------------- | ------ | ------ | ------ |
     | ID         | color           | seat_j | seat_i | $      |
     | 见ID状态表 | 0黑\|1白\|2光标 | 纵坐标 | 横坐标 | 结束帧 |