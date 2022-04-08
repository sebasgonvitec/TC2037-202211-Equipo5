#|
Actividad 3.2 Programando un DFA v4
Lexer for arithmetic operations with integers, floating point, real(nEn), spaces, variables and parentheses

Sebastian Gonzalez Villacorta
A01029746
Karla Valeria Mondragon Rosas
A01025108


Example calls:
(automaton-2 (dfa-str 'start '(int var float real) delta-arithmetic-lexer) "34+9/du*23123")
(automaton-2 (dfa-str 'start '(int var float real) delta-arithmetic-lexer) "34+5")

(arithmetic-lexer "cel = (far - 32) * 5 / 9.0")
(arithmetic-lexer "7.4 ^3 = 2.0 * 1")
|#

#lang racket

(require racket/trace)

(provide arithmetic-lexer)

;DFA characteristics structure
(struct dfa-str(initial-state accept-state transitions))

;Create arithmetic lexer function
(define (arithmetic-lexer input-string)
  "Entry point for the lexer"
  (automaton-2 (dfa-str 'start '(int float real var n-sp1 close-p) delta-arithmetic-lexer) input-string))


;Definition of the automaton
(define (automaton-2 dfa input-string)
  " Evaluate a string to validate or not according to a DFA.
  Return a list of the tokens found"
  (trace-let loop
    ([state (dfa-str-initial-state dfa)]   ;Current State
     [chars (string->list input-string)]   ;List of characters
     [token-list null]                     ;List of tokens found
     [char-list null]                      ;List of found characters
     [curr-char null]                      ;Current char
     [final-list null])                    ;Final list of character and token                   

    (if (empty? chars)
        ;Check that the final state is in the accept states list
        (if (member state (dfa-str-accept-state dfa))
            ;Return final-list plus last character and token
           (reverse (cons (cons (list->string (reverse curr-char)) (list state)) final-list)) #f)
        ;Recursive loop with the new state and the rest of the list
        (let-values
          ;Get the new token found and state by applying the transition function
          ([(token state) ((dfa-str-transitions dfa) state (car chars))])
          (loop
            state
            (cdr chars)
            ; Update the list of tokens found
            (if token
                (cons token token-list)
                token-list)
            ; Update list of characters
            (if token
                (cons (list->string (reverse curr-char)) char-list)
                char-list)
            ; Update accumulator for current character
            (if token
                (if (space? (car chars))
                    null
                    (list (car chars)))
                (if (space? (car chars))
                    curr-char
                    (cons(car chars) curr-char)))
            ;Update final list with found character and it token
            (if token
                (cons (cons (list->string (reverse curr-char)) (list token)) final-list)
                final-list))))))

;Check if character is operator
(define (operator? char)
  (member char '(#\= #\+ #\- #\* #\/ #\^)))

;Check if character is sign
(define (sign? char)
  (member char '(#\+ #\-)))

;Check if character is a space
(define (space? char)
  (member char '(#\space)))

;Check if character is a dot
(define (dot? char)
  (member char '(#\.)))

;Check if character is an E or e
(define (E? char)
  (member char '(#\E #\e)))

;Definition of Transition function
(define (delta-arithmetic-lexer state character)
  "Transition function for an automaton"
  (case state
   ['start (cond
              [(sign? character) (values #f 'n-sign)]
              [(char-numeric? character) (values #f 'int)]
              [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
              [(equal? character #\() (values #f 'open-p)]
              [(space? character) (values #f 'n-sp2)]
              [else (values #f 'fail)])]
    
    ['n-sign (cond
               [(char-numeric? character) (values #f 'int)]
               [else (values #f 'fail)])]
    
    ['int (cond
            [(operator? character) (values 'int 'op)]
            [(char-numeric? character) (values #f 'int)]
            [(space? character) (values 'int 'n-sp1)]
            [(dot? character) (values #f 'float)]
            [(E? character) (values #f 'exp)]
            [(equal? character #\)) (values 'int 'close-p)]
            [else (values #f 'fail)])]
    
    ['op (cond
            [(sign? character) (values 'op 'n-sign)]
            [(char-numeric? character) (values 'op 'int)]
            [(space? character) (values 'op 'n-sp2)]
            [(or (char-alphabetic? character) (equal? character #\_)) (values 'op 'var)]
            [(equal? character #\() (values 'op 'open-p)]
            [else (values #f 'fail)])]
    
    ['n-sp1 (cond
            [(operator? character) (values #f 'op)]
            [(space? character) (values #f 'n-sp1)]
            [(equal? character #\)) (values #f 'close-p)]
            [else (values #f 'fail)])]
    
    ['n-sp2 (cond
            [(sign? character) (values #f 'n-sign)]
            [(char-numeric? character) (values #f 'int)]
            [(space? character) (values #f 'n-sp2)]
            [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
            [(equal? character #\() (values #f 'open-p)]
            [else (values #f 'fail)])]
    
    ['float (cond
             [(operator? character) (values 'float 'op)]
             [(char-numeric? character) (values #f 'float)]
             [(space? character) (values 'float 'n-sp1)]
             [(E? character) (values #f 'exp)]
             [else (values #f 'fail)])]
    
    ['exp (cond
            [(sign? character) (values #f 'n-sign-r)]
            [(char-numeric? character) (values #f 'real)]
            [(equal? character #\)) (values #f 'close-p)]
            [else (values #f 'fail)])]
    
    ['n-sign-r (cond
            [(char-numeric? character) (values #f 'real)]
            [else (values #f 'fail)])]
    
    ['real (cond
             [(operator? character) (values 'real 'op)]
             [(char-numeric? character) (values #f 'real)]
             [(space? character) (values 'real 'n-sp1)]
             [(equal? character #\)) (values 'real 'close-p)]
             [else (values #f 'fail)])]
    
    ['var (cond
            [(operator? character) (values 'var 'op)]
            [(or (char-alphabetic? character) (equal? character #\_)) (values #f 'var)]
            [(char-numeric? character) (values #f 'var)]
            [(space? character) (values 'var 'n-sp1)]
            [(equal? character #\)) (values 'var 'close-p)]
            [else (values #f 'fail)])]

    ['open-p (cond
               [(sign? character) (values 'open-p 'n-sign)]
               [(char-numeric? character) (values 'open-p 'int)]
               [(space? character) (values 'opne-p 'n-sp2)]
               [(or (char-alphabetic? character) (equal? character #\_)) (values 'open-p 'var)]
               [else (values #f 'fail)])]

    ['close-p (cond
               [(operator? character) (values 'close-p 'op)]
               [(space? character) (values 'close-p 'n-sp1)]
               [else (values #f 'fail)])]
    
    ['fail (values #f 'fail)]
    
    ))
