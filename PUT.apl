﻿    ∇ ∆n∆ PUT ∆v∆;∆f∆;∆x∆;∆m∆;∆q∆;∆i∆;∆t∆[1]   ⍝Write variable named in ⍵ to Arc grid, with optional name ⍺[2]   ⍝Call Arc to convert ascii grid (unless global noarc is set)[3]   ⍝B. Compton, 21 Feb 2006[4]   [5]   NEEDS UPDATING TO USE GRIDIO DLL[6]   [7]    ∆x∆←⍎∆v∆[8]    ⍎(0=⎕NC'∆n∆')/'∆n∆←∆v∆'[9]    ∆f∆←~∆x∆≡⌊∆x∆[10]   (∆n∆←pathR PATH (FRDBL ∆n∆),(~'.'∊∆n∆)/'.asc') TOARC ∆x∆[11]   →(0=⎕NC'noarc')/L0 ⋄ →noarc/0[12]  L0:∆m∆←FRDBL (^\∆n∆≠'.')/∆n∆[13]  [14]   ∆q∆←'/* arc.aml' OVER '/* Automatically generated by PUT, ',NOW[15]   ∆q∆←∆q∆ OVER 'asciigrid ',∆n∆,' ',∆m∆,' ',∆f∆/'float'[16]   ∆q∆←∆q∆ OVER 'del ',∆n∆[17]   ∆q∆←∆q∆ OVER 'del arc.aml' OVER 'q'[18]   ∆i∆←0[19]  L1:→(~IFEXISTS PATH 'arc.aml')/L3           ⍝   If arc.aml still exists,[20]   →(1<∆i∆←∆i∆+1)/L2[21]   ⎕←'*** Waiting for arc.aml to finish ***'[22]  L2:∆t∆←⎕DL 10                               ⍝      wait 10 seconds and try again[23]   →L1[24]  L3:(MTOV ∆q∆) NWRITE pathR PATH 'arc.aml'   ⍝   Write out arc.aml and run it[25]   ARC pathR PATH ''[26]   ⎕←∆v∆,' written to ',∆m∆    ∇