﻿    ∇ RESTORECONNECTIONS Q;T[1]   ⍝Restore connections to state saved by SAVECONNECTIONS[2]   ⍝B. Compton, 1 Oct 2013. Government is still shut down.[3]   ⍝10 Oct 2013: updates.  Still shut down.[4]   ⍝24 Oct 2014: use window instead of set to check for active window in local mode[5]   [6]   [7]   [8]    CLEANUP[9]    →(0∊⍴Q)/0[10]   connections activeconnection workingresolution referencewindow mosaic mosaicwindow ← Q[11]   :if connections[activeconnection[1];connections_ COL 'local']∨activeconnection[2][12]      ∆GRIDINIT ''[13]      :if ~0∊⍴⊃connections[activeconnection[1];connections_ COL 'window'][14]         T←∆MAKEWINDOW ⊃connections[activeconnection[1];connections_ COL 'window'][15]      :end[16]   :else[17]      ∆GRIDINIT connections[activeconnection[1];connections_ COL 'server port log'][18]   :end    ∇