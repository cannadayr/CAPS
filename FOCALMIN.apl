﻿    ∇ Z←FOCALMIN X;I[1]   ⍝Return 3×3 focal min neighbor value of each cell[2]   ⍝Uses global KK8 8-neighbor rule[3]   [4]    X←1E6,1E6⍪(X⍪1E6),1E6[5]    Z←X[6]    I←0[7]   L1:→((1↑⍴KK8)<I←I+1)/L2[8]    Z←Z⌊(KK8[I;1]⌽KK8[I;2]⊖X)[9]    →L1[10]  L2:Z←¯1 ¯1↓1 1↓Z    ∇