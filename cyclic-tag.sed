#!/bin/sed -Ef

# Cyclic tag system
# Input: <word>!<rule1>!<rule2>!...!<ruleN>!
# Halts once all symbols in "word" are used up

# Example input:
# 11001!010!000!1111!

:a
s/^(0(\w+)!(\w*)|1(\w+)!(\w*))!(.*)!/\2\4\5!\6!\3\5!/p
ta
