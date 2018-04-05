﻿    ∇ Z←P FLOW2PATCH J;I;K;F[1]   ⍝Find all cells that flow to target cell ⍵, up to first cell outside of patch ⍺[2]   [3]   [4]   [5]    Z←2⍴⊂(1 2⍴J)[6]    →(0=P[J[1];J[2]])/0       ⍝Bail out if out of patch[7]    Z[1]←⊂0 2⍴0[8]    I←J∘.+¯1+⍳3[9]    F←(,flo=fl[I[1;];I[2;]])⌿dir[10]   K←0[11]  L1:→((1↑⍴F)<K←K+1)/0       ⍝For each cell that flows into this one,[12]   Z←Z⍪¨P FLOW2PATCH J+F[K;]  ⍝   Recurse[13]   →L1    ∇