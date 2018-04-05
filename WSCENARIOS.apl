﻿    ∇ Z←WSCENARIOS W;T;Q;I[1]   ⍝Disentangle watershed metrics & scenarios from metrics.par lines ⍵[2]   ⍝Give list of scenario name ('' for scenario-free) and list of metrics and systems[3]   ⍝B. Compton, 12 Aug 2009[4]   [5]   [6]    T←MIX W[;5]←TOLOWER W[;5][7]    T←T[⎕AV⍋T;][8]    Q←T MATIOTA T[9]    Q←T[((Q⍳Q)=⍳⍴Q)/Q;][10]   Z←0 2⍴''[11]   I←0[12]  L1:→((1↑⍴Q)<I←I+1)/0        ⍝For each scenario,[13]   Z←Z⍪(⊂FRDBL Q[I;]),⊂(W[;5]≡¨⊂FRDBL Q[I;])⌿W[;1 3][14]   →L1    ∇