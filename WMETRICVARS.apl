﻿    ∇ Z←WMETRICVARS V;I;Q;T;M;B[1]   ⍝Set up metric grids for watershed metrics ⍵[2]   ⍝Inquire metric for names in 'inputs:' field; if not present, use standard names[3]   ⍝Results are:[4]   ⍝   Z[;1]   metric name[5]   ⍝   Z[;2]   source (usually just metric name, x)[6]   ⍝   Z[;3]   value (x_v)[7]   ⍝   Z[;4]   influenced value (x_iv)[8]   ⍝B. Compton, 2 Mar 2015 (late in the snowiest winter ever)[9]   [10]  [11]  [12]   Z←T,(T,¨⊂'_s'),(T,¨⊂'_v'),[1.5](T←TOLOWER¨V),¨⊂'_iv'   ⍝Names of metrics and default sources and intermediate results[13]   I←0[14]  L1:→((⍴V)<I←I+1)/0                                      ⍝For each metric,[15]   T←(Q←(∨\T ⎕SS 'inputs:')/T←⎕VR TOUPPER I⊃V)⍳⎕TCNL      ⍝   does it have an inputs: field?[16]   →(0∊⍴Q)/L1                                             ⍝   skip this one if not[17]   M←FRDBL¨↓MATRIFY TOLOWER ¯1↓7↓T↑Q[18]   :if ~B←~'(noinf)'≡1⊃M                                  ⍝   If 1st item is '(noinf)', we won't do influenced variables[19]      M←1↓M[20]   :end[21]   Z[I;2 3 4]←(⊂M,¨⊂'_s'),(⊂M,¨⊂'_v'),⊂B/M,¨⊂'_iv'        ⍝   varible names for metric[22]   →L1    ∇