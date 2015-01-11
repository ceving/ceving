;;
;; Constructors
;;

(define (lsb int)
  (if (odd? int) 1 0))

(define (bits int)
  (if (<= 0 int)
      (let loop ((int int)
                 (bits (list)))
        (if (= 0 int)
            (cons 0 bits)
            (loop (quotient int 2)
                  (cons (lsb int) bits))))
      (not-bits (bits (- (- int) 1)))))

(define (uint bits)
  (let loop ((num 0)
             (bits bits))
    (if (null? bits)
        num
        (loop (+ (* num 2) (car bits))
              (cdr bits)))))

(define (int bits)
  (case (car bits)
    ((0) (uint (cdr bits)))
    ((1) (- (- (uint (not-bits bits))) 1))
    (else (error "Not a bit"))))

;;
;; Predicates
;;

(define (hi-bit? bit)
  (eqv? 1 bit))

(define (lo-bit? bit)
  (eqv? 0 bit))

(define (bit? bit)
  (or (hi-bit? bit)
      (lo-bit? bit)))

(define (bits? bits)
  (cond ((null? bits) #t)
        ((pair? bits) (and (bit? (car bits)) (bits? (cdr bits))))
        (else #f)))

;;
;; Operations with single bits.
;;

(define (not-bit bit)
  (assert bit? bit)
  (abs (- bit 1)))

(define (and-bit a b)
  (assert bit? a b)
  (and (hi-bit? a) (hi-bit? b)))

(define (or-bit a b)
  (assert bit? a b)
  (or (hi-bit? a) (hi-bit? b)))

(define (add-bit a b)
  (assert bit? a b)
  (case (+ a b)
    ((0) (cons 0 0))
    ((1) (cons 0 1))
    ((2) (cons 1 0))))

(define (inc-bit bit)
  (add-bit bit 1))

;;
;; Operations with bit fields.
;;

(define (not-bits bits)
  (map not-bit bits))

(define (inc-bits bits)
  (let loop ((carry 1)
             (rbits (reverse bits))
             (result (list)))
    (if (null? rbits)
        (if (hi-bit? carry)
            (cons carry result)
            result)
        (let ((b (+ carry (car rbits))))
          (case b
            ((0 1) (loop 0 (cdr rbits) (cons b result)))
            ((2) (loop 1 (cdr rbits) (cons 0 result)))
            (else "Invalid bit in bit-field to increment." bits))))))

(define (pad-bits n bits)
  (let ((l (length bits)))
    (if (< l n)
        (append (make-list (- n l) (car bits))
                bits)
        bits)))

(define (unpad-bits bits)
  (let ((bit (car bits)))
    (if (and (pair? (cdr bits))
             (eqv? bit (cadr bits)))
        (unpad-bits (cdr bits))
        bits)))

(define (clip-bits n bits)
  (list-tail bits (- (length bits) n)))

