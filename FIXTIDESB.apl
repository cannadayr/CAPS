﻿    ∇ A FIXTIDESB S;I;M;W;R;J;dams;targets;E;T;tr;trtable;trx;X;tinywatersheds;lc;result;trs;lrpars;B;d8flow;transparent;buffer;stop;tides;Y[1]   ⍝Repair tides settings variable to fix ¯0.5 cells for inland lakes in DEM_NOAA - tile version[2]   ⍝⍺ = usual metric left arguments[3]   ⍝⍵ = (start-item number-of-items) (systems)[4]   ⍝Parameters:[5]   ⍝   targets     list of big watersheds for TR[6]   ⍝   stop        stopping rule (use 5)[7]   ⍝B. Compton, 16 and 22 Aug 2016 (from FIXTIDES)[8]   ⍝30 Aug 2016: need a decent buffer![9]   [10]  ⍝Note: must run FIXTIDES as a companion, at the same time[11]  [12]  [13]  [14]   READPARS ME[15]   buffer←4⊃A[16]  [17]   Y←0 MVREP READ 4⊃1⊃A       ⍝Read grid of tiny watershed outflow points[18]   →(~∨/,Y)/0                 ⍝Bail if no outflows[19]   X←READ 1⊃1⊃A               ⍝Tides[20]   tides←X×X≥0.1              ⍝Use 0.1 as a cutoff for intertidal[21]   lc←READ 2⊃1⊃A              ⍝Landcover[22]   d8flow←READ 3⊃1⊃A          ⍝D8 flow accumulation[23]   result←(⍴X)⍴0[24]  ⍝ dams←lc=LOOK 'dam'[25]  [26]   transparent←3[27]   I←0[28]  L1:→((1↑⍴X)<I←I+1)/L3       ⍝For each row,[29]   BREAKCHECK[30]   →(~∨/Y[I;])/L1[31]   J←0[32]  L2:→((1↓⍴X)<J←J+1)/L1       ⍝   For each column,[33]   →(~Y[I;J])/L2[34]   0 FIXTIDESr I,J            ⍝      FIXTIDESr expects globals: result, d8flow, dams[35]   →L2[36]  [37]  L3:result WRITEI 'Z:\LCC\TEMP\FIXTIDES\result'[38]   (MVREP (result×X) (lc=MV)) WRITE pathR PATH 3⊃A    ⍝   Write results transparently[39]   →0[40]   [41]  [42]  [43]  what:CAPS coastal[44]  type:block[45]  info:((⊂pathU PATH 'tides0'),(⊂'land'),(⊂pathS PATH 'flow'),⊂pathG PATH 'tinyTR') ('') (⊂pathU PATH 'tides') (1000)       ⍝Metric-specific source grids, settings table, result grid, and buffer size[46]  check:CHECKVAR 'stop'[47]  check:1 CHECKCOVER 'dam'    ∇