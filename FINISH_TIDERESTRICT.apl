﻿    ∇ FINISH_TIDERESTRICT;X;B;head[1]   ⍝Finish the points file written by TR(B)_DSL[2]   [3]   [4]   [5]    X←MATIN pathR,'tiderestrict.txt'[6]    X←X[⍋X;][7]    B←∨/X≠¯1 0↓0⍪X[8]    X←B⌿X[9]    head←1↓⎕TCHT MTOV MATRIFY head[10]   X TMATOUT pathR,'tiderestrict.txt'    ∇