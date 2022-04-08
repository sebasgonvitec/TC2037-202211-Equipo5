#|
Actividad 3.2 Programando un DFA v2
Lexer for arithmetic operations with integers, floating point, real(nEn) and spaces

Sebastian Gonzalez Villacorta
A01029746

Example calls:
(arithmetic-lexer (dfa-str 'start '(int float real) delta-arithmetic-lexer) "34.5 * 9.1E-8 + 7.1" )

|#

#lang racket

(require racket/trace)

;DFA characteristics structure
(struct dfa-str(initial-state accept-state transitions))

;Definition of the automaton
(define (arithmetic-lexer dfa expression)
  "Evaluate a string to validate or not according to a DFA"
  (trace-let loop
    ([state (dfa-str-initial-state dfa)]  ;Current State
     [chars (string->list expression)]) ;List of characters
    (if (empty? chars)
        ;Check that the final state is in the accept states list
        (member state (dfa-str-accept-state dfa))
        ;Recursive loop with the new state and the rest of the list
        (loop
         ;Get the new state by applying the transition function
         ((dfa-str-transitions dfa) state (car chars))
         ;Call again for the rest of the characters
         (cdr chars)))))

(define (operator? char)
  (member char '(#\= #\+ #\- #\* #\/ #\^)))

(define (sign? char)
  (member char '(#\+ #\-)))

(define (space? char)
  (char=? char #\space))

(define (dot? char)
  (char=? char #\.))

(define (E? char)
  (char=? char #\E))

;Definition of Transition function
(define (delta-arithmetic-lexer state character)
  "Transition function for an automaton"
  (case state
    ['start (cond
              [(char-numeric? character) 'int]
              [(sign? character) 'n-sign]
              [else 'fail])]
    ['n-sign (cond
               [(char-numeric? character) 'int]
               [else 'fail])]
    ['int (cond
            [(char-numeric? character) 'int]
            [(operator? character) 'op]
            [(space? character) 'n-sp1]
            [(dot? character) 'float]
            [(E? character) 'exp]
            [else 'fail])]
    ['op (cond
            [(sign? character) 'n-sign]
            [(char-numeric? character) 'int]
            [(space? character) 'n-sp2]
            [else 'fail])]
    ['n-sp1 (cond
            [(operator? character) 'op]
            [(space? character) 'n-sp1]
            [else 'fail])]
    ['n-sp2 (cond
            [(sign? character) 'n-sign]
            [(char-numeric? character) 'int]
            [(space? character) 'n-sp2]
            [else 'fail])]
    ['float (cond
             [(operator? character) 'op]
             [(char-numeric? character) 'float]
             [(space? character) 'n-sp1]
             [(E? character) 'exp]
             [else 'fail])]
    ['exp (cond
            [(sign? character) 'n-sign-r]
            [else 'fail])]
    ['n-sign-r (cond
            [(char-numeric? character) 'real]
            [else 'fail])]
    ['real (cond
             [(operator? character) 'op]
             [(char-numeric? character) 'real]
             [(space? character) 'n-sp1]
             [else 'fail])]
    ))