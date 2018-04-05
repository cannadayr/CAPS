﻿    ∇ V FINISH_COLDWATER F;X;X_;D;C;I;Y;Y_;K;Q;head[1]   ⍝Finish coldwater linkages run for base filename ⍵, tempertatures ⍺[2]   ⍝Supply path and filename of highest temperature[3]   ⍝B. Compton, 23 Mar 2017[4]   [5]   [6]   [7]    ⍎(0=⎕NC'V')/'V←14 16 18 20 22'[8]    V←V[⍒V][9]    ⎕←'Reading file for ',(⍕V[1]),' C...' ⋄ FLUSH[10]   X←1 ⎕TCHT ¯1 MATIN F,(⍕V[1]),'.txt'[11]   X_←FRDBL¨↓⎕TCHT MATRIFY head[12]  [13]   D←X_ COL 'aqua_oob bridge_oob mean_aqua moved linkgroup terrestrial aqualci aquauci terruci terrlci mean_terr roadclass adt'[14]   D←(⍳1↑⍴X_)~D                           ⍝Drop crap we don't want[15]   X_←X_[D][16]   X←X[;D][17]   [18]   Q←¯1+X_ COL 'database'                 ⍝   insertion point[19]   X_←(Q↑X_),(⊂'rank'),Q↓X_               ⍝   add ranks (zeros get a rank of zero)[20]   X←X[;⍳Q],((X[;X_ COL 'effect']≠0)×RANK X[;X_ COL 'effect']),(0,Q)↓X[21]   [22]   C←X_ COL 'base alt delta effect effect_ln rank'[23]   X_[C]←X_[C],¨⊂⍕V[1]                    ⍝Change temperature-dependent column names[24]  [25]   I←1[26]  L1:→((⍴V)<I←I+1)/L2                     ⍝For each subsequent temperature file,[27]   ⎕←'Reading file for ',(⍕V[I]),' C...' ⋄ FLUSH[28]   Y←1 ⎕TCHT ¯1 MATIN F,(⍕V[I]),'.txt'[29]   Y_←FRDBL¨↓⎕TCHT MATRIFY head[30]  [31]   Y_←Y_,⊂'rank'                          ⍝   add ranks (zeros get a rank of zero)[32]   Y←Y,(Y[;Y_ COL 'effect']≠0)×RANK Y[;Y_ COL 'effect'][33]  [34]   C←Y_ COL 'base alt delta effect effect_ln rank'[35]   Y_[C]←Y_[C],¨⊂⍕V[I]                    ⍝   change temperature-dependent column names[36]  [37]   Q←¯1+X_ COL 'database'                 ⍝   insertion point[38]  [39]   K←Y[;Y_ COL 'id']⍳X[;X_ COL 'id']      ⍝   index into new file for join[40]   X←X[;⍳Q],(Y⍪0)[K;C],(0,Q)↓X            ⍝   join new columns in proper place[41]   X_←X_[⍳Q],Y_[C],Q↓X_                   ⍝   and do names[42]  [43]  ⍝ X←X,(Y⍪0)[K;1]     ⍝ID FOR TESTING[44]  ⍝ X_←X_,⊂'id',⍕V[I][45]  [46]   →L1[47]   [48]  L2:head←1↓⎕TCHT MTOV MIX X_[49]   X TMATOUT F,'.txt'[50]   ⎕←'FINISH_COLDWATER is done; results are in ',F,'.txt'    ∇