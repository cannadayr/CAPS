﻿    ∇ REFRESHSERVERS D;oc;I;dot;B[1]   ⍝Refresh grid servers in the current connections list for drive ⍵ (or all if ⍵='')[2]   ⍝B. Compton, 17 Jun 2014 (Gold Hill, OR)[3]   ⍝7 Apr 2017: take drive argument; 2 May 2017: do it right[4]   [5]   [6]   [7]    →(0=⎕NC'cluster')/0[8]    →(~cluster)/0[9]    oc ← SAVECONNECTIONS               ⍝Save existing connections so we don't mess them up[10]   SETCACHE 0[11]  [12]   B←(0∊⍴D)∨connections[;connections_ COL 'drive'] FIND D←(~0∊⍴D)/D,(':'≠¯1↑D)/':'    ⍝If drive argument supplied, only do for this drive[13]   [14]   ⎕←'Refreshing servers',(~0∊⍴D)/' on drive ',D ⋄ FLUSH[15]   I←0[16]  L1:→((1↑⍴connections)<I←I+1)/L2     ⍝For each connection,[17]   →(~B[I])/L1[18]   ⎕←'Refreshing ',⊃,/' ',¨connections[I;connections_ COL 'server port'] ⋄ FLUSH[19]   SETCONNECTION I[20]   ACTIVATECONNECTION[21]   ∆REFRESHSERVER[22]   →L1[23]  [24]  L2:⎕←⎕TCNL,'Refreshed ',(⍕+/B),' server',((1≠+/B)/'s'),'.' ⋄ FLUSH[25]   RESTORECONNECTIONS oc    ∇