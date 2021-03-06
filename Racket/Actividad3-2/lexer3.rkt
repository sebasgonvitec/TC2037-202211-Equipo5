#|
Actividad 3.2 Programando un DFA v2
Lexer for arithmetic operations with integers, floating point, real(nEn), spaces and variables

Sebastian Gonzalez Villacorta
A01029746
Karla Valeria Mondragon Rosas
A01025108

Example calls:
(arithmetic-lexer (dfa-str 'start '(int float real var) delta-arithmetic-lexer) "34.5 * 9.1E-8 + a")

|#

#lang racket

(require racket/trace)

;DFA characteristics structure
(struct dfa-str(initial-state accept-state transitions))

#|
;Create arithmetic lexer function
(define (arithemtic-lexer2 input-string)
  (arithmetic-lexer (dfa-str 'start '(int float real) delta-arithmetic-lexer) input-string ))
|#

;Definition of the automaton
(define (arithmetic-lexer dfa expression)
  "Evaluate a string to validate or not according to a DFA"
  (trace-let loop
    ([state (dfa-str-initial-state dfa)]  ;Current State
     [chars (string->list expression)]    ;List of characters
     [result null])                       ;List of tokens found
    (if (empty? chars)
        ;Check that the final state is in the accept states list
        (if (member state (dfa-str-accept-state dfa))
            (reverse (cons state result)) #f)
        ;Recursive loop with the new state and the rest of the list
        (let-values
          ;Get the new token found and state by applying the transition function
          ([(token state) ((dfa-str-transitions dfa) state (car chars))])
          (loop
            state
            (cdr chars)
            ; Update the list of tokens found
            (if token (cons token result) result))))))

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
              [(char-numeric? character) (values #f 'int)]
              [(sign? character) (values #f 'n-sign)]
              [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
              [else (values #f 'fail)])]
    
    ['n-sign (cond
               [(char-numeric? character) (values #f 'int)]
               [else (values #f 'fail)])]
    
    ['int (cond
            [(char-numeric? character) (values #f 'int)]
            [(operator? character) (values #f 'op)]
            [(space? character) (values #f 'n-sp1)]
            [(dot? character) (values #f 'float)]
            [(E? character) (values #f 'exp)]
            [else (values #f 'fail)])]
    
    ['op (cond
            [(sign? character) (values #f 'n-sign)]
            [(char-numeric? character) (values #f 'int)]
            [(space? character) (values #f 'n-sp2)]
            [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
            [else (values #f 'fail)])]
    
    ['n-sp1 (cond
            [(operator? character) (values #f 'op)]
            [(space? character) (values #f 'n-sp1)]
            [else (values #f 'fail)])]
    
    ['n-sp2 (cond
            [(sign? character) (values #f 'n-sign)]
            [(char-numeric? character) (values #f 'int)]
            [(space? character) (values #f 'n-sp2)]
            [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
            [else (values #f 'fail)])]
    
    ['float (cond
             [(operator? character) (values #f 'op)]
             [(char-numeric? character) (values #f 'float)]
             [(space? character) (values #f 'n-sp1)]
             [(E? character) (values #f 'exp)]
             [else (values #f 'fail)])]
    
    ['exp (cond
            [(sign? character) (values #f 'n-sign-r)]
            [(char-numeric? character) (values #f 'real)]
            [else (values #f 'fail)])]
    
    ['n-sign-r (cond
            [(char-numeric? character) (values #f 'real)]
            [else (values #f 'fail)])]
    
    ['real (cond
             [(operator? character) (values #f 'op)]
             [(char-numeric? character) (values #f 'real)]
             [(space? character) (values #f 'n-sp1)]
             [else (values #f 'fail)])]
    
    ['var (cond
            [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
            [(char-numeric? character) (values #f 'var)]
            [(operator? character) (values #f 'op)]
            [(space? character) (values #f 'n-sp1)]
            [else (values #f 'fail)])]
    
    ['fail (values #f 'fail)]
    
    ))
