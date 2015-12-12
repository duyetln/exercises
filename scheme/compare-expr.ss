(define compare-lets
  (lambda (tcp udp)
    (let ((tcpvar (car (cdr tcp))) (udpvar (car (cdr udp))))
      (if (equal? (map (lambda (pair) (car pair)) tcpvar)
                  (map (lambda (pair) (car pair)) udpvar))
        (cons 'let (compare-expr (cdr tcp) (cdr udp)))
        `(if TCP ,tcp ,udp)
      )
    )
  )
)

(define compare-lambdas
  (lambda (tcp udp)
    (let ((tcpvar (car (cdr tcp))) (udpvar (car (cdr udp))))
      (if (equal? tcpvar udpvar)
        (cons 'lambda (compare-expr (cdr tcp) (cdr udp)))
        `(if TCP ,tcp ,udp)
      )
    )
  )
)

; compare two lists having the same length
(define compare-lists
  (lambda (tcp udp)
    (cond
      [(and (null? tcp) (null? udp)) '()]
      [(and (equal? (car tcp) 'quote) (equal? (car udp) 'quote)) `(if TCP ',(car (cdr tcp)) ',(car (cdr udp)))]
      [(and (equal? (car tcp) 'let) (equal? (car udp) 'let)) (compare-lets tcp udp)]
      [(and (equal? (car tcp) 'lambda) (equal? (car udp) 'lambda)) (compare-lambdas tcp udp)]
      [(equal? (car tcp) (car udp)) (cons (car tcp) (compare-expr (cdr tcp) (cdr udp)))]
      [(not (equal? (car tcp) (car udp))) (cons (compare-expr (car tcp) (car udp)) (compare-expr (cdr tcp) (cdr udp)))]
    )
  )
)

(define compare-expr
  (lambda (tcp udp)
    (cond
      [(and (list? tcp) (list? udp))
        (if (not (= (length tcp) (length udp)))
          `(if TCP ,tcp ,udp)
          (compare-lists tcp udp)
        )
      ]
      [(equal? tcp udp) tcp]
      [(and (equal? tcp #f) (equal? udp #t)) '(not TCP)]
      [(and (equal? tcp #t) (equal? udp #f)) 'TCP]
      [else `(if TCP ,tcp ,udp)]
    )
  )
)

(define test-compare-expr
  (lambda (tcp udp)
    (let
      ((expr (compare-expr tcp udp)))
      (and
        (equal? (eval `(let ((TCP #t)) ,expr)) (eval tcp))
        (equal? (eval `(let ((TCP #f)) ,expr)) (eval udp))
      )
    )
  )
)

(define test-x
  '(and
    (if (equal? (car (cdr ''(a b c d))) 4)
      (+ 1 2)
      #t
    ) ; if + procedure call + quote
    (let
      ((a 1) (b 2))
      (+ a b)
    ) ; let 1
    (let
      ((a 1) (b 2))
      (+ a b)
    ) ; let 2
    ((lambda (x y) (+ x y)) 1 2) ; lambda 1
    ((lambda (x y) (* x y)) 1 2) ; lambda 2
    ((lambda (x) (* x x)) 2) ; lambda 3
  )
)

(define test-y
  '(and
    (if (equal? (cdr (cdr '(a b c d))) 2)
      #t
      (+ 1 2)
    ) ; if + procedure call + quote
    (let
      ((a 2) (b 1))
      (* a b)
    ) ; let 1
    (let
      ((c 1) (d 2))
      (+ c d)
    ) ; let 2
    ((lambda (x y) (* y x)) 1 2) ; lambda 1
    ((lambda (a b) (* a b)) 1 2) ; lambda 2
    ((lambda (x y) (* x y)) 2 2) ; lambda 3
  )
)

(test-compare-expr test-x test-y)
