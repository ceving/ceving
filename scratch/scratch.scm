
(import (chibi type-inference))

(list (type-analyze (+ 1 2))
      (type-analyze '(+ 1 2))
      (type-analyze '(eval (+ 1 2))))

(list (type-analyze (+ 1 2))
      (type-analyze '(+ 1 2))
      (type-analyze '(eval '(+ 1 2))))


(define-function (plus a b)
  )

(define i8+ 
  (typed ((a int8)
          (b int8))
         (int8 bit)
    (load c a)
    (add c a b)))

  