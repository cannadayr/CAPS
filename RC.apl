﻿    ∇ Z←H RC F[1]   ⍝Return matrix ⍵ with row and column numbers or optional header vectors ⍺[2]   [3]   [4]    F←(¯2↑1 1,⍴F)⍴F[5]    ⍎(0=⎕NC'H')/'H←(⍳1↑⍴F) (⍳1↓⍴F)'[6]    Z←((⊂' '),1⊃H),(⍕¨2⊃H)⍪F[7]   [8]    Z←Z[1;]⍪' '⍪1 0↓Z[9]    Z←Z[;1],' ',0 1↓Z[10]   Z[2;]←'-'[11]   Z[;2]←'|'[12]   Z[1 2;1 2]←' '[13]   Z←⍕¨Z    ∇