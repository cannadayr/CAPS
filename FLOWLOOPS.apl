﻿    ∇ Z←X FLOWLOOPS M;B;I;fd;J;E;C;K;Q;T;F;G;whine[1]   ⍝Find loops in flow grid ⍺ starting at errors ⍵[2]   ⍝Errors must originate at M≥3, so we'll look there[3]   ⍝Return 2 for fixed errors, 3 for remaining errors, 4 for loop beyond streamline errors (1s record rest of loop)[4]   ⍝B. Compton, 14-15 Jul and 5 Aug 2010[5]   ⍝9 Aug 2010: find loop beyond streamline errors[6]   [7]   [8]   [9]    whine←0                                ⍝Chatter[10]   fd←(2*¯1+⍳8),8 2⍴0 1 1 1 1 0 1 ¯1 0 ¯1 ¯1 ¯1 ¯1 0 ¯1 1[11]   B←M≥3                                  ⍝All visited cells[12]   E←(⍴M)⍴0[13]  L1:→(^/,~B)/L12                         ⍝If any error cells left,[14]   BREAKCHECK[15]   F←0 5⍴0[16]   J←1 2⍴1+(1 0+⍴B)⊤¯1+(,B)⍳1             ⍝Index of next error cell[17]   WHINE J[18]  L2:→(E[J[1;1];J[1;2]]≠0)/L11            ⍝   If we've been here, we're done[19]   →(X[J[1;1];J[1;2]]=MV)/L11             ⍝   If cell is missing, we've flowed out of grid[20]   J←(X NEXTFLOW J[1;])⍪J                 ⍝   Flow to next cell[21]   →((∨/J[1;]≤0)∨∨/J[1;]≥⍴E)/L11          ⍝   If out of grid, we're done[22]   →(~(⊂J[1;])∊↓1 0↓J)/L2                 ⍝As long as we don't retrace steps[23]   E←E SCATR J (1⌈E SCATI J)              ⍝Mark all visited cells with 1 - we don't need to visit again[24]  [25]   WHINE 'Loop at ',⍕J[1;][26]   →(~0∊T←M SCATI J)/L3                   ⍝If loop flows beyond streamlines,[27]   LOG '⊢Loop beyond streamlines error at ',⍕J[1;]             ⍝  **** TEMPORARY, JUST TO SEE WHAT HAPPENS[28]   T←T⍳0[29]   E←E SCATR J 2[30]   E[J[T;1];J[T;2]]←5                     ⍝   Record error and give up[31]   B←B SCATR J 0[32]   →L1[33]  [34]  L3:C K G ← X M TRYFLOW J                ⍝Look for flow path from one of culprit's neighbors[35]   →(0∊⍴C)/L4                             ⍝If still have any candidates,[36]   X[J[1;1];J[1;2]]←fd[(↓fd[;2 3])⍳⊂C[1;]-J[1;];1]                 ⍝   Just pick first one ********** COULD PICK ONE RANDOMLY ****[37]   WHINE 'Fixed'[38]   →L10                                   ⍝Else, error is unrecoverable from this cell[39]  L4:E←E SCATR J 0                        ⍝   reset cells in loop[40]   F←F⍪J[1;],K,,1 2↑G                     ⍝   keep list of failures, how far we got for each, and last next cell for each[41]   J←1 2⍴X NEXTFLOW J[1;]                 ⍝   flow to next cell[42]   →((↓J)∊↓F[;1 2])/L5                    ⍝   If not on failure list,[43]   WHINE 'Failed...trying to fix next cell at ',⍕J[1;][44]   →L2                                    ⍝   try again with this cell[45]  L5:→(0∊⍴F)/L9                         ⍝Else, all attempts at single-cell change have failed.[46]   F←F[⍒F[;3];]                           ⍝   Sort failures by the longest loop.[47]   C←F[,1;4 5]                            ⍝   Next cell[48]   WHINE '...now trying loop from ',⍕,C[49]   →(~^/C=0)/L6                           ⍝If no cells to try here,[50]   C←X NEXTFLOW F[1;1 2]                  ⍝   Flow down one and try from there[51]  L6:C←(X NEXTFLOW C[1;])⍪C               ⍝   Reproduce longest loop[52]   →(~(⊂C[1;])∊↓1 0↓C)/L6                 ⍝   Now, we're looking for a neighbor of one of these that will lead us out[53]   I←0[54]  L7:→((1↑⍴C)<I←I+1)/L8                   ⍝   For each cell,[55]   WHINE '......trying cell ',⍕((I-1)⊖C)[1;][56]   Q K G ← X M TRYFLOW (I-1)⊖C            ⍝Look for flow path from one of these cell's neighbors[57]  [58]  →(K≠¯1)/L7                              ⍝   If TRYFLOW returned ¯1, we've got a flow path out of the landscape[59]   WHINE 'Success!'[60]  [61]  X[C[I;1];C[I;2]]←fd[(↓fd[;2 3])⍳⊂(,Q)-C[I;];1]  ⍝Point current cell to outlet[62]   E[C[I;1];C[I;2]]←E[C[I;1];C[I;2]]⌈3    ⍝Mark loop cell with 3 (will change to 2)[63]   →L1[64]  [65]  [66]  L8:WHINE 'Failure at loop ',⍕F[1;1 2][67]   F←1 0↓F                                ⍝Failure.  Try next longest loop[68]  →L5[69]  [70]  [71]  L9:E[J[1;1];J[1;2]]←E[J[1;1];J[1;2]]⌈4  ⍝   We're cooked. Mark unrecoverable loop (3)[72]  L10:J←↑((↓1 0↓J)⍳⊂J[1;])↑↓J             ⍝Get all cells involved in loop[73]   E←E SCATR J (2⌈E SCATI J)              ⍝Mark cells that are part of loop with 2 (will change to 1)[74]   E[J[1;1];J[1;2]]←E[J[1;1];J[1;2]]⌈3    ⍝Mark loop cell with 3 (will change to 2)[75]  L11:B[J[1↑⍴J;1];J[1↑⍴J;2]]←0            ⍝Done with this cell[76]   E←E SCATR (1 0↓J) (1⌈E SCATI 1 0↓J)    ⍝Mark all visited cells with 1 - we don't need to visit again[77]  [78]   →L1[79]  L12:E←0⌈E-1[80]   WHINE (⍕+/,E=2),' errors fixed, ',(⍕+/,E≥3),' errors could''t be fixed.'[81]   Z←X E    ∇