(require-extension amb amb-extras)

(define (amb-list args)
  (amb-thunks (map (lambda (x) (lambda () x)) args)))

(let ((names '(a b c)))
  (amb-collect
   (let ((name (amb-list names))
         (value (amb 'c 'b 'a)))
     (amb-assert (eq? name value))
     value)))

(define (karte images)
  (amb-collect
   (let ((animal (amb 'Katze 'Maus 'Pinguin 'Schwein))
	 (side (amb 'links 'rechts)))
     (cons animal side)))

(define (check actual desired)



(define (matching-all-unordered? needed given)
  (let ((needed (cons '() needed)))
    (let next-actual ((given given))
      (if (null? given)
	  (null? (cdr needed))
	  (let next-needed ((needed needed))
	    (if (null? (cdr needed))
		#f
		(if ((cadr needed) (car given))
		    (begin
		      (set-cdr! needed (cddr needed))
		      (next-actual (cdr given)))
		    (next-needed (cdr needed)))))))))

(define-syntax predicates
  (syntax-rules ()
    ((_ =? lst)
     (map (lambda (x) (lambda (y) (=? x y))) lst))))

(let ((p (predicates = '(1 2 3))))
  (test
   (eq? (matching-all-unordered? p '(2 3 1))   #t)
   (eq? (matching-all-unordered? p '())        #f)
   (eq? (matching-all-unordered? p '(1 2 3 4)) #f)))


(let ((needed '(K M P S)))
  (lambda (
  (amb-collect ((n (amb-list needed))
(amb-collect
 (let ((actual (amb 1 2)))
   (required 

(amb-collect
  (let loop ((actual (list 1 2 3))
	     (desired (list 3 2 1)))
    (if (and (pair? actual)
	     (pair? desired))
	(let ((a (car actual))
	      (d (car desired)))
	  (if (eqv? a d)
	      (amb a (or (loop actual (cdr desired))
			 (loop (cdr actual) desired)))
	      (amb)))
	(amb))))

(call/cc (lambda (exit)
	   
(define (pick x lst)
  (let loop ((head (list))
	     (tail lst))
    (if (null? tail)
	#f
	(if (eqv? x (car tail))
	    (append head (cdr tail))
  (if (pair? list)
      (if (eqv? x (car list))
	  
(let ((actual (list 1 2 3))
      (desired (list 3 2 1)))
  (for-each (lambda (

    (if (and (null? actual)
	     (null? desired))
	(amb)
	(if (eqv? (car actual)
		  (car desired))
	    (amb (car actual
	    (loop actual (cdr desired)))

(require-extension amb amb-extras)

(define number-between
  (lambda (lo hi)
    (let loop ((i lo))
      (if (> i hi) (amb)
          (amb i (loop (+ i 1)))))))

(define-syntax times
  (syntax-rules ()
    ((_ n expr)
     (let loop ((i n))
       (if (> i 0)
	   (cons expr (loop (- i 1)))
	   '())))))

(define cards
  '#(;; Row 1
     #((K . l) (P . r) (M . r) (S . l))
     #((M . r) (S . l) (K . r) (P . l))
     #((P . l) (K . r) (M . l) (S . r))
     ;; Row 2
     #((M . r) (S . r) (P . l) (K . l))
     #((K . l) (P . r) (M . l) (S . r))
     #((M . l) (S . l) (K . r) (P . r))
     ;; Row 3
     #((P . l) (K . r) (S . l) (M . r))
     #((M . l) (S . l) (P . r) (K . r))
     #((S . r) (P . l) (M . r) (K . l))))

(define cards-2x2
  '#(;; Row 1
     #((K . l) (P . r) (M . r) (S . l))
     #((M . r) (S . l) (K . r) (P . l))
     ;; Row 2
     #((M . r) (S . r) (P . l) (K . l))
     #((K . l) (P . r) (M . l) (S . r))
     ))

(define-syntax image
  (syntax-rules (east north west south)
    ((image card rotate east)
     (image card rotate 0))
    ((image card rotate north)
     (image card rotate 1))
    ((image card rotate west)
     (image card rotate 2))
    ((image card rotate south)
     (image card rotate 3))
    ((image card rotate position)
     (vector-ref card (modulo (+ rotate position) 4)))))

(image (vector-ref cards-2x2 0) 1 0)

(define (love? a b)
  (and (eqv? (car a) (car b))
       (not (eqv? (cdr a) (cdr b)))))

(define (cards-2x2-ref num-rot pos)
  (vector-ref (vector-ref cards-2x2 (car num-rot))
	      (modulo (+ (cdr num-rot) pos) 4)))

(begin
  (newline)
  (pp
   (amb-collect
    ;; Create the board of size cards in size places.
    (let* ((size 4)
	   (board (times size (number-between 0 (- size 1)))))
      ;; Make sure that each card gets placed only once on the board.
      (required (distinct? board))
      ;; Add 4 rotations to each card.
      (let ((board (map (lambda (card)
			  (cons card (number-between 0 3)))
			board)))
	(let ((east 0)
	      (north 1)
	      (west 2)
	      (south 3))
	  (apply (lambda (a1 b1 a2 b2)
		   (required (love? (cards-2x2-ref a1 east)
				    (cards-2x2-ref b1 west)))
		   (required (love? (cards-2x2-ref a2 east)
				    (cards-2x2-ref b2 west)))
		   (required (love? (cards-2x2-ref a1 south)
				    (cards-2x2-ref a2 north)))
		   (required (love? (cards-2x2-ref b1 south)
				    (cards-2x2-ref b2 north))))
		 board))
	board)))))

(define (nlpp arg)
  (newline) (pp arg))

(nlpp 
 (all-of (let ((board (times 3 (amb 1 2 3))))
	   (required (distinct? board))
	   board)))


(begin
  (newline)
  (pp
   (amb-collect
    (let ((
(begin
  (newline)
  (pp
   (let ((all (amb-collect
	       (let* ((size 4)
		      (field (map (lambda (x)
				    (cons (number-between 1 size)
					  (number-between 0 3)))
				  (make-list size))))
		 (required (distinct? (map car field)))
		 (required (distinct? field))
		 field))))
     (count pair? all))
     (take all 2048))))
     (grep (lambda (x)
	     (let loop ((cards (map car x)))
	       (if (null? cards)
		   #t
		   (and (= 1 (car cards))
			(loop (cdr cards))))))
	   all))))

(define (grep pred lst)
  (if (pair? lst)
      (let ((first (car lst))
	    (rest (cdr lst)))
	(if (pred first)
	    (cons first (grep pred rest))
	    (grep pred rest)))
      '()))

(define (count lst)
  (if (null? lst)
      0
      (+ 1 (count (cdr lst)))))


