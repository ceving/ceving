(define-library (idlist)

  (export identifier-list register-identifier
	  identifier-number identifier-name)

  (import (scheme base)
	  (srfi 69))

  (begin

    (define-record-type Identifier-List
      (%identifier-list)
      identifier-list?
      (counter get-counter set-counter!)
      (number-by-name get-number-by-name set-number-by-name!)
      (name-by-number get-name-by-number set-name-by-number!))

    (define (identifier-list)
      (let ((idlist (%identifier-list)))
	(set-counter! idlist 1)
	(set-number-by-name! idlist (make-hash-table))
	(set-name-by-number! idlist (make-hash-table))
	idlist))

    (define (register-identifier idlist name)
      (let ((number (get-counter idlist)))
	(set-counter! idlist (+ number 1))
	(hash-table-set! (get-number-by-name idlist) name number)
	(hash-table-set! (get-name-by-number idlist) number name)
	number))

    (define (identifier-number idlist name)
      (hash-table-ref (get-number-by-name idlist) name))

    (define (identifier-name idlist number)
      (hash-table-ref (get-name-by-number idlist) number))

    ))
