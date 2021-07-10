# call-by-meaning-objc

This repository is a demonstration of a simple form of "call by meaning" using the Objective-C Runtime.  It works under both OS X and GNUstep (a GNUmakefile is included).

## Motivation


* _"[N]ames are a local convention, and scaling soon obliterates the conventions."_ -- Alan Kay (paraphrasing Mark Miller)

* _"There are only two hard things in Computer Science: cache invalidation and naming things."_ -- Phil Karlton

Doing something as simple as requesting the length of a string object varies significantly from one language to another... `size()`, `count`, `strlen()`, `len()`, `.length`, `.length()`, etc.  How can one communicate with a computer -- or how can two computers communicate with each other -- at scale, without a common language?

## Call by Meaning

**What if you could refer to functions not by name, but rather by what they do?**.  Objective-C's dynamic runtime methods make it possible to study this question. In this repository, I've implemented a "method finder" that you can use like this:

```objective-c
// Suppose we have a bunch of mystery classes... here MyClass1 and MyClass2.
MethodFinder* finder = [[MethodFinder alloc] initWithClassNames:@[@"MyClass1", @"MyClass2"]];

// These mystery classes might have useful methods in them.  Try to find one:
FoundMethod* found_add = [finder findMethodThatGiven:@[@3, @4] producesOutput:@7];
NSNumber* result = [finder invoke:found_add upon:@[@5, @6]]; // result will be 11

// The following work too:
FoundMethod* found_strlen = [finder findMethodThatGiven:@[@"hello world"] producesOutput:@11];
FoundMethod* found_upcase = [finder findMethodThatGiven:@[@"hello world"] producesOutput:@"HELLO WORLD"];
```

To see more, check out [src/call-by-meaning-objc/main.m](https://github.com/plaurent/call-by-meaning-objc/blob/main/src/call-by-meaning-objc/main.m).

Objective-C is dynamic enough that to get this working I didn't even need to check method signatures... just call away and catch any exceptions. If you expect multiple functions, you can narrow down to the desired specific function by intersecting the results of multiple "findMethods" calls (each call with a different example given).



## Thoughts

### No more "errors"?

When using call by meaning you don't really have "syntax" errors anymore, instead you get ["unknown meaning"](https://github.com/plaurent/call-by-meaning-objc/blob/main/src/call-by-meaning-objc/MethodFinder.m#L45) and ["ambiguous meaning"](https://github.com/plaurent/call-by-meaning-objc/blob/main/src/call-by-meaning-objc/MethodFinder.m#L41) exceptions. An ambiguity exception could be resolved by the caller having a back-and-forth "dialogue" at runtime, with the receiver(s), providing more examples until the meaning were no longer ambiguous.


### Composition

You could extend this search functionality to check (in parallel) for compositions of available functions that together would perform a more complex operation.  An example of a more complex operation would be capitalizing each letter of the words in a sentence -- what would the search for this look like?


### Relationship to Machine Learning

Using Call by Meaning starts to make programming look a bit more like machine learning, blurring the distinction between the two.   Effectively, we are finding a function by giving examples -- not much different form learning such a function (i.e., machine learning). It feels a bit like "1-shot learning" or "n-shot" for very small n.


## References

Alan Kay has often referenced McLuhan and the problem of how "alien" computers could communicate with each other in an Intergalactic network. His institute did some work towards this, published in a paper called "Call by Meaning" -- although their implementation doesn't seem particularly user friendly to me. (http://www.vpri.org/pdf/tr2014003_callbymeaning.pdf)

