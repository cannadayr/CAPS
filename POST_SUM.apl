﻿    ∇ Z←A POST_SUM K;Y;E;J;I;Q;B;L[1]   ⍝Build aspatial summaries ⍺ of index #⍵[4] if in phase 2 (⍵[3]=2) give communities 1⊃⍵ and index 2⊃⍵[2]   ⍝Result is community, ncells, sum(index) for each index[3]   ⍝For LCC[4]   ⍝B. Compton, 10 Feb 2012[5]   [6]   [7]   [8]    K Y E J ← K[9]    Z←A[10]   →(E≠2)/0                               ⍝We're only doing this for phase 2 (IEI, or other indices)[11]   K←K[I←⍋K][12]   Y←Y[I][13]   Q←(B/K),(B pSUM (⍴K)⍴1),[1.5](B←K≠0,¯1↓K) pSUM Y[14]   Z[I;L]←Z[I←Z[;1]⍳Q[;1];L←(2×J)+0 1]+Q[;2 3]    ∇