﻿    ∇ A EDGEPRED S;D50;DS;weights[1]   ⍝CAPS edge predators metric[2]   ⍝B. Compton, 29 Jan 2009[3]   [4]   [5]    READPARS ME[6]    A DEVINT S[7]    →0[8]   [9]   what:CAPS stressor[10]  type:standard[11]  info:('land') ('') ('edgepred') (SEARCH (D50,DS)÷cellsize) 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid[12]  check:CHECKVAR 'D50 DS weights'[13]  check:CHECKCOVER 'weights'    ∇