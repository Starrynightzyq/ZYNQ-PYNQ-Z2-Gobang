# Matrix Keyboard

## reg

1. reg0

   | 31-1     | 0                             |
   | -------- | ----------------------------- |
   | reserved | keyboard_enable (active high) |

2. reg1

   | 31-4     | 3-0                 |
   | -------- | ------------------- |
   | reserved | keyborad_data (0-F) |

3. reg2

   | 31-0     |
   | -------- |
   | reserved |

4. reg3

   | 31-0     |
   | -------- |
   | reserved |

## pin

| pmod | col/row |
| ---- | ------- |
| J1   | col[0]  |
| J2   | col[2]  |
| J3   | row[0]  |
| J4   | row[2]  |
| J7   | col[1]  |
| J8   | col[3]  |
| J9   | row[1]  |
| J10  | row[3]  |

