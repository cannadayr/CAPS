﻿    ∇ X ∆WRITEGRID G;Z;C;R;Q;Y;err;A;firstfail[1]   ⍝Write data ⍺ to arc grid ⍵[2]   ⍝B. Compton, 15 Jan 2009; E. Ene, 7 Jan 2009[3]   ⍝2 May 2011: set global gridwait for task manager[4]   ⍝13 Nov 2013: add grid server recovery[5]   [6]   [7]   [8]    →(aplc=1)/L9                               ⍝If C version,[9]    →(3=⎕NC'WRITEGRIDc')/L1                    ⍝   If not loaded,[10]   Q←⎕EX 'WRITEGRIDc'[11]   ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.writegrid_dbl(*C1,I4,I4,F8,*F8)' ⎕NA 'WRITEGRIDc'[12]   ⎕ERROR REPORTC 'DLL I4←CAPS_LIB.writegrid_int(*C1,I4,I4,I4,*I4)' ⎕NA 'WRITEGRIDIc'[13]  ⍝⎕←'CAPS_LIB.writegrid_dbl and .writegrid_int loaded.'[14]  [15]  L1:R C←⍴X←(¯2↑1 1,⍴X)⍴X[16]   A←⎕AI[2][17]   →(645=⎕DR X)/L2                            ⍝If integer grid,[18]  L5:err←WRITEGRIDIc (G,⎕TCNUL) R C MV X[19]   →(RECOVERY err)/L5                         ⍝   Wait for crashed grid servers to recover[20]   →L3[21]  [22]  L2:err←WRITEGRIDc (G,⎕TCNUL) R C MV X       ⍝Else, floating point[23]   →(RECOVERY err)/L2                         ⍝   Wait for crashed grid servers to recover[24]  [25]  L3:[26]   →(err≠¯10016)/L4                           ⍝If grid too big error,[27]   X ∆WRITEBLOCK (⊂G),1 1,gridwindow[2 1]     ⍝   use WRITEBLOCK to bypass cache and read big grid[28]   GRIDWAIT A[29]   →0[30]  [31]  L4:GRIDWAIT A[32]   ⎕ERROR G REPORTC err[33]   →0[34]  [35]  L9:(G,(~'.'∊G)/'.asc') TOARC X    ∇