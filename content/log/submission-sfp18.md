---
title: "Research Log: August 23, 2018"
date: 2018-08-23T11:20:13-04:00
draft: True
use-summary: False
layout: log
---

Research Goals

# Current Work

- [ ] Make easy fixes from SFP reviews
  - [ ] **Important** Define catastrophic failure as above some
  constant or asymptotic change in complexity.
  - [ ] **Important** Explain that empirical results showed little
    additional information
      after 900 samples  
  - [ ] **Important** Link the github repo
  - [ ] Be more explicit about our contributions
  - [X] Rename: An Efficient Compiler for the Gradually-Typed Lambda Calculus
  - [ ] List scheme language features
  - [ ] No type inference (why?)
  - [ ] Describe modifications to benchmarks
  - [ ] Make sure we are explicit about this somewhere  
  line 185: "and compiles them to C" Does Grift support proper tail
  calls?  This plays a role in space-efficient Gradual Typing (as
  Herman observes), it's important to be clear about this, especially
  as it may affect the interpretation of your benchmarks.
  - [ ] Fix to be more in line with what the compiler was doing  
  line 283: "If so, Grift builds a new proxy closure by copying // the
  wrapper..." on reading this, it took extra thought to tell if
  "copying over" meant "duplicate" the wrapper function or "overwrite"
  the wrapper function.
  - [ ] Add reference to Graham's book
  - [ ] Explain why calling the completely dynamic variant "dynamic grift"
    would be a bad idea.
  - [ ] Explain idea performance
  line 628: "as mentioned in the introduction the ideal performance
  model would be a linear model."  I don't think "ideal" is the right
  word for this.  The linear model is "ideal" in the sense of a
  programmer's pipe-dream of how gradual typing would work,
  given that purely statically-typed languages tend to run faster than
  purely dynamically-typed languages.
- [ ] Build table comparing implementations
  - [X] Figure out table syntax and build skeleton
  - [ ] Populate skeleton
  - [ ] Read enough of paper to characterize other work
- [ ] Make decisions about how to address
  - [ ] 491 - ‘Space-efficient coercions offer a “pay as you go” cost
  model’ - I don’t understand the use of this idiom, I feel like this
  paragraph is better off without it.
  - [ ] Should we describe lazy coercion creation?
- [ ] Make charts in figure 5 easier to read  
  fig 5 - these graphs are neat, but difficult to read, even if I zoom
  in.  for example, trying to figure out what’s happening with the gap
  on the X-axis in the lower left-hand corner - presumably green
  markers exist somewhere on the line for 1 and I just can’t see them?
- [ ] Come up with strategy to address this
  In section two, the author talks about chains of proxies causing
  performance degradation. This seems like a disingenuous straw
  man. It seems to me that no reasonable real-world implementation of
  gradual typing would suffer from this problem. It seems like a
  trivial issue to avoid.
- [ ] Reread section 1 and 2
- [ ] Decide whether or not to accept this change  
  line 26: "know that runtime /computations/ respect their compile-time
  types"  since in general types can be about more than values, you
  might want to speak more generally here.
- [ ] Rewrite section 1 and 2 to be more unified
- [ ] Make macro to blind references
  line 187: "is described in a technical report [Kuhlenschmidt et al.]"
  Since the workshop is single-blind, this is not an issue, but given
  that the paper was submitted with anonymous authors, it's worth noting
  (for future submission purposes) that this citation de-blinds the
  draft.
  
- [ ] Improve benchmark results for this paper   
  - [ ] Investigate blackscholes dynamic performance measurement.    
  fig 5 blackscholes runtime - I’m confused how Dynamic Grift is
  almost 2x slower than Grift with very low %s of the code typed (very
  near the Y-axis).  I take this to mean that adding any type
  information anywhere leads to a 2x speedup, and then subsequent
  annotations have extremely diminished returns.  Do I misread?  or is
  there an explanation for this behavior, perhaps due to the structure
  of the benchmark?
  - [ ] Make sure graphs don't show .5 proxy chains.
  
# Notes

- [ ] This is a really clean description of our paper. Should we
  use some or all of this?  
  This paper presents the design and performance evaluation of Grift,
  a compiler for a gradually typed subset of Scheme to native code
  (via C).  Unlike other performance-focused implementations, Grift
  exploits coercions, which have received substantial theoretical
  investigation in the past, and compares them to type-based casts,
  which are more in line with existing implementation strategies.  The
  paper presents evidence that coercions (and monotonic reference
  semantics) yield comparable performance to that of non-gradual
  language implementations and competitive performance with that of
  type-cast based implementation strategies, suggesting that they
  deserve further investigation.  
  In light of a recent flurry of investigations of implementation
  strategies for gradual typing (including the cited papers that
  appeared at OOPSLA 2017), this work is timely, informative, and
  important, and there is indeed more to be done.

<!-- line 628: "as mentioned in the introduction the ideal performance -->
<!-- model would be a linear model."  I don't think "ideal" is the right -->
<!-- word for this.  The linear model is "ideal" in the sense of a -->
<!-- programmer's pipe-dream of how gradual typing would work, -->
<!-- given that purely statically-typed languages tend to run faster than -->
<!-- purely dynamically-typed languages. -->

But taking interoperability into account, one might more reasonably
expect that rates of data flow across static and dynamic borders would
be the limiting factor, not how many static annotations are present,
even in the optimal implementation strategy.  Thus, as
you get closer to "fully-dynamic" or "fully-static", you would expect
fewer border-crossings and thus faster code
(up to the limitations of a dynamic runtime).

By this I mean that there is technical reason (only aspirational
desires) to believe that the optimal implementation strategy for a
gradually-typed language is going to yield a linear model, even if
restricted to mixing, e.g., Scheme-style dynamic typing with
Haskell-style static typing.  In the case of adding richer types (say
Liquid Haskell types on top of Haskell-style typing), both extremes
may run exactly the same speed (especially since Liquid Haskell has no
special type-based optimizations since it's just a type-checker), but
the middle will be slower because code that causes interactions
between simple typing and liquid typing must have some types enforced
dynamically.

# Future work
