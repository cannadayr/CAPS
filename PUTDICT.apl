﻿    ∇ PUTDICT;T;C;head[1]   ⍝Write the scenarios dictionary and return the lock[2]   ⍝B. Compton, 22 Jun 2012[3]   [4]   [5]   [6]    head←1↓⎕TCHT MTOV dict_[7]    dict TMATOUT csedir,'scenarios.txt'                    ⍝Write dictionary[8]    RETURNLOCK csedir    ∇