﻿    ∇  Z←FRDBL A[1]    ⍝Deletes leading and trailing blank columns in matrix or vector ⍵[2]    →(A←''⍴(⎕STPTR'Z A')⎕CALL FRDBL∆OBJ)↓0[3]    ⎕ERROR(5 7 8⍳A)⊃'RANK ERROR' 'VALUE ERROR' 'WS FULL' 'DOMAIN ERROR'[4]    ⍝ Copyright (c) 1988, '92, '94 by Jim Weigang    ∇