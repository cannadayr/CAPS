﻿    ∇ A EDGES S;D50;DS;weights[1]   ⍝CAPS 3.0 microclimate alterations metric (edge effects)[2]   ⍝B. Compton, 27 Jan 2010, from CATS[3]   ⍝New version replaces old multi-edge class version, uses DEVINT[4]   [5]   [6]    READPARS ME[7]    A DEVINT S[8]    →0[9]   [10]  what:CAPS stressor[11]  type:standard[12]  info:('land') ('') ('edges') (SEARCH (D50,DS)÷cellsize) 'include'      ⍝Source grid, settings table, result grid, buffer size, and include grid[13]  check:CHECKVAR 'D50 DS weights'[14]  check:CHECKCOVER 'weights'    ∇