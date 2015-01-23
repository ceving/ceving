;;
;; Tuples
;;

;; Make a referencing function
(define (make-tuple-ref ref-func arg)
  (lambda (index)
    (ref-func arg index)))

;; Make a setting function
(define (make-tuple-set set-func arg)
  (lambda (index value)
    (set-func arg index value)))

;; Make a vector referencing function
(define (make-vector-ref vec)
  (make-tuple-ref vector-ref vec))

;; Make a vector setting function
(define (make-vector-set vec)
  (make-tuple-set vector-set! vec))
