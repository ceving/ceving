;;
;; Type Helpers
;;

(define-syntax assert
  (syntax-rules ()
		((assert predicate argument)
		 (if (not (predicate argument))
				 (error "Not a" 'predicate argument)))
    ((assert predicate argument ...)
     (begin
			 (assert predicate argument)
       ...))))

(define-syntax lambda*
  (syntax-rules ()
    ((lambda* ((predicate argument)) body ...)
     (lambda (argument)
			 (assert predicate argument)
			 body
			 ...))
		((lambda* ((predicate argument) ...) body ...)
     (lambda (argument ...)
       (begin
         (assert predicate argument)
         ...)
       body
       ...))))

(define-syntax define*
  (syntax-rules ()
    ((define* (identifier (predicate argument) ...) body ...)
     (define identifier
       (lambda* ((predicate argument) ...)
         body
         ...)))))
