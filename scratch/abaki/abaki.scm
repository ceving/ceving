(begin

  (define processes (list))

  (define (make-ready process)
    (set! processes (append processes (cons process '()))))

  (define (dispatch)
    (if (pair? processes)
	(let ((next-process (car processes)))
	  (set! processes (cdr processes))
	  (next-process #t))))

  (define (create-process function)
    (call-with-current-continuation
     (lambda (caller)
       (call-with-current-continuation
	(lambda (process)
	  (make-ready process)
	  (caller #t)))
       (function)
       (dispatch))))

  (create-process (lambda () (display "a\n")))
  (create-process (lambda () (display "b\n")))

  (dispatch))

(define (writeln arg)
  (write arg)
  (newline))

(define (vector-insert vector position length)
  (let ((new-vector (make-vector (+ (vector-length vector) length))))
    (vector-copy! new-vector 0
		  vector 0 position)
    (vector-copy! new-vector (+ position length)
		  vector position)
    new-vector))

(define-syntax vector-insert!
  (syntax-rules ()
    ((vector-insert! vector position length)
     (set! vector (vector-insert vector position length)))))

(begin
  (define column vector)
  (define make-column make-vector)
  (define column-ref vector-ref)
  (define column-set! vector-set!)
  (define-syntax column-insert! vector-insert!)

  (let ((c (column 1 2 3 4 5)))
    (newline)
    (writeln c)
    (column-insert! c 4 2)
    (writeln c)
    (column-insert! c 0 1)
    (writeln c)
    )
  )

(begin
  (define make-matrix
    (lambda (columns rows)
      (let ((matrix (make-vector columns)))
	(let loop ((column 0))
	  (if (< column columns)
	      (begin
		(vector-set! matrix column (make-vector rows))
		(loop (+ column 1)))
	      matrix)))))
  (define matrix-set!
    (lambda (matrix column row value)
      (vector-set! (vector-ref matrix column) row value)))

  (let ((m (make-matrix 2 3)))
    (writeln m)
    (matrix-set! m 1 1 #f)
    (writeln m)
    )
  )

(number? (/ 4 5))

(define (make-sheet)
  (let ((counter 1)
	(elements (list)))
    (define (add)
      (let ((id counter))
	(set! counter (+ counter 1))
    (lambda (arg)
      (case arg
	((add) 
  
(define (sheet-add sheet . elements)
  (append sheet elements))


(define-record-type <scalar>
  (%scalar value)
  scalar?
  (value scalar-value scalar-value-set!))

(define-record-type <array>
  (%array size values)
  array?
  (size array-size array-size-set!)
  (values array-values array-values-set!))

(define (list->array values)
  (if (not (list? values))
      (error "Invalid list"))
  (set! values (list->vector values))
  (%array (vector-size values) values))

(define (array values)
  (if (not (vector? values))
      (error "Invalid vector"))
  (%array (vector-size values) values))

(define (array . args)
  (if (null? (cdr args))
      (let ((values (car args)))
	(cond
	 ((list? values) (set! values (list->vector values)))
	 ((vector? values))
	 (
	    (let ((values (list->vector values)))
	      (%array vector-length values)
      (%array

(define (literal? value)
  (or (and (scalar? value)
	   (not (procedure? (scalar-value value))))
      (and (array? value)
	   (not (procedure? (array-value value))))))

(define (function? value)
  (or (and (scalar? value)
	   (procedure? (scalar-value value)))
      (and (array? value)
	   (procedure? (array-value value)))))

(define-record-type <real>
  (%real label unit value)
  real?
  (label real-label real-label-set!)
  (unit real-unit real-unit-set!)
  (value real-value real-value-set!))

(define (real label unit value)
  (if (and label (not (string? label)))
      (error "Invalid label"))
  (if (and unit (not (string? unit)))
      (error "Invalid unit"))
  (if (and (not (scalar? value))
	   (not (array? value)))
      (error "Invalid value"))
  (%real label unit value))

(real #f #f (scalar 5))


(define (add-notifier-receiver notifier receiver)
  (let ((receivers (notifier-rec
(notifier 5)




λ

(abaki "Example"
       (bead "Faktor" 2)
       (bead "Werte" 3)
       (bead "X-Achse"
	     (lambda ()
	       (let loop ((result (list))
			  (index (ref "Werte")))
		 (if (> index 0)
		     (loop (cons index result)
			   (- index 1))
		     result))))
       (bead "Y-Achse"
	     (lambda ()
	       (map (lambda (x)
		      (* x (ref "Faktor")))
		    (ref "X-Achse")))))

(import (idlist))

(let ((ids (identifier-list)))
  (write (list (register-identifier ids "foo")
	       (register-identifier ids "bar")))
  (newline)
  (write (register-identifier ids "nix"))
  (newline)
  (display (identifier-number ids "foo"))
  (newline)
  (display (identifier-name ids 2))
  (newline))


(define-record-type <abaki>
  (abaki name beads)
  abaki?
  (name abaki-name)
  (beads abaki-beads abaki-beads-set!))

(define-record-type <bead>
  (bead abaki name value)
  bead?
  (abaki bead-abaki)
  (name bead-name)
  (value bead-value)
  (referrers bead-referrers bead-referrers-set!))

(define-record-type <bead-reference>
  (bead-reference bead)
  ref?
  (abaki ref-abaki)
  (name ref-name))


(abaki Example
       (bead Faktor 2)
       (bead Werte 3)
       (bead X-Achse
	     (function (Werte)
		       (let loop ((result (list))
				  (index (ref Werte))))
		       (if (> index 0)
			   (loop (cons index result)
				 (- index 1))
			   result)))
       (bead Y-Achse
	     (lambda (ref)
	       (map (lambda (x)
		      (* x (ref Faktor))))
	       (ref X-Achse)))))

(define (abaki name . beads)

  (define (add-bead name value)
    (set! beads (cons (cons name value) beads)))

  (define (dump)
    (display name)
    (display ": ")
    (write beads)
    (newline))

  (lambda (method)
    (case method
      ((bead) add-bead)
      ((dump) dump) 
      (else (error "Unknown method" method)))))

(define (abaki-bead abaki name value)
  ((abaki 'bead) name value))

(let ((example (abaki "Example")))
  (abaki-bead example "Faktor" 2)
  ((example 'dump)))

    
(let ((Example (abaki)))
  (letrec ((Faktor (bead Example 2))
	   (Werte (bead Example 3))
	   X-Achse (bead 
  (bead a "Faktor" 2)
  (bead a "Werte" 3)
  (bead a 
  
(define abaki #f)
(define bead #f)
(define ref #f)

(let ((env (list)))
  (set! env
	(lambda (name . beads)
	  (set! env 


(define-syntax abaki
  (syntax-rules (bead)
    ((abaki abaki-name
	    (bead-0 bead-0-name bead-0-value)
	    (bead-1 bead-1-name bead-1-value)
	    ...)
     (let ((abaki (make-abaki abaki-name)))
       (abaki 'bead 


(
)

(define-record-type Value
  (value)
  value?
  (number value-number value-number-set!)
  



(begin

(import (debug))
(import (srfi 69))


(define-record-type Value
  (%value)
  value?
  (object value-ref %value-set!)
  (function value-function-ref value-function-set!)
  (dependencies value-dependencies-ref value-dependencies-set!)
  (dependents value-dependents-ref value-dependents-set!))

(define (value-independent? value)
  (null? (value-dependents-ref value)))

(define (value-notify value)
  (for-each value-calculate (value-dependents-ref value)))

(define (value-calculate value)
  (%value-set! value
	       (apply (value-function-ref value)
		      (map value-ref (value-dependencies-ref value))))
  (value-notify value))

(define (value-dependency-add! value dependency)
  (value-dependents-set! dependency
			 (cons value (value-dependents-ref dependency)))
  (value-dependencies-set! value
			   (cons dependency (value-dependencies-ref value))))

(define (value . args)
  (let ((new-value (%value)))
    (value-dependencies-set! new-value (list))
    (value-dependents-set! new-value (list))
    (if (pair? args)
	(let ((first (car args))
	      (rest (cdr args)))
	  (if (procedure? first)
	      (begin
		(value-function-set! new-value first)
		(for-each (lambda (dependency)
			    (value-dependency-add! new-value dependency))
			  rest)
		(value-calculate new-value))
	      (begin
		(%value-set! new-value first)
		(if (not (null? rest))
		    (error "Too many arguments")))))
	(error "Missing argument"))
    new-value))

(define (value-set! value object)
  (%value-set! value object)
  (value-notify value))

(define-syntax function
  (syntax-rules ()
    ((_ () expr0 expr1 ...)
     (value (lambda () expr0 expr1 ...)))
    ((_ (arg0 arg1 ...) expr0 expr1 ...)
     (value (lambda (arg0 arg1 ...) expr0 expr1 ...) arg0 arg1 ...))))

)

#;(
(value-ref (value 5))
(value-ref (value * (value 2) (value 3)))

(let* ((a (value 1))
       (b (function (a) (* a a)))
       (c (function () 7)))
  (? a b c)
  (value-set! a 3)
  (? a b c)
  (? (value-ref b))
  (? (value-ref c)))
)



(+ 1 2)
(map + (list 1 1) (list 2 2))

(let ((f '(2))
      (x '(1 2 3 4 5)))
  (define (scale x v)
    (map (lambda (a) (* x a)) v))
  (map scale 2 x))


(define curry (lambda (f . c) (lambda x (apply f (append c x))))))
((curry list 5 4) 3 2)
(5 4 3 2)

((curry list 1) 2 3)

(define curry (lambda (f . c) (lambda x (apply f (append c x)))))

(define curry 
  (lambda (f . c)
    (lambda x
      (apply f (append c x)))))

(define curry
  (lambda (f . arg)
    (lambda args
      (apply f (cons arg args))))

((curry list 1) 2)

(define-syntax curry
  (syntax-rules ()
    ((_ function argument)
     (lambda arguments
       (function (cons argument arguments

 (define (curry f n) 
   (if (zero? n) 
       (f) 
       (lambda args 
         (curry (lambda rest 
                  (apply f (append args rest))) 
                (- n (length args))))))
 (define foo (curry + 4)) 
 ((((foo 1) 2) 3) 4)     ;=> 10 
 ((foo 1 2 3) 4)         ;=> 10 
 (foo 1 2 3 4)