#!/bin/sed -Ef
# 2-tag system using a single substitution applied in a loop
#
# To transform any 2-tag system into a suitable input for this regexp you need
# to write each production rule in the form of symbol:production
# and then write initial word, followed by !, followed by all production rules
# in any order, separated by !
#
# Example:
#
# Initial word: aaa
# Production rules:
#   a -> bc
#   b -> a
#   c -> aaa
#
# Becomes:
#
# aaa!a:bc!b:a!c:aaa
#
# System halts once word becomes shorter than 2 symbols or we reach a symbol
# without a production rule.
#

:a s/^(.).(\w*)!(.*\1:(\w*).*)/\2\4!\3/p
ta
