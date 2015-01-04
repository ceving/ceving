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

#;(begin
  (let ((space? (lambda (char) (char=? char #\space))))
    (test* split-string
           (("abc def" space?) '("abc" "def"))
           ((" " space?) '("" ""))
           (("a" space?) '("a"))
           (("" space?) '(""))
           ((" a" space?) '("" "a"))
           (("a " space?) '("a" ""))
           (("  " space?) '("" "" ""))))
  )
