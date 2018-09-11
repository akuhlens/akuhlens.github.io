---
title: "Insert Witty Title Here"
date: 2018-03-26T16:23:27-04:00
draft: true
use-summary: true
layout: post
---
Gradually typed programming languages are known to suffer
from space leaks. This post addresses space inefficiency
that arises from implicit casts that disrupt an otherwise
tail recursive call.
28
<!--more-->

TODO:
- [ ] Switch to fib examples
- [ ] edit

Consider the mutually recursive functions `even?` and `odd?`.

```racket

(define (even? n)
  (if (zero? n)
      #true
      (odd? (- 1 n))))
      
(define (odd? n)
  (if (zero? n)
      #false
      (even (- 1 n))))
```

Each function makes a tail call to the other that shouldn't consume
any stack space, but in a gradually typed language these calls
might not actually be in tail position. For instance if we consider
annotating the functions with the following types.

```racket
(: even? (Integer -> Dynamic))
(: odd? (Integer -> Boolean))
```
In a naive implementation of gradual typing the following types would
cause the function calls to be pushed out of tail position as illustrated
in the following code.

```racket
(define (even? n)
  (if (zero? n)
      #true
      (odd? (- 1 n))))
      
(define (odd? n)
  (if (zero? n)
      (cast #false Boolean Dynamic)
      (cast (even (- 1 n)) Boolean Dynamic)))
```

Coercions and their composition operation (Heingline, Herman, Siek)
provides a general mechanism to deal with space efficiency. We can
use coercions and continuation passing style to make these casts
space efficient again.

```racket
(: even? (Integer -> Boolean))
(define (even? n k)
  (if (zero? n)
      (apply-coercion k #true)
      (let ([a0 (- 1 n)]
            [k0 (compose-coercions k Integer?)])
        (odd? a0 k0))))

(: odd? (Integer -> Dynamic))
(define (odd? n k)
  (if (zero? n)
      (apply-coercion (compose Integer! k) #false)
      (let ([a0 (- 1 n)]
            [k0 (compose-coercions k Integer!)])
       (even? a0 k0))))
```

But the problem with this technique is that every return
now has to apply a possibly empty coercion to the value
being returned, and every function call requires an additional
parameter. We shouldn't accept this because we have
added overhead even in static code. Ideally the only code
that gets slower would be code that has tail casts.

We note that if we could arrange for the context that is
expecting a value to cast the value if needed, then it may
be possible to only impose overhead on tail calls that have
tail casts.

```racket
(: odd? (Integer -> Dynamic))
(define (odd? n k)
  (if (zero? n)
      (apply-coercion Integer! #false)
      (let ([a0 (- n 1)]) 
       (cond
        [(cast-frame-setup? k)
         (set-box! k (compose-coercions k Integer!))
         (even? a0 k)]
        [else
         (let ([k (box Integer!)])
          (let ([v (even? a0 k)])
           (apply-coercion (unbox k) v)))]))))
```

In this setup any non-tail calls just pass a immediate value
that can be distinguished from an allocated reference, returns
no longer have any overhead. The overhead of this transformation
for is an extra argument to all procedure calls and extra
stack space used at each non-tail call to save the old coercion.
The additional overhead to tail casts is a branch on an immediate
value to determine if the apply coercion frame has been setup 
and allocating a box. 
