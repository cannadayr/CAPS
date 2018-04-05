﻿    ∇ A FLOWACCUM S;buffer;B;Y;X;F;Z;G;C;D;fd;I;bad;L;deepwater;transparent;Q;R;W;U;P;precip[1]   ⍝Calculate flow accumulation using the FD8 algorithm as source to topographic wetness index[2]   ⍝Runs as a CAPS block metric.  Needs DEM, D8 flow, and D8 flow accumulation, from makedem.aml and makedem2.aml[3]   ⍝Source data (all in source\):[4]   ⍝   dem_fill            elevation (filled)[5]   ⍝   flow                D8 flow grid[6]   ⍝   d8accum             D8 flow accumulation grid[7]   ⍝   streamgrid          original (full) stream centerlines & off-centerlines[8]   ⍝   luwet               land use/wetlands[9]   ⍝   slope               percent slope[10]  ⍝   [precip]            precipitation, see parameters[11]  ⍝Result data:[12]  ⍝   source\fd8accum     FD8 flow accumulation[13]  ⍝   source\lnfd8accum   natural log of FD8 flow accumulation[14]  ⍝   source\wetness      Topographc wetness index[15]  ⍝   results\badflow     Marks infinite loops in flow[16]  ⍝Parameters:[17]  ⍝   d8threshold - threshold (ha) above which D8 flow is used.  Wilson & Gallant say 10 ha.  NOTE that if[18]  ⍝                 you're using precip, this must be in mean rainfall × ha.[19]  ⍝   buffer      - buffer (m) around block.  Needs to be ≥ maximum channel → watershed edge;[20]  ⍝                 in Massachusetts, buffer = 1500 is safe.  If buffer is too small, you'll[21]  ⍝                 end up with NODATA cells in the middle of the landscape, at block edges.[22]  ⍝                 →→→ Don't forget to look for these! ←←←[23]  ⍝   deepwater   - landcover table, with 1's marking deepwater types: lakes, reserviors, ocean.[24]  ⍝                 D8 accumulation is used for these types; FD8 starts at edges of them[25]  ⍝   precip      - yes if using a precipitation grid.  Use precip = no for default of precip = 1.0[26]  ⍝                 everywhere.  FLOWACCUM does't mess with scaling.  Note: if you use precip, you[27]  ⍝                 should also use d8accum based on precip, or you'll get unexpected results!  AND, you'll[28]  ⍝                 need to make sure d8threshold is in terms of precip×ha.[29]  ⍝Note: badflow counts the number of times each cell is visited for cells with multiple visits.  Values ≥1 might[30]  ⍝indicate errors in the flow grid (loops or depressions), but they also happen when streams have been burned into[31]  ⍝the flow grid so it disagrees with the DEM.  Have a look at badflow, but it may be okay to ignore.[32]  ⍝B. Compton, 27 May-4 Jun 2010[33]  ⍝Minor edits 10 Aug 2010[34]  ⍝12 Aug 2010: Use D8 flow for stream centerlines[35]  ⍝16 Aug 2010: also write topographic wetness index; 24 Nov 2010: minor bug in this when Z is missing; 30 Nov 2010: another small but deadly bug; don't do wetness[36]  ⍝20 Jan 2011: use depressionless DEM; default is unfilled DEM[37]  ⍝1 Sep 2011: Allow optional precipitation grid[38]  ⍝15 Sep 2011: use streamgrid, original version of streams before trimming[39]  ⍝16 Sep 2011: precip as *optional grid; 20 Sep 2011: update comments; 22 Sep 2011: bug fix[40]  [41]  [42]  [43]   READPARS ME[44]   buffer←B←4⊃A[45]   →(0∊⍴Y←EXAMPLEINIT 0)/0                        ⍝Check for example points[46]   X←READ 1⊃1⊃A                                   ⍝Get DEM,[47]   F←READ 2⊃1⊃A                                   ⍝D8 flow direction grid,[48]   D←1+0 MVREP READ 3⊃1⊃A                         ⍝D8 flow accumulation grid,[49]   R←1=READ 4⊃1⊃A                                 ⍝stream centerlines,[50]   L←READ 5⊃1⊃A                                   ⍝landcover,[51]   U←READ 6⊃1⊃A                                   ⍝and slope[52]   →(0∊⍴mask)/L0                                  ⍝If mask grid supplied,[53]   Y←Y^0 MVREP READ mask                          ⍝   read it[54]  L0:Z←(⍴X)⍴MV[55]   bad←(2+⍴X)⍴0                                   ⍝This is used to find infinite loop errors, returned as grid bad[56]   →((~1∊Y)∨^/,(B,B)↓(-B,B)↓X∊MV)/0               ⍝If block is all missing or masked, just get out now[57]   P←(⍴X)⍴1[58]   →(~precip)/L1                                  ⍝If precipitation grid supplied,[59]   P←0 MVREP READ 7⊃1⊃A                           ⍝   Read it[60]   P←0 MVREP P (X=MV)[61]  L1:C←D≥d8threshold×1E4÷cellsize*2               ⍝Cells in channels (where D8 watershed ≥ threshold, should be 10 ha)[62]   C←C∨R≠0                                        ⍝or in centerlines[63]   C←C∨X∊MV                                       ⍝or flowing out of landscape[64]   C←C∨L∊(LOOKUP deepwater)[;1]                   ⍝or flowing into deepwater (ocean, lakes, etc.)[65]   I←((,C)/,⍉(⌽⍴C)⍴⍳1↑⍴C),[1.5](,C)/,(⍴C)⍴⍳1↓⍴C   ⍝Indices into channel/deepwater/nodata cells[66]   →(0∊⍴I)/0[67]   G←⊃⍪/¯1+(⊂0,(0⍪F⍪0),0) FLOWINTO¨↓I+1           ⍝Cells that flow into these[68]   Q←(~C)×((⍴X)⍴0) SCATR G 1[69]   G←((,Q)/,⍉(⌽⍴Q)⍴⍳1↑⍴Q),[1.5](,Q)/,(⍴Q)⍴⍳1↓⍴Q   ⍝...that aren't themselves channels, etc.[70]   G←(^/(G>B),G≤(⍴G)⍴(⍴X)-B)⌿G                    ⍝Targets must be within block, not buffer[71]  [72]   Z←G FD8FLOW X F D P[73]   C[(⍳B),(1+1↑⍴C)-⍳B;]←0[74]   C[;(⍳B),(1+1↓⍴C)-⍳B]←0[75]   Z←(Z×~C)+D×C                                   ⍝Replace channels with D8 flow (but not in buffer)[76]   ⍝W←⍟1 MVREP X REMV (cellsize×1+0 MVREP Z)÷.01⌈U×100     ⍝Topographic wetness index [tan(deg_slope) = pct_slope×100]  ...Edge problems here; do it in setwetness.aml[77]  [78]  L9:transparent←1[79]  [80]  [81]   ⍝*** TEMP CODE ***************************************************************************[82]   →(1E10>⌈/|X REMV Z)/L111[83]   LOG 'FOUND GOOFY VALUE IN FD8ACCUM ON ',name,'.',(⍕thread)[84]   ⎕ELX←'⎕DM'[85]   ⎕ERROR 'FOUND GOOFY VALUE!'[86]  [87]   L111:[88]  [89]  [90]   (X REMV Z) WRITE pathR PATH 1⊃3⊃A              ⍝Write FD8 flow accumulation[91]  ⍝ (X REMV W) WRITE pathR PATH 2⊃3⊃A              ⍝and topographic wetness index[92]   (X Z REMV ⍟1 MVREP Z ((X=MV)∨Z∊0,MV)) WRITE pathR PATH (2⊃3⊃A)  ⍝and log of flow accumulation[93]   (1 1↓¯1 ¯1↓bad) WRITE pathR PATH 3⊃3⊃A         ⍝Marks infinite loops in flow grid.  Most of these don't matter[94]   →0[95]  [96]  [97]  what:data prep[98]  type:standard[99]  info:((⊂pathS),¨'dem_fill' 'flow' 'd8accum' 'streamgrid' 'luwet' 'slope' '*precip') ('') ((pathS PATH 'fd8accum') (pathS PATH 'lnfd8accum') 'badflow') (⌈buffer÷cellsize) 'luwet'      ⍝Source grid, settings table, result grid, and buffer size[100] check:CHECKVAR 'd8threshold buffer deepwater precip'[101] check:CHECKCOVER 'deepwater'    ∇