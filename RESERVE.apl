﻿    ∇ RESERVE;S;Q;I;N;L;P;M;T;F;V;G;J;KK8;cost;sys;vars;ewts;evar;dev;res;iei;ntiles;esys;qtiles;qtiles;qt;targets;haveS;haveQ;U;reached;noarc[1]   ⍝Build CAPS reserves[2]   ⍝Global input variables:[3]   ⍝   target  = % of landscape in reserves[4]   ⍝   result  = result name (default is 'reserve')[5]   ⍝   iter    = percent of the landscape to add per iteration[6]   ⍝   spread  = h for location spread[7]   ⍝   loc_floor, need_floor, iei_floor   = floor for each[8]   ⍝   iei_scale = scale each (just IEI for now)[9]   ⍝   resist  = name of file with location resistances[10]  ⍝   donut   = pairs of ortogonal neighbors, weight to fill in donuts[11]  ⍝[12]  ⍝Global internal variables:[13]  ⍝   sys = names of environmental sys[14]  ⍝   vars    = names of environmental variables[15]  ⍝   ewts    = weights of environmental variables for each system[16]  ⍝   esys    = grid of environmental sys (note that these must be coded as 1...n)[17]  ⍝   evar    = grids of environmental variables[18]  ⍝   dev     = grid of development & roads  (probably combine with esys, no?)[19]  ⍝   res     = grid of reserves[20]  ⍝   iei     = grid of iei[21]  ⍝   ntiles  = matrix of quantiles and weights for need[22]  ⍝   qtiles  = quantiles of each ecological variable[23]  ⍝   targets = targets for each system: overall, representation, and iei[24]  ⍝   haveS   = percent in reserves by system[25]  ⍝   haveQ   = percent in reserves by pct/iei, system, variable, and quantile[26]  ⍝[27]  ⍝Use:[28]  ⍝   SETPATH 'landscape'[29]  ⍝   RUN 'model'[30]  ⍝[31]  ⍝B. Compton, 17-27 Jul 2007[32]  [33]  [34]   ('1',⎕TCNL) NWRITE PATH 'running.txt'[35]  [36]   LOG '-----'[37]   LOG 'Input path: ',pathG[38]   LOG 'Result name: *** ',(STRIP F←OKGRID pathR PATH (1+0∊⍴result)⊃result 'reserves'),' ***'[39]   iei←READ pathG PATH 'iei'                      ⍝Quality[40]   ⍎'iei←iei_floor+iei',iei_scale                 ⍝Scale iei & apply floor[41]   noarc←~makearc[42]   Q←MATIN pathI PATH environ,(~'.'∊environ)/'.csv'[43]   sys←MIX Q[;1]                              ⍝Names of environmental sys[44]   vars←MATRIFY head                              ⍝Names of environmental variables[45]   ewts←0 1↓Q                                     ⍝Environmental weights[46]   ewts←ewts DIV ⍉(⌽⍴ewts)⍴+/ewts                 ⍝Process weights to sum within each system[47]   reached←(1↑⍴sys)⍴0[48]  [49]   evar←(0,⍴iei)⍴0[50]   I←0[51]   LOG 'Reading environmental variables:'[52]  L1:→((1↑⍴vars)<I←I+1)/L2                        ⍝For each environmental variable,[53]   LOG '   ',T←pathG PATH FRDBL vars[I;]          ⍝   Read grid[54]   evar←evar⍪READ T[55]   →L1[56]  [57]  L2:res←(⍴iei)⍴0[58]   →(0∊⍴seed)/L22                                 ⍝If seed provided for reserves[59]   res←0≠READ pathG PATH seed                     ⍝   Read protected open space (or other seed file)[60]  L22:dev←READ pathG PATH 'dev'                   ⍝Roads & development[61]   res←res×dev=0                                  ⍝Drop developed cells from seed reserves--these aren't really protected![62]   esys←READ pathG PATH 'sys'                     ⍝Ecological sys[63]   esys←(esys×~Q)+MV×Q←∨⌿evar=MV                  ⍝Any missing environmental variables → missing[64]   cost←(MATIN pathI PATH 'resistance.txt')[;⍳2][65]   KK8←8 2⍴¯1 0 1 0 0 ¯1 0 1 ¯1 ¯1 1 1 ¯1 1 1 ¯1[66]  [67]   I←0[68]   ntiles←((.5×⍴needtiles),2)⍴needtiles[69]   ntiles[;2]←ntiles[;2] DIV +/ntiles[;2]         ⍝Need-tile weights[70]   qtiles←((⍴ewts),G←COMMON ntiles[;1])⍴0         ⍝Least common multiple of quantiles[71]   targets←↑(1↑⍴sys)⍴¨sys_target represent_target iei_target[72]   haveS←(1↑⍴sys)⍴0[73]   ('iteration',⎕TCHT MTOV 'overall' OVER sys) NWRITE PATH 'haveS.dat'[74]   ('iteration',⎕TCHT MTOV sys) NWRITE PATH 'haveQ.dat'[75]  [76]  L3:→((1↑⍴vars)<I←I+1)/L6                        ⍝For each environmental variable,[77]   V←,evar[I;;][78]   V←V×~,esys∊0,MV                                ⍝   All developed and missing ← 0[79]   J←0[80]  L4:→((1↑⍴sys)<J←J+1)/L5                     ⍝   For each ecological system,[81]   Q←G QUANTILE (M←,esys=J)/V                     ⍝       Rescale by quantiles[82]   qtiles[J;I;]←qtiles                             ⍝       quantiles (system × variable × tile)[83]   V←(V×~M)+M\Q[84]   →L4[85]  L5:evar[I;;]←(1↓⍴evar)⍴V[86]   →L3[87]  [88]  L6:LOG 'Target: ',(2⍕100×target←target÷100),'%'[89]   LOG 'Adding ',(⍕iter),'% of the landscape per iteration.'[90]   LOG 'Location h = ',(⍕iter),', floor = ',⍕loc_floor[91]   LOG 'Need floor = ',⍕need_floor[92]   LOG 'Quality floor = ',⍕iei_floor[93]   I←0[94]   LOG ''[95]   LOG 'Initial condition'[96]   LOG 'Landscape is',(2⍕100×(+/,dev>0)÷+/,res≠MV),'% developed.'[97]  [98]  L7:LOG '---'                                    ⍝Main loop: For each iteration,[99]   haveQ←(2,(1↑⍴sys),(1↑⍴vars),ntiles[1;1])⍴1 ⍝   pct/iei × system × vars × quantile[100]  N←NEED need_floor                              ⍝   Weights from need[101]  Q←(+/,res>0)÷+/,res≠MV[102]  (('. .',⎕TCHT) TEXTREPL ⍕I,2 ROUND 100×Q,haveS) NAPPEND PATH 'haveS.dat'[103]  LOG 'Current percent of landscape in reserves: ',(2⍕100×Q),'%'[104]  T←(haveS×100)≥targets[1;]                      ⍝   System targets reached[105]  U←^/V←^⌿(P⍴haveQ)≥.01×(P←(2↑⍴haveQ),×/2↓⍴haveQ)⍴(⍴haveQ)[3]/,1 0↓targets  ⍝   Quantile targets reached, by system[106] ⍝⍝⍝ U←^/V←^⌿haveQ≥.01×(⍴haveQ)⍴(⍴haveQ)[3]/,1 0↓targets  ⍝   Quantile targets reached, by system[107]  V←100×(+/(V×P))÷+/P←ntiles[1;1]/0≠ewts         ⍝   Percent of variables/quantiles reached for each system[108]  (('. .',⎕TCHT) TEXTREPL ⍕I,2 ROUND V) NAPPEND PATH 'haveQ.dat'[109]  LOG 'Ecological sys in reserves: ',¯1↓FRDBL⍕(FRDBL¨↓sys),¨(⊂' = '),¨(⍕¨2 ROUND haveS×100),¨⊂'%, '[110]  LOG ((∨/targets[1;]>0)^∨/T)/'System targets reached for:',' ' MTOV T⌿sys[111]  LOG 'Percent of variable/quantile targets reached: ',¯1↓FRDBL⍕(FRDBL¨↓sys),¨(⊂' = '),¨(⍕¨2 ROUND V),¨⊂'%, '[112]  LOG ((∨/0<,1 0↓targets)^∨/U)/'Variable/quantile targets reached for:',' ' MTOV U⌿sys[113]  LOG ''[114] [115]  reached←T^U                                    ⍝   Targets reached for each system?[116]  →((Q≥target)^(^/T)^^/U)/L9                     ⍝   If reached overall target, system target and quantile targets, we're done[117] [118]  LOG 'Iteration ',⍕I←I+1[119]  L←LOCATION spread loc_floor                    ⍝   Weights from Location[120] [121]  S←(res=0)×(dev=0)×weights GEOMEAN L N iei      ⍝   Score is geometric mean of location, need, and quality, only outside of reserves[122]  res←res+I×Q←(S≠0)×S≥(1-iter÷100) QTILE S       ⍝   Add top S% of highest valued cell(s), but not zeros[123]  →(0=Q←+/,Q)/L8[124]  LOG (⍕Q),' cells added to reserves.'[125]  →L7[126] L8:LOG 'No more cells can be added.'[127]  →L9[128] [129] [130] L9:LOG 'Clean-up iteration'                     ⍝Clean-up at end[131]  L←LOCATION spread loc_floor[132]  res←res+(I+1)×Q←L>1                            ⍝Just add donut cells[133]  LOG (⍕+/,Q),' cells added to reserves.'[134]  N←NEED need_floor[135]  Q←(+/,res>0)÷+/,res≠MV[136]  (('. .',⎕TCHT) TEXTREPL ⍕(I+1),2 ROUND 100×Q,haveS) NAPPEND PATH 'haveS.dat'[137] [138]  LOG 'Final percent of landscape in reserves: ',(2⍕100×(+/,res>0)÷+/,res≠MV),'%'[139]  NEEDSTATS T←F,'.dat'[140]  LOG 'Representation statistics written to ',T[141]  F PUT 'res'[142]  LOG 'Copying log file to ',F,'.log'            ⍝Log file is writen to path\model.log as well as pathR\result.log (for long-term reference)[143]  (NREAD logfile) NWRITE F,'.log'[144]  ⎕←'Finished.'[145]  ('0',⎕TCNL) NWRITE PATH 'running.txt'    ∇