(import (scheme write)
        (scheme file))

(define-syntax ?
  (syntax-rules ()
    ((? tag arg)
     (let ((p (current-error-port)))
       (let ((value arg))
         (display ";" p)
         (if tag
             (begin
               (display #\space p)
               (display tag p)
               (display #\: p)))
         (display #\space p)
         (write (quote arg) p)
         (display #\space p)
         (display "=>" p)
         (display #\space p)
         (write value p)
         (newline p)
         value)))
    ((? arg)
     (? #f arg))))

(define-syntax test
  (syntax-rules ()
    ((test function index (predicate (argument ...) result))
     (let ((value (function argument ...)))
       (let ((test-result (predicate value result)))
         (display 'function)
         (if index
             (begin
               (display " ")
               (display index)))
         (display ": ")
         (if test-result
             (display "ok")
             (begin
               (display "FAILURE")
               (newline)
               (display "  Expression: ")
               (write '(function argument ...))
               (newline)
               (display "  returns: ")
               (display value)
               (newline)
               (display "  expecting: ")
               (write result)))
         (newline)
         test-result)))
    ((test function index ((argument ...) result))
     (test function index (equal? (argument ...) result)))
    ((test function (predicate (argument ...) result))
     (test function #f (predicate (argument ...) result)))
    ((test function ((argument ...) result))
     (test function #f (equal? (argument ...) result)))))

(define-syntax test*
  (syntax-rules ()
    ((test* function definition ...)
     (let ((counter (let ((value 1))
                      (lambda ()
                        (let ((this value))
                          (set! value (+ value 1))
                          this)))))
       (and (let ((index (counter)))
              (test function index definition))
            ...)))))

#;(begin
  (let ((space? (lambda (char) (char=? char #\space))))
    (test* split-string
           (("abc def" space?) '("abc" "def"))
           ((" " space?) '("" ""))
           (("" space?) '(""))
           ((" a" space?) '("" "a"))
           (("a " space?) '("a" ""))
           (("  " space?) '("" "" ""))))
  )

(define (make-string-matcher search-string)
  (let* ((search-vector (string->vector search-string))
         (position 0))
    (lambda (char)
      (if (char=? char (vector-ref search-vector position))
          (begin
            (set! position (+ position 1))
            (if (= position (vector-length search-vector))
                (begin
                  (set! position 0)
                  #t)
                'possible))
          (begin
            (set! position 0)
            #f)))))

(let ((match? (make-string-matcher " cond ")))
  (map
   (lambda (char)
     (match? char))
   (string->list "Undefined Instruction cond 0 0 0 x x x x 0 x x x x x x x x x x x x 1 1 1 1 x x x x")))

    
(define (split-string input-string delimiter?)
  (let ((input-port (open-input-string input-string)))
    (let loop ((current-sub-string (open-output-string))
               (found-sub-strings '()))
      (let ((char (? (read-char input-port))))
        (cond ((eof-object? char)
               (reverse (cons (get-output-string current-sub-string)
                              found-sub-strings)))
              ((delimiter? char)
               (loop (open-output-string)
                     (cons (get-output-string current-sub-string)
                           found-sub-strings)))
              (else
               (write-char char current-sub-string)
               (loop current-sub-string found-sub-strings)))))))


;; Emacs: (put 'with-unreader 'scheme-indent-function 2)

(define (with-unreader reader port thunk)
  (let ((buffer '()))
    (let ((reader (lambda ()
                    (if (null? buffer)
                        (reader port)
                        (begin
                          (let ((data (car buffer)))
                            (set! buffer (cdr buffer))
                            data)))))
          (unreader (lambda (data)
                      (set! buffer (cons data buffer)))))
      (thunk reader unreader))))
  

(define (split-string input-string delimiter?)
  (let ((input-port (open-input-string input-string)))
    (with-unreader read-char input-port
      (lambda (reader unreader)
        (let loop ((current-sub-string (open-output-string))
                   (found-sub-strings '()))
          (let ((char (? (reader))))
            (if (eof-object? char)
                (reverse (cons (get-output-string current-sub-string)
                               found-sub-strings))
                (let ((is-delimiter (delimiter? char)))
                  (case is-delimiter
                    ((#t)
                     (loop (open-output-string)
                           (cons (get-output-string current-sub-string)
                                 found-sub-strings)))
                    ((#f)
                     (write-char char current-sub-string)
                     (loop current-sub-string found-sub-strings))
                    ((possible)
                     ;; read more input
                     (let rest ()
                       (case (delimiter? (reader))
                     (let rest ((char (reader)))
                       (if (eof-object? char)
                           #f
                           (case (
                           
                     )
                    (else
                     (error "Unknown predicate result."
                            is-delimiter)))))))))))



;; Emacs: (put 'for-each-line 'scheme-indent-function 1)

(define (for-each-line port thunk)
  (let loop ()
    (let ((line (read-line port)))
      (if (not (eof-object? line))
          (begin
            (thunk line)
            (loop))))))

(call-with-input-file "armref.txt"
  (lambda (port)
    (for-each-line port
      (lambda (line)
        (let ((columns (split-string 
        (display #\.)))))
                 

    

(define (prepare-kmp p)
  (let* ((m (string-length p))
         (next (make-vector m 0)))
    (let loop ((i 1) (j 0))
       (cond ((>= i (- m 1))
              next)
             ((char=? (string-ref p i) (string-ref p j))
              (let ((i (+ i 1))
                    (j (+ j 1)))
                 (vector-set! next i j)
                 (loop i j)))
             ((= j 0)
              (let ((i (+ i 1)))
                 (vector-set! next i 0)
                 (loop i j)))
             (else
              (loop i (vector-ref next j)))))))

(define (kmp p s)
  (let ((next (prepare-kmp p))
        (m (string-length p))
        (n (string-length s)))
    (let loop ((i 0) (j 0))
      (cond ((or (>= j m) (>= i n))
             (- i m))
            ((char=? (string-ref s i) (string-ref p j))
             (loop (+ i 1) (+ j 1)))
            ((= j 0)
             (loop (+ i 1) j))
            (else
             (loop i (vector-ref next j)))))))

(define make-delimited-reader
  (let ()
    (define (prepare-knuth-pratt-morris pattern)
      (let* ((m (vector-length pattern))
             (next (make-vector m 0)))
        (let loop ((i 1) (j 0))
          (cond ((>= i (- m 1))
                 next)
                ((char=? (vector-ref pattern i) (vector-ref pattern j))
                 (let ((i (+ i 1))
                       (j (+ j 1)))
                   (vector-set! next i j)
                   (loop i j)))
                ((= j 0)
                 (let ((i (+ i 1)))
                   (vector-set! next i 0)
                   (loop i j)))
                (else
                 (loop i (vector-ref next j)))))))
    (lambda (pattern)
      (let* ((pattern (string->vector pattern))
             (next (prepare-knuth-pratt-morris pattern)))
        (? pattern)
        (? next)
        (lambda (input-port)
          (let ((peek-char (lambda ()
                             (peek-char input-port))))
            (let ((char (peek-char)))
              (if (eof-object? char)
                  char
                  (call-with-port (open-output-string)
                    (lambda (output-port)
                      (let ((read-char (lambda ()
                                         (read-char input-port)))
                            (write-char (lambda (char)
                                          (write-char char output-port))))
                        (let loop ((pattern-index 0)
                                   (char char))
                          (cond ((eof-object? char)
                                 (get-output-string output-port))
                                ((>= pattern-index (vector-length pattern))
                                 (get-output-string output-port))
                                ((char=? char (vector-ref pattern pattern-index))
                                 (loop (+ pattern-index 1) (read-char)))
                                ((= pattern-index 0)
                                 (write-char (read-char))
                                 (loop pattern-index (peek-char)))
                                (else
                                 (let* ((new-index (vector-ref next pattern-index))
                                        (back (- pattern-index new-index)))
                                   (let loop ((n 0))
                                     (if (> n 0)
                                         (begin
                                           (write-char (vector-ref pattern n))
                                           (loop (+ n 1)))))
                                   (? pattern-index)
                                   (? (vector-ref next pattern-index))
                                   (loop new-index char))))))))))))))))


(begin
  (newline)
  ((make-delimited-reader "ababb") (open-input-string "aab")))

((make-delimited-reader "abc") (open-input-string "1abc"))

((make-delimited-reader "abc") (open-input-string "123"))

((make-delimited-reader "abc") (open-input-string "1234abc"))

((make-delimited-reader "aabb") (open-input-string "aabaabb"))

((make-delimited-reader "aabaaa") (open-input-string "aaa"))

((make-delimited-reader "aabaaa") (open-input-string "aaabaabaaab"))

((make-delimited-reader "abcdabd") (open-input-string "abc abcdab abcdabcdabde"))

(equal? char=? char=?)

(equal? (lambda (c) (char=? #\a))
        (lambda (c) (char=? #\a)))
        

(let ((reader (make-delimited-reader "abc"))
      (input (open-input-string "xxxxabc abcab")))
  (list (reader input)
        (reader input)
        (reader input)
        (reader input)))

(let ((p (open-input-string "a")))
  (peek-char p)
  (read-char p)
  (peek-char p)
  (eof-object? (peek-char p))
  )


(define (split-string delimiter? string)
  (let ((result (list))
        (output (open-output-string)))
    (string-for-each
     (lambda (char)
       (if (delimiter? char)
           (begin
             (set! result (cons (get-output-string output) result))
             (set! output (open-output-string)))
           (write-char char output)))
     string)
    (reverse (cons (get-output-string output) result))))

(define (split-string delimiter? string)
  (let ((result (list))
        (tail #f)
        (output (open-output-string)))
    (string-for-each
     (lambda (char)
       (if (delimiter? char)
           (begin
             (set! result (cons (get-output-string output) result))
             (set! output (open-output-string)))
           (write-char char output)))
     string)
    (reverse (cons (get-output-string output) result))))

(define (space? char) (char=? char #\space))


  (let ((space? (lambda (char) (char=? char #\space))))
    (test* split-string
           ((space? "abc def") '("abc" "def"))
           ((space? " ") '("" ""))
           ((space? "") '(""))
           ((space? " a") '("" "a"))
           ((space? "a ") '("a" ""))
           ((space? "  ") '("" "" ""))))


(import (scheme write)
        (chibi time))

(define (seconds-spend thunk)
  (let ((t0 (current-seconds)))
    (let ((result (thunk)))
      (display (- (current-seconds) t0))
      (newline)
      result)))

(let ((iterations 10000000))
  (equal? (seconds-spend
           (lambda ()
             (let loop ((n 0)
                        (liste (list)))
               (if (< n iterations)
                   (loop (+ n 1)
                         (cons n liste))
                   (reverse liste)))))
          (seconds-spend
           (lambda ()
             (let ((liste (cons '() '())))
               (let loop ((n 0)
                          (tail liste))
                 (if (< n iterations)
                     (begin
                       (set-cdr! tail (cons n (cdr tail)))
                       (loop (+ n 1) (cdr tail)))
                     (cdr liste))))))))


def failTable(pattern):
    # Create the resulting table, which for length zero is None.
    result = [None]

    # Iterate across the rest of the characters, filling in the values for the
    # rest of the table.
    for i in range(0, len(pattern)):
        # Keep track of the size of the subproblem we're dealing with, which
        # starts off using the first i characters of the string.
        j = i

        while True:
            # If j hits zero, the recursion says that the resulting value is
            # zero since we're looking for the LPB of a single-character
            # string.
            if j == 0:
                result.append(0)
                break

            # Otherwise, if the character one step after the LPB matches the
            # next character in the sequence, then we can extend the LPB by one
            # character to get an LPB for the whole sequence.
            if pattern[result[j]] == pattern[i]:
                result.append(result[j] + 1)
                break

            # Finally, if neither of these hold, then we need to reduce the
            # subproblem to the LPB of the LPB.
            j = result[j]
    
    return result

(define (prepare-kmp p)
  (let* ((m (string-length p))
         (next (make-vector m 0)))
    (let loop ((i 1) (j 0))
       (cond ((>= i (- m 1))
              next)
             ((char=? (string-ref p i) (string-ref p j))
              (let ((i (+ i 1))
                    (j (+ j 1)))
                 (vector-set! next i j)
                 (loop i j)))
             ((= j 0)
              (let ((i (+ i 1)))
                 (vector-set! next i 0)
                 (loop i j)))
             (else
              (loop i (vector-ref next j)))))))
(prepare-kmp "ababcac")

#     a b a b c a c
#    * 0 0 1 2 0 1 0

(define (kmp-fail equal? pattern)
  (let ((next (make-vector (+ 1 (vector-length pattern)))))
    (vector-set! next 0 #f)
    (let loop ((i 0)
               (j 0))
      (cond ((= j 0)
             (vector-set! next i 0)
             (let ((i+1 (+ i 1)))
               (loop i+1 i+1)))
             


;; p: pattern to search
;; m: length of the pattern

(define (kmp-next =? m p)
  (let-values (((next-ref next-set!)
                (let ((next (make-vector m 0)))
                  (values (lambda (x) (vector-ref next x))
                          (lambda (x v) (vector-set! next x v))))))
    (let loop ((i 1) (j 0))
      (cond ((>= i (- m 1))
             next-ref)
            ((=? (p i) (p j))
             (let ((i (+ i 1))
                   (j (+ j 1)))
               (next-set! i j)
               (loop i j)))
            ((= j 0)
             (let ((i (+ i 1)))
               (next-set! i 0)
               (loop i j)))
            (else
             (loop i (next-ref j)))))))

(define (kmp-search =? p s)
  (let* ((m (vector-length p))
         (p (lambda (x) (vector-ref p x)))
         (next (kmp-next =? m p))
         (n (string-length s)))
    (let loop ((i 0) (j 0))
      (cond ((>= j m)
             (- i m))
            ((>= i n)
             #f)
            ((=? (string-ref s i) (p j))
             (loop (+ i 1) (+ j 1)))
            ((= j 0)
             (loop (+ i 1) j))
            (else
             (loop i (next j)))))))


(kmp-search char=? (string->vector "abc") "cab")

(kmp-search char=? (string->vector "abc") "aabc")

(kmp-search char=? (string->vector "abcdabd") "abc abcdab abcdabcdabde")


(define (char/eof=? a b)
  (or (and (eof-object? a)
           (eof-object? b))
      (not (eof-object? b))
      (char=? a b)))

(define eof (eof-object))

(map (lambda (e?)
       (e? (eof-object)
           (call-with-port (open-input-file "/dev/null") read-char)))
     (list eq? eqv? equal?))


(import (chibi type-inference))
(equal? (type-analyze '(read-char))
        (type-analyze '(eof-object))) => #t
(char? (eof-object))                  => #f
(char=? (eof-object) (eof-object))    => error


(define (fail-table pattern)
  (define result (list #f))
  (let loop ((i 0))
    (if (< i (vector-length pattern))
        (begin
          (let loop ((j i))
            (cond ((= j 0)
                   (set! result (append result (list 0))))
                  ((char=? (vector-ref pattern (? (list-ref (? result) (? j))))
                           (vector-ref (? pattern) (? i)))
                   (set! result (append result (list (+ (list-ref result j) 1)))))
                  (else (loop (list-ref result j)))))
          (loop (+ i 1)))
        result)))

(fail-table (string->vector "ab"))
#     a b a b c a c
#    * 0 0 1 2 0 1 0

(fail-table (string->vector "ababcac"))
