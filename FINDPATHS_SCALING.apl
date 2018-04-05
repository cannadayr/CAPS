﻿    ∇ A FINDPATHS_SCALING S;N;U;M;I;D;block;X;O;V;override_pars;cpars;buffer;bankcrossings;crossscores;Q;cross;G;linkages;Y;linkgrids;npaths;wanderlust;drawpaths;bandwidths;search;multiplier;resist;masktocore;L;P;kernelpoints;res;density;J;communities;fc;K;F;W;R;T;Z;C;B;fromto;t;head;H;points;nc;time;momentum;E;units;score;scores;ss;f;fi;conduct;bandwidth;p;scale;bc;H2;H3;conductance;Hx;set;I0;pass1;probs;Hf;scaling[1]   [2]   ATTEMPTED SCALING APPROACH TO COOKIE CONNECTOR SCALING. A FAILURE.[3]   [4]   [5]   ⍝Prepare tables for CAPS Critical Linkages II analysis[6]   ⍝Parameters:[7]   ⍝   units           'passages' for wildlife passage structures, 'development', or 'none' to just get conductance and importance[8]   ⍝                   for development scenarios.[9]   ⍝   targets         Target nodes[10]  ⍝   communities     Focal communities to use[11]  ⍝   bandwidths      List of one or more bandwidths to use.  The largest of these is used as the kernel bandwidth.[12]  ⍝                   One version of conduct, the conductance grid, is written for each bandwidth if conduct = yes.[13]  ⍝   kernelpoints    Number of points to build kernels from[14]  ⍝   npaths          Number of random low-cost paths to find between each pair of nodes (if 2 elements, 1st is for maxpaths scaling pass)[15]  ⍝                   Beware: maxpaths scaling always uses max bandwidth if there are more than one[16]  ⍝   scaling         Power to use when scaling maxpaths (turn off scaling by using 1 element for npaths)[17]  ⍝   nodedistance    Maximum distance (km) between centroids of to-node and from-nodes[18]  ⍝   wanderlust      A parameter that determines how far RLCPs deviate from the least-cost path[19]  ⍝   momentum        strength and persistence for momentum (use 0 to turn momentum off)[20]  ⍝   fromto          list of from-node numbers and of to-node numbers to restrict run to, for testing[21]  ⍝                   For normal runs, use fromto = 0.  NOTE: these are indices into node lists,[22]  ⍝                   not actual node numbers (for now).  Make sure these all fall within the same task[23]  ⍝                   --you may need to increase block in metrics.par.[24]  ⍝   drawpaths       If yes, create coverage of paths (beware of using this with lots of paths--it gets wicked slow!)[25]  ⍝[26]  ⍝   scores          file with score formulas for settings variables (used only when units = 'passages', otherwise ignored)[27]  ⍝   conduct	        If 1, write conductance and irreplacability grids, skip them if 0.[28]  ⍝Parameters from [connect]:[29]  ⍝   multiplier      multiplier on ecological distance for costs[30]  ⍝   search          search distance, in s.d.[31]  ⍝[32]  ⍝Inputs:[33]  ⍝    nodes          Integer grid with node # for each reserve polygon.  Converted from a shapefile with makenodes.aml.[34]  ⍝    nodes.txt      More information about reserve nodes.   Node #, centroid-x, centroid-y, reserve name, priority,[35]  ⍝                   include, and community (index into communities; used for Connectivity).[36]  ⍝    nodevalues.txt Values for nodes, with IEI-weighted size: mask, x, y, nodes, iei.[37]  ⍝    units          Integer grid with unit # for each contingent unit.   Converted from a polygon shapefile with[38]  ⍝                   makeunits.aml, or created by ROADBLOBS and makeroadunits.aml.[39]  ⍝    units.txt      More information about contingent units.  Unit #, centroid-x, centroid-y, unit name/id, maybe other stuff.[40]  ⍝    noderep.txt    Table with rows for nodes and columns for communities, giving proportional representation for each[41]  ⍝                   community.  Rows sum to 1.  Created by NODEREP.[42]  ⍝[43]  ⍝Results:[44]  ⍝    conduct<n>     Grid(s) with conductance, one for each of bandwidths[45]  ⍝    maxpaths<n>    Grid(s) with maxpaths (like conductance, but sums instead of max, for MAKECOOKIES), one for each bandwidth[46]  ⍝    irreplace      Grid with irreplacability; ignores bandwidths[47]  ⍝    internode.txt  List of each node1 node2 for which edges exist.  Provides an index into edges files.[48]  ⍝    n1-n2edges.txt A separate table for each pair of nodes with an edge, corresponding to rows of internode.txt.  Filename[49]  ⍝                   is <node1>-<node2>edges.txt. These tables have the following items, tab-delimited:[50]  ⍝       edgeno      Edge index within this internode pair, from 1 to npaths[51]  ⍝       unit        contingent unit traversed by path (0 if no units in path)[52]  ⍝       distance    Distance (m) between pair of nodes[53]  ⍝       cost        cost for this contingent unit (if units = 'passages').  This is total cost for all cells in this unit[54]  ⍝                   traversed by the path.[55]  ⍝    <drawpaths>.txt, <drawpaths>f.txt, <drawpaths>t.txt[56]  ⍝                   Text files for drawpaths, if selected.  Use drawpaths.aml to create a vector coverage from these:[57]  ⍝                   &r drawpaths <drawpaths>.  Result will be shapefiles of from-points, to-points, and paths.  Ids for[58]  ⍝                   points and paths are ffftttppp, where f = from-node, t = to-node, and p = path.  Note that you'll get[59]  ⍝                   a mess if there are more than 999 nodes or paths.  There's a column for community too.[60]  ⍝B. Compton, 18 Oct 2012-14 Mar 2013[61]  ⍝14 Mar 2013: drop checks for connectivity--we're doing it a different way[62]  ⍝31 Oct 2013: bug--when only 1 bandwidth, didn't write conductance[63]  ⍝22 Nov 2013: don't use LOAD[64]  ⍝4 Dec 2013: pass header of crossings table and score column to SETTINGS[65]  ⍝11 Jul 2014: add units='none' and read bankcrossings as a vector mosaic[66]  ⍝22 Jul 2014: add irreplacability metric; 23 Jul: take max, not sum among internodes[67]  ⍝24 Jul 2014: round conductance a bit[68]  ⍝7 Nov 2014: write maxpaths for MAKECOOKIES[69]  ⍝20 Nov 2014: read large enough blocks around nodes to actually work properly (was reading buffered centroid, now reading buffered MER)[70]  ⍝7 Jan 2015: move reading ecological settings grids out of the community loop![71]  ⍝7 Jan 2015: do 2 passes and scale maxpaths by a function of pconnect[72]  [73]  [74]  [75]   time←2⍴⎕AI[2][76]   cpars←GETINFO 'connect'                        ⍝Construct call to CONNECT & read CONNECT's parameters[77]   READPARS 'connect'[78]   READPARS ME                                    ⍝Uses connectedness parameters by default, but can override them in [linkages][79]   :if 1≡≡3⊃A                                     ⍝If only one bandwidth, deal with nesting depth[80]      A[3]←⊂,A[3][81]   :end[82]   override_pars←'[connect]',⎕TCNL,(T⍳⎕TCNL)↓T←1↓EXTRACTPARS ME     ⍝Override CONNECT parameters with those set for FINDPATHS[83]   cpars[1]←⊂GRIDNAME 1⊃cpars[84]   cpars[4]←⌈(bandwidth←⌈/bandwidths←,bandwidths)×search÷cellsize   ⍝Bandwidth is max of supplied bandwidths[85]   npaths←,npaths                                 ⍝npaths may have 2 elements, in which case we'll do 2 passes for maxpaths scaling[86]   buffer←0[87]  [88]   N←0 1 TABLE pathQ,'tables\nodes.txt'           ⍝List of all nodes[89]   T←0 1 TABLE pathQ,'tables\nodevalues.txt'      ⍝and get IEI-weighted size of each node[90]   nc←⌊.5+npaths∘.×TABLE pathQ,'tables\noderep.txt' ⍝Read node community representation table and scale by npaths[91]   N[;5]←T[T[;4]⍳N[;1];5]                         ⍝which we'll use for node importance[92]   scale←npaths[⍴npaths]×MEAN 2↑N[⍒N[;5];5]       ⍝Scaling for conductance - all paths making full connection between two biggest nodes is 1.0[93]   M←((⍳1↑⍴N)∊(⊃⊃S)+¯1+⍳2⊃⊃S)⌿N                   ⍝Nodes that we're doing in this thread[94]   M[;4]←(M[;4]≠¨'''') SLASHEACH M[;4]            ⍝Drop quotes from Arc[95]   fc←(LOOK¨fc),fc←1 0 TABLE pathI,communities    ⍝Read focal community table[96]   fc←((⊂'')⍴¨fc[;1]),fc                          ⍝Add 1st column with single class for community group[97]   fi←MV⍪((⊃,/⍴¨fc[;2])/fc[;1]),[1.5]⊃,/fc[;2]    ⍝Community remap index[98]  [99]   cross←TABLE pathM PATH crossscores             ⍝Get formula for crossing scores[100]  linkages←2                                     ⍝Call CONNECT as linkages subroutine, but don't use square kernels[101] [102]  :if units≡'passages'                           ⍝If doing passages,[103]     score←TABLE pathM PATH scores               ⍝   Get linkage scores[104]     ss←MATIN pathT PATH scales                  ⍝   Get original settings variable scales[105]  :end[106] [107]  N[T;4]←⍕¨N[T←(N[;4]≡¨⊂'')/⍳1↑⍴N;1]             ⍝Replace empty names[108]  M[T;4]←⍕¨M[T←(M[;4]≡¨⊂'')/⍳1↑⍴M;1][109]  fromto←(1+fromto≡0) ⊃ fromto ((⍳1↑⍴N) (⍳1↑⍴M))[110]  ⎕←'From-nodes:'[111]  ⎕←' ',' ',' ',(⎕PW-3) TELPRINT VTOM '.''.' TEXTREPL MTOV MIX N[1⊃fromto;4][112]  ⎕←'To-nodes:'[113]  ⎕←' ',' ',' ',(⎕PW-3) TELPRINT VTOM '.''.' TEXTREPL MTOV MIX M[2⊃fromto;4][114] [115] [116]  points←0 8⍴0[117]  E←0 2⍴0[118]  I←0[119] L3:→((1↑⍴M)<I←I+1)/L13                          ⍝For each to-node,-----[120]  BREAKCHECK[121]  →(~I∊2⊃fromto)/L3[122]  LOG 'Processing to-node #',(⍕M[I;1]),', ',⊃M[I;4] ⋄ FLUSH[123] [124]  T←(FINDCELL M[I;7 10]),(⌽⌈(M[I;9 10]-M[I;7 8])÷cellsize),⌈(bandwidth×search)÷cellsize   ⍝   window in terms of cells: MER + buffer[125]  bc←((4⍴M[I;2 3])+¯1 ¯1 1 1×1+cellsize+⌈bandwidth×search) READVEC bankcrossings      ⍝   Read bank crossings table[126]  bc[1]←⊂(⊃bc)[;(⍳1↓⍴⊃bc)~((2⊃bc) COL 'terrestrial')][127] [128]  block←¯1,T[129]  X←READ 3⊃1⊃A                                   ⍝   Read land,[130]  O←0 MVREP READ 1⊃1⊃A                           ⍝   read nodes grid[131]  :if units≡'none'[132]     V←(⍴O)⍴0[133]  :else[134]     V←0 MVREP READ 2⊃1⊃A                        ⍝   and units (unless units = 'none')[135]  :end[136]  →(0∊⍴Y←S '' INCLUDE (⍴X)⍴1)/L3                 ⍝   If all masked out, on to next node[137]  X←(fi[;1],0)[fi[;2]⍳X]                         ⍝   remap landcover to focal community groups[138]  Y←Y×O=M[I;1]                                   ⍝   Cells in this node[139]  :if conduct                                    ⍝   If writing conductivity and irreplacability grids,[140]     H2←(Hx←H←((⍴bandwidths),⍴X)⍴0)[1;;]         ⍝      create templates[141]  :end[142]  ⎕←'   (reading settings)' ⋄ FLUSH[143]  set←(cross (bc,⊂'terrestrial')) SETTINGS (2⊃A) 'anthro1' 'resist dist'  ⍝   Read ecological settings grids for natural and anthro groups[144]  probs←((1↑⍴N),2)⍴0[145] [146]  I0←0[147] L20:→((⍴npaths)<I0←I0+1)/L3                     ⍝---For each pass (if doing maxpaths scaling),[148]  pass1←I0<⍴npaths                               ⍝   pass1 is true if we're doing maxpaths scaling now[149]  ⎕←'      (pass ',(⍕I0),' of ',(⍕⍴npaths),')' ⋄ FLUSH[150] [151]  J←0[152] L4:→((1↑⍴fc)<J←J+1)/L12                         ⍝------For each focal community,-----[153]  BREAKCHECK[154]  ⎕←⎕TCNL,'   Community: ',⊃fc[J;3] ⋄ FLUSH[155]  T←(+/,Q←Y×X∊⊃fc[J;1])⍴0                        ⍝         Select random cells in focal community in this node to build kernels for and set mask[156]  →(0∊⍴T)/L4                                     ⍝         Skip this community if it doesn't exist in this node[157]  T[(kernelpoints⌊⍴T)?⍴T]←1[158]  Q←(⍴Q)⍴(,Q)\T[159]  linkgrids ← (X Q) set[160]  ⎕←'      (connect)' ⋄ FLUSH[161]  conductance←0[162]  cpars CONNECT S[163]  res←res÷⌈/,res[164]  res←100 2 LITTLEBUMPS res cpars bandwidth S    ⍝         add little kernel bumps so we don't wander in the end[165]  res←res÷⌈/,res                                 ⍝         scale kernel so maximum cell is 1.0[166]  res←MVREP res (X=MV)[167]  Q←0⍪(0,res,0)⍪0                                ⍝         and pad it[168] [169] [170] ⍝Convert kernel to n×8 matrix of relative probabilities[171]  P←(8,⍴Q)⍴0[172]  D←8 2⍴¯1 ¯1 ¯1 0 ¯1 1 0 ¯1 0 1 1 ¯1 1 0 1 1    ⍝         8 neighbors, in row-major order[173]  L←0[174] L5:→(8<L←L+1)/L6                                ⍝         For each neighbor,[175]  P[L;;]←D[L;1]⊖D[L;2]⌽Q                         ⍝            get value of each neighbor (1 = up to the left, 2 = up, and so on)[176]  →L5[177] L6:P←0 1 1↓0 ¯1 ¯1↓P                            ⍝         drop padding[178]  P←(~P∊0,MV)×T÷(⍴P)⍴+⌿T←wanderlust+(1-wanderlust)×(P-(⍴P)⍴⌊⌿P)÷(⍴P)⍴(⌈⌿P)-⌊⌿P       ⍝         range rescale probabilities[179]  :if wanderlust=0                               ⍝         If wanderlust is set to 0,[180]     P←P÷(⍴P)⍴+⌿P←P=(⍴P)⍴⌈⌿P                     ⍝            use least-cost path (ties will be resolved randomly)[181]  :end[182]  :if momentum≡0                                 ⍝         If we're not using momentum,[183]     P←+⍀¯1 0 0↓P                                ⍝            Only need 7 cutpoints; take cumulative sum so we can use 1++/?≥P[184]  :end[185]  W←(X×Y)=fc[J;1]                                ⍝         to-cells[186] [187]  ⎕←'Time: ',⍕⎕AI[2]-time[2] ⋄ time[2]←⎕AI[2][188]  ⎕←'      (nodes)' ⋄ FLUSH[189]   ⍝(MVREP res (X=MV)) WRITEBLOCK  (⊂pathQ,'working\res'),(block[2 3]-block[6]),(1+2⍴2×block[6]),0,2,1     ⍝For debugging......[190] [191]  K←0[192] L7:→((1↑⍴N)<K←K+1)/L4                           ⍝---------For each from-node,-----[193]  BREAKCHECK[194]  →(~K∊1⊃fromto)/L7[195]  →((nc[I0;K;J]=0)∨N[K;1]=M[I;1])/L7             ⍝            but not to-node, and not if this community isn't in from-node[196]  →(0=+/,res×O=N[K;1])/L7                        ⍝            and only if the kernel actually reaches the node[197]  →(0=+/,(O=N[K;1])^X∊fc[J;1])/L7                ⍝            and only if this community isn't cutoff in this node[198]  ⍝Z←(0,3+units≡'passages')⍴0[199]  ⎕←'      From-node #',(⍕N[K;1]),', ',(⊃N[K;4]),' (',(⍕K),' of ',(⍕1↑⍴N),')' ⋄ FLUSH[200]  Z←0 4⍴0[201]  H3←(⍴H2)⍴0[202] [203]  L←0[204] L8:→(nc[I0;K;J]<L←L+1)/L11                      ⍝------------For each path,-----[205]  BREAKCHECK[206]  T←(+/B←,(O=N[K;1])^X∊fc[J;1])⍴0                ⍝               pick random start cell in focal community in from-node[207]  T[?⍴T]←1[208]  F←,INDICES (⍴O)⍴B\T[209]  →(0=res[F[1];F[2]])/L8                         ⍝               if starting point has no kernel value, skip it--we'll adjust when calculating P(c)[210]  DOT[211]  ⍝ TEST .5 .6 .75[212]  Q R ← P RPATH F W                              ⍝               build random low-cost path, returning grid and coordinate representations[213]  U←(1⌈⍴U)↑U←UNIQUENZ ,V×Q≠0                     ⍝               units traversed by path (or 0 if no units)[214]  :if ~pass1[215]     (N[K;1]) (M[I;1]) ((N[K;1]×1E6)+(M[I;1]×1E3)+L++/nc[I0;K;⍳J-1]) drawpaths F (R[''⍴1↑⍴R;]) (fc[J;1]) DRAWPATH R   ⍝            draw paths if appropriate (id is ffftttppp)[216]  :end[217] [218]  G←1⊃2⊃linkgrids[219]  :if units≡'passages'                           ⍝               If passage units,[220]     Q←(Q⌊1+(⌈/,Q)×V=0)×(⍴Q)⍴~B\~(T⍳T)=⍳⍴T←(B←,(Q≠0)^V≠0)/,V     ⍝               only allow 1 cell per road unit ###[221]  :end[222]  C←cellsize×+/,1+multiplier×(f←(2⊃2⊃linkgrids)[;2]×G[;F[1];F[2]]) EUDIST ((⍴t),1)⍴t←(,Q)/((1↑⍴G),×/1↓⍴G)⍴G    ⍝               Resistance values for focal cell I,J.  Focal cell is always 0 for anthro settings.[223]  :if U≡,0                                       ⍝                  If no units in path,[224]     C←1 2⍴C,0                                   ⍝                     just return ∆cost = 0[225]  :else                                          ⍝                  else,[226]     G←((⍴t),1)⍴t←(((1↑⍴G),×/1↓⍴G)⍴G)[;(,V)⍳U]   ⍝                     only care about costs of involved units (only want 1 cell per unit),[227]     D←1+multiplier×f EUDIST G                   ⍝                     original costs for units[228]     G←score ((⍳⍴U),[1.5]1) ((2⊃2⊃linkgrids)[;1]) ss ((2⊃2⊃linkgrids)[;3]) LINKAGEMOD G[229]     D←,D-1+multiplier×f EUDIST G                ⍝                     difference with modified cost[230]     C←C,[1.5]cellsize×D×+/U∘.=(t≠0)/t←,V×Q≠0    ⍝ **** IS THIS STILL RIGHT? (3/5/13) *****       distance, cost for each unit, in Rm (taking into account multiple cells traversed in unit *but must remove ### above)[231]  :end[232]  Z←Z⍪(L++/nc[I0;K;⍳J-1]),(((⍴U),1)⍴U),C         ⍝               edge no, units traversed by path, prob (if development) or (distance,∆cost) (if passages)[233] [234]  :if conduct^~pass1                             ⍝               If writing conductance and irreplacability grids,[235]     T←(Q≠0)×~O∊M[I;1],N[K;1]                    ⍝               path presence, but mask from- and to-nodes from conductance[236]     H3←H3+T÷npaths[⍴npaths]×2                   ⍝               irreplacability - number of paths, scaled by npaths×2, so a cell used by every path between pair of nodes = 1.0, summed within internode[237]     p←bandwidths GAUSS¨''⍴C                     ⍝               P(connect) for this path for each bandwidth[238]     D←(MEAN N[K,N[;1]⍳M[I;1];5])÷scale          ⍝               scaling for this path, proportional to mean node size[239]     H←H+↑p×¨⊂T×D                                ⍝               conductance (linkage index), scaled by P(connect) and node sizes, such that maximum possible = 1[240]     Hf←(1+1<⍴npaths)⊃ 1 (1-⍟1+÷/probs[K;])*scaling ⍝               scaling factor for maxpaths if we're using it[241]     Hx←Hx⌈Hf×↑p×¨⊂T×D×npaths[⍴npaths]           ⍝               maxpaths is like conductance, but use max, not sum[242]  :end[243]  →L8                                            ⍝            Next path L[244] [245] [246] L11:[247]  →(0∊⍴Z)/L7                                     ⍝      If we've built any paths between these nodes,[248]  :if pass1                                      ⍝         If 1st pass, we're just summing P(connect)[249]     probs[K;]←probs[K;]+(+/bandwidth GAUSS Z[;3]),1↑⍴Z    ⍝         Take cumulative sum of link probabilities & number of links[250]  :else[251]     H2←H2⌈H3                                    ⍝         Take max (not sum) of irreplaceability among internodes[252]      head←''[253]     Z TMATAPPEND pathQ PATH 'tables\',(⍕N[K;1]),'-',(⍕M[I;1]),'edges.txt'    ⍝               Write edges file (no need to lock)[254]     E←E⍪N[K;1],M[I;1][255]    :end[256]  ⎕←'Time: ',⍕⎕AI[2]-time[2] ⋄ time[2]←⎕AI[2][257]  →L7[258] [259] L12:[260]  :if ~pass1[261]      :if conduct                                                                        ⍝            If writing conductance grids,[262]        T←1↓block+0,¯1 ¯1 2 2 ¯1×block[6][263]        (MVREP H2 (X=MV)) WRITEBLOCK (⊂1⊃3⊃A),T,3,1                                     ⍝               write irreplacability (transparently using max)[264]        :for Q :in ⍳⍴bandwidths                                                         ⍝               For each bandwidth, write conductance (transparently using sum)[265]           (MVREP (5 ROUND H[Q;;]) (X=MV)) WRITEBLOCK (⊂(Q+1)⊃3⊃A),T,2,1                ⍝                  conductance is additive[266]           (MVREP (5 ROUND Hx[Q;;]) (X=MV)) WRITEBLOCK (⊂(Q+1+⍴bandwidths)⊃3⊃A),T,3,1   ⍝                  maxpaths uses max[267]        :end[268]     :end[269]  :end[270]  →L20                                           ⍝   Next pass[271] [272] L13:→(0∊⍴E)/L14[273]  E←E[⍋E;][274]  E←(∨/E≠0⍪¯1 0↓E)⌿E                             ⍝Remove duplicates from internodes (they're from multiple communities)[275]  E LOCKWRITE pathQ,'tables\internode',('_' NAME 'repname'),'.txt'       ⍝Write to internodes file[276] [277]  →(0≡drawpaths)/L14[278]  head←''[279]  points[;1 4 5] LOCKWRITE (pathQ,'results\pathsf.txt') ','[280]  points[;1 6 7] LOCKWRITE (pathQ,'results\pathst.txt') ','[281]  ⎕←⎕TCNL,'In Arc, &r drawpaths ',pathQ,'results\'[282] [283] L14:⎕←'Total time: ',⍕⎕AI[2]-time[1][284]  →0[285] [286] [287] [288] what:auxiliary[289] type:table[290] init:SINK 3 ⎕CMD 'del ',pathQ,'tables\*edges.txt'    ⍝Erase *edges.txt so we can safely append[291] init:head←'' ⋄ (0 0⍴'') TMATOUT (drawpaths≠0)/pathQ,'results\pathsf.txt'    ⍝(Re)create path files on start[292] init:head←'' ⋄ (0 0⍴'') TMATOUT (drawpaths≠0)/pathQ,'results\pathst.txt'[293] init:head←'' ⋄ (0 0⍴'') TMATOUT (drawpaths≠0)/pathQ,'results\paths.txt'[294] init:head←1↓⎕TCHT MTOV MATRIFY 'from to' ⋄ (⊂0 0⍴'') TMATOUT¨(⊂pathQ,'tables\internode'),¨('_' ALLNAMES 'FINDPATHS'),¨⊂'.txt'[295] info:(('*',pathQ,'source\nodes') ('*',pathQ,'source\units') 'land') ('settings') ((⊂pathQ,'results\irreplace'),((⊂pathQ,'results\'),¨(⊂'conduct'),¨KNAMES bandwidths),((⊂pathQ,'results\'),¨(⊂'maxpaths'),¨KNAMES bandwidths)) 0 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid[296] check:CHECKVAR 'units npaths wanderlust drawpaths kernelpoints communities fromto momentum scores bandwidths conduct scaling'    ∇