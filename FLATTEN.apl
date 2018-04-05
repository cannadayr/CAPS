﻿    ∇ Z←FLATTEN X[1]   ⍝Pull enclosed elements out of vector ⍵ and return in a unique, non-empty flat list[2]   ⍝B. Compton, 16 Nov 2009[3]   ⍝2 Mar 2015: ravel ⍵; don't sort results and don't change case[4]   [5]   [6]   [7]    X←,X[8]   L1:→(~1∊B←1<≡¨X)/L2[9]    X←((~B)/X),⊃,/B/X[10]   →L1[11]  [12]  L2:Z←(~0∊¨⍴¨X)/X              ⍝Drop empty elements[13]   Z←(((TOLOWER¨Z)⍳TOLOWER¨Z)=⍳⍴Z)/Z    ∇