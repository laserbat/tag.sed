cyclic-tag.sed
---

Implementation of a cyclic tag system in sed. Possibly the simplest proof of sed being turing complete when using only `s///` regexp syntax and a single loop.

It takes the initial word and production rules as an input, separated by '!'.

Running an [example cyclic-tag system from wikipedia](https://en.wikipedia.org/wiki/Tag_system#Cyclic_tag_systems) with this code looks like this:

    > echo '11001!010!000!1111!' | ./cyclic-tag.sed | head
