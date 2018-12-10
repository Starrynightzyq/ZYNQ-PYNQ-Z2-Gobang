# Chess Value
1. 寄存器说明

- slv_reg0(in) ctrl

| 31-2 | 1    | 0    |
| ---- | ---- | ---- |
| reserved | clr(active high) | active(active high) |

- slv_reg1(out) best seat

| 31-16 | 15-12 | 11-8 | 7-4  | 3-0  |
| ----- | ----- | ---- | ---- | ---- |
|reserved|black_j|black_i|white_j|white_i|


- slv_reg2(out) best score

| 31-16 | 15-0 |
| ----- | ---- |
|black_score|white_score|

- slv_reg3(out) win checker

| 31-18    | 17        | 16        | 15-12       | 11-8        | 7-4       | 3-0       |
| -------- | --------- | --------- | ----------- | ----------- | --------- | --------- |
| reserved | black_win | white_win | win_begin_j | win_begin_i | win_end_j | win_end_i |