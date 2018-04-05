﻿    ∇ A FINDBLOCKS S;buffer;B;X;Z;head[1]   ⍝Check to see which blocks have data[2]   ⍝Writes results to run\blocks<n>.txt, where n = block size[3]   ⍝B. Compton, 15 Nov 2010[4]   [5]   [6]   [7]    READPARS ME[8]    buffer←B←4⊃A[9]    →(∨/1≠block[4 5])/L1[10]   head←1↓⎕TCHT MTOV MATRIFY 'x y'[11]   (0 0⍴'') TMATOUT pathP PATH 'blocks',(⍕block[1]),'-',(⍕block[3]),'.txt'                 ⍝Write blank table on first block[12]  L1:X←READ 1⊃A[13]   →(0∊⍴Z←S INCLUDE X)/0[14]   (1 2⍴block[4 5]) LOCKWRITE pathP PATH 'blocks',(⍕block[1]),'-',(⍕block[3]),'.txt'     ⍝Write results to table[15]   →0[16]  [17]  what:auxiliary[18]  type:standard[19]  info:('land') ('') ('') (⌈buffer÷cellsize)    ⍝Source grid, settings, result grid, and buffer size[20]  check:CHECKVAR 'buffer'    ∇