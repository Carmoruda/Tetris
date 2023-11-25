;--------------------------------------------------------------------------------------------------------------------------------------------------------
; Name: DB rows, columns, i, i, i, i, i, i: DW left, right: DB RowsAddLeftRotation, ColumnsAddLeftRotation, RowsAddRightRotation, ColumnsAddRightRotation
;--------------------------------------------------------------------------------------------------------------------------------------------------------

; O block (Yellow) - All four rotations are the same
T_0: DB 2, 2, $30, $30, $30, $30, 0, 0: DW T_0, T_0 ;: DB 0, 0, 0, 0

; I block (Cyan) - Vertical and horizontal rotations are the same among them
T_I1: DB 4, 1, $28, $28, $28, $28, 0, 0: DW T_I2, T_I2
T_I2: DB 1, 4, $28, $28, $28, $28, 0, 0: DW T_I1, T_I1

; Z block (Red) - Vertical and horizontal rotations are the same among them
T_Z1: DB 2, 3, $10, $10, 0, 0, $10, $10: DW T_Z2, T_Z2 ;: DB 0, 1, 0, 1
T_Z2: DB 3, 2, 0, $10, $10, $10, $10, 0: DW T_Z1, T_Z1 ;: DB 0, 0, 0, 0

; S block (Green) - Vertical and horizontal rotations are the same among them
T_S1: DB 2, 3, 0, $20, $20, $20, $20, 0: DW T_S2, T_S2 ;: DB 0, 1, 0, 1
T_S2: DB 3, 2, $20, 0, $20, $20, 0, $20: DW T_S1, T_S1 ;: DB

; L block (Dark Yellow) -  Four rotations
T_L1: DB 3, 2, $70, 0, $70, 0, $70, $70: DW T_L4, T_L2
T_L2: DB 2, 3, $70, $70, $70, $70, 0, 0: DW T_L1, T_L3
T_L3: DB 3, 2, $70, $70, 0, $70, 0, $70: DW T_L2, T_L4
T_L4: DB 2, 3, 0, 0, $70, $70, $70, $70: DW T_L3, T_L1

; J block (Dark Blue) - Four rotations
T_J1: DB 3, 2, 0, $08, 0, $08, $08, $08: DW T_J4, T_J2
T_J2: DB 2, 3, $08, 0, 0, $08, $08, $08: DW T_J1, T_J3
T_J3: DB 3, 2, $08, $08, $08, 0, $08, 0: DW T_J2, T_J4
T_J4: DB 2, 3, $08, $08, $08, 0, 0, $08: DW T_J3, T_J1

; T block (Purple) - Four rotations
T_T1: DB 2, 3, $18, $18, $18, 0, $18, 0: DW T_T4, T_T2
T_T2: DB 3, 2, 0, $18, $18, $18, 0, 3*8: DW T_T1, T_T3
T_T3: DB 2, 3, 0, $18, 0, $18, $18, 3*8: DW T_T2, T_T4
T_T4: DB 3, 2, $18, 0, $18, $18, $18, 0: DW T_T3, T_T1
;-----------------------------------------------------------------------------------------

TETROMINO_WIDTH EQU T_I1 - T_0
