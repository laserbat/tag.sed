#!/bin/sed -Ef

# Input:
# 0 <world>
# Where world is the initial state of the world (0s and 1s)

# longer regex that increases the size of the world each loop
# Assumes that you have a 'q' somewhere in your world
# Otherwise does exactly tha same thing as the normal version

# s/(^(0) (q)|^(0) 1(11)| 0(1)| (.))(.*)/\2\4 \5\6\8\7\6\4\3\2/

# Variation of code below but using backrefs, can be used to 
# simulate any 3 neighbor 1D CA.
# Input:
# <world>#<rule1>:<w1> <rule2>:<w2> ... <ruleN>:<wN>
# Where ruleN is any 3 symbols and wN is any word (including empty)
# Note the similarity with tag systems

# s/^(.(..))(\w*)#(.*\1:(\w*).*)/\2\3\5#\4/

:a
s/(^(0) 1(11)| 0(1)| (.))(.*)/\2 \3\4\6\5\4\2/p
ta
