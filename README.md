# Universal computation from repeated substitution

If you ever tried to code something complex with `sed`, you probably know that it has labels and jumps that you can use to code some pretty interesting things. 

For example, you can use 

`sed -E ':a s/(.)(.*)\1/\1\2/g; ta'`

to get all unique characters from a string. It is impossible to do this with a single substitution, but by repeatedly applying it until there are no matches you can overcome this limitation of regular expressions.

You can even use `sed` to simulate Turing-complete systems like [Conway's Game of Life](https://github.com/laserbat/unix-voodoo/blob/master/gol.sed) or interpret [brainfuck](https://github.com/laserbat/sedbf/blob/master/sedbf.sed) code.

Both of these examples are relatively complex: they use multiple loops/gotos and lots of substitutions. This made me wonder, what would the simplest `sed` program (or any program that uses just loops and substitutions) capable of universal computation would look like? How many loops and how many substitutions do you actually need to do any calculation?

Tag systems
----


[Tag systems](https://en.wikipedia.org/wiki/Tag_system#Cyclic_tag_systems) are very simple models of computation. Despite their simplicity, they can be Turing-complete, which means that they are able to simulate any Turing machine. 

A tag system has a word that it operates on and a list of production rules. Each production rule associates a single symbol with a word. Each symbol used must have a production rule associated with it, unless it's a halting symbol.

We can simulate a single step of a m-tag system with the following algorithm:

1. Read the first symbol of the word
2. Append the symbols of the corresponding production to the word
3. Drop first m symbols of the word

If we reach a point where this word becomes shorter than m or it starts with a halting symbol we can say that tag system has halted. 

It's important to note that if `m > 1`, m-tag system is Turing-complete. Since 2-tag systems are the simplest Turing-complete tag systems, I'll focus mainly on them. I'll also talk about cyclic tag systems, which are also very simple, though they behave in a slightly different way.

