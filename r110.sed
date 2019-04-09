#!/bin/sed -Ef

# longer regex that increases the size of the world each loop
# s/(^(0) (q)|^(0) 1(11)|^0 (1)|^0 0(1)|^0 (0))(.*)/0 \5\7\9\8\7\6\4\3\2/p

:a
s/(^(0) 1(11)|^0 ((1)|0(1)|(0)))(.*)/0 \3\6\8\7\6\5\2/p
ta
