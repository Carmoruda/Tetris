;-----------------------------------------------------------------------------------------
; Name: DB rows, columns, i, i, i, i, i, i: DW left, right
;-----------------------------------------------------------------------------------------

; O block (Yellow) - All four rotations are the same
T_0: DB 2, 2, 6*8, 6*8, 6*8, 6*8, 0, 0: DW T_0, T_0

; I block (Cyan) - Vertical and horizontal rotations are the same among them
T_I1: DB 4, 1, 5*8, 5*8, 5*8, 5*8, 0, 0: DW T_I2, T_I2
T_I2: DB 1, 4, 5*8, 5*8, 5*8, 5*8, 0, 0: DW T_I1, T_I1

; Z block (Red) - Vertical and horizontal rotations are the same among them
T_Z1: DB 2, 3, 2*8, 2*8, 0, 0, 2*8, 2*8: DW T_Z2, T_Z2
T_Z2: DB 3, 2, 0, 2*8, 2*8, 2*8, 2*8, 0: DW T_Z1, T_Z1

; S block (Green) - Vertical and horizontal rotations are the same among them
T_S1: DB 2, 3, 0, 4*8, 4*8, 4*8, 4*8, 0: DW T_S2, T_S2
T_S2: DB 3, 2, 4*8, 0, 4*8, 4*8, 0, 4*8: DW T_S1, T_S1

; L block (Dark Yellow) -  Four rotations
T_L1: DB 3, 2, 14*8, 0, 14*8, 0, 14*8, 14*8: DW T_L4, T_L2
T_L2: DB 2, 3, 14*8, 14*8, 14*8, 14*8, 0, 0: DW T_L1, T_L3
T_L3: DB 3, 2, 14*8, 14*8, 0, 14*8, 0, 14*8: DW T_L2, T_L4
T_L4: DB 2, 3, 0, 0, 14*8, 14*8, 14*8, 14*8: DW T_L3, T_L1

; J block (Dark Blue) - Four rotations
T_J1: DB 3, 2, 0, 8, 0, 8, 8, 8: DW T_J4, T_J2
T_J2: DB 2, 3, 8, 0, 0, 8, 8, 8: DW T_J1, T_J3
T_J3: DB 3, 2, 8, 8, 8, 0, 8, 0: DW T_J2, T_J4
T_J4: DB 2, 3, 8, 8, 8, 0, 0, 8: DW T_J3, T_J1

; T block (Purple) - Four rotations
T_T1: DB 2, 3, 3*8, 3*8, 3*8, 0, 3*8, 0: DW T_T4, T_T2
T_T2: DB 3, 2, 0, 3*8, 3*8, 3*8, 0, 3*8: DW T_T1, T_T3
T_T3: DB 2, 3, 0, 3*8, 0, 3*8, 3*8, 3*8: DW T_T2, T_T4
T_T4: DB 3, 2, 3*8, 0, 3*8, 3*8, 3*8, 0: DW T_T3, T_T1
;-----------------------------------------------------------------------------------------
