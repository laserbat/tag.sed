# Universal computation from repeated substitution

If you ever tried to code something complex with `sed`, you probably know that it has labels and jumps that you can use to do some pretty interesting things. 

For example, you can use 

`sed -E ':a s/(.)(.*)\1/\1\2/g; ta'`

to get all unique characters from a string. It is impossible to do this with a single substitution, but by repeatedly applying it until there are no matches you can overcome this limitation of regular expressions.

You can even use `sed` to simulate Turing-complete systems like [Conway's Game of Life](https://github.com/laserbat/unix-voodoo/blob/master/gol.sed) or interpret [brainfuck](https://github.com/laserbat/sedbf/blob/master/sedbf.sed) code.

Both of these examples are relatively complex: they use multiple loops/branches and lots of substitutions. This made me wonder, what would the simplest `sed` program (or any program that uses just loops and substitutions) capable of universal computation would look like? How many loops and how many substitutions do you actually need to do an arbitrary calculation?

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

Simulating tag systems
---

Say, we have a tag system with the following rules:

    a -> bc
    b -> a
    c -> aaa

Let's transform it a bit and append to the initial word `'aaa'`, using a `'!'` to separate them:

    aaa!a:bc b:a c:aaa

Now that we know what our input might look like, we can start building a regex. First, capture the initial character of the word, ignoring the second and matching the rest of it:

    ^(.).(\w*)! 

You have to use `\w` in the second group to avoid matching `'!'`.

Now, we know that our first character exists somewhere in the second part of our input, separated by a `':'` from some word. We can use a backreference here to actually find it and get the matching word:

    ^(.).(\w*)!(.*\1:(\w*).*)

We have to math the whole second part of the word first and then add `.*` at the start and the end of our capture group, to skip any irrelevant characters. `\1` here references our first capture group, the first character of our input. `:(\w*)` matches `:` that separates this character from the rest of production rule and `(\w*)` matches any string of alphanumeric characters.

Now that we matched all the interesting parts of our string, we can use substitution to reconstruct it into a new version:

    s/^(.).(\w*)!(.*\1:(\w*).*)/\2\4!\3/

We skip the first 2 characters but keep the rest of the word (`\2`), append to it the rule found in the second part of input (`\4`) and put the complete second part of input unchanged at the back of the resulting string, separated from the rest of it by a `'!'`.

Results
---

    # Any 2-tag system
    s/^(.).(\w*)!(.*\1:(\w*).*)/\2\4!\3/

    # Any 3 neighbor 1D CA or something like (1/3)-tag system
    s/^(.(..))(\w*)#(.*\1:(\w+).*)/\2\3\5#\4/

    # Wolfram's rule 110 with fixed size world
    s/(^(0) 1(11)| 0(1)| (.))(.*)/\2 \3\4\6\5\4\2/

    # Cyclic tag system
    s/^(0(\w+)!(\w*)|1(\w+)!(\w*))!(.*)!/\2\4\5!\6!\3\5!/

    # Wolfram's rule 110 with expanding world
    s/(^(0) (q)|^(0) 1(11)| 0(1)| (.))(.*)/\2\4 \5\6\8\7\6\4\3\2/
