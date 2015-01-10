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
