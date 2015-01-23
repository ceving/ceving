;;
;; In/De-crement
;;

;; Universal crement
(define-syntax crement!
  (syntax-rules ()
    ((crement! func arg val)
     (set! arg (func arg val)))))

;; Arithmetic crement
(define-syntax arithmetic-crement!
  (syntax-rules ()
    ((arithmetic-crement! func arg val)
     (crement! func arg val))
    ((arithmetic-crement! func arg)
     (arithmetic-crement! func arg 1))))

;; Arithmetic Increment
(define-syntax inc!
  (syntax-rules ()
    ((inc! arg ...)
     (arithmetic-crement! + arg ...))))

;; Arithmetic Decrement
(define-syntax dec!
  (syntax-rules ()
    ((inc! arg ...)
     (arithmetic-crement! - arg ...))))
