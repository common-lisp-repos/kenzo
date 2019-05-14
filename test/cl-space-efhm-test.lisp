;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

(in-package :kenzo-test)

(in-suite :kenzo)


(test cs-hat-u-t
      (cat:cat-init)
      (let ((c (cat:cs-hat-u-t (cat:k-z-1)))
            abar-degr
            gnrt)
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 10)
              (print (cat:? c (+ 5 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 5 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 6 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (print (cat:? c (+ 6 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 6 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             3 '(4 5 6)) abar-degr abar))
            (unless (>= abar-degr 10)
              (print (cat:? c (+ 5 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 5 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 11)
              (print (cat:? c (+ 4 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 4 abar-degr)
                                                   gnrt)))))))))


(test cs-hat-t-u
      (cat:cat-init)
      (dotimes (i 5) (print (random-abar 8 4)))
      (let ((c (cat:cs-hat-t-u (cat:k-z-1)))
            abar-degr
            gnrt)
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 10)
              (print (cat:? c (+ 5 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 5 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 6 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (print (cat:? c (+ 6 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 6 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 10)
              (print (cat:? c (+ 5 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 5 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 11)
              (print (cat:? c (+ 4 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 4 abar-degr)
                                                   gnrt)))))))))

#|
(test cs-left-hmeq-hat
      (cat:cat-init)
      (let ((c (cat:cs-left-hmeq-hat (cat:k-z-1)))
            abar-degr
            gnrt)
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 10)
              (print (cat:? c (+ 5 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 5 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 6 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (print (cat:? c (+ 6 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 6 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 10)
              (print (cat:? c (+ 5 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 5 abar-degr)
                                                   gnrt)))))))
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 11)
              (print (cat:? c (+ 4 abar-degr) gnrt))
              (is (cat:cmbn-zero-p (cat:? c (cat:? c (+ 4 abar-degr)
                                                   gnrt)))))))))
|#



(test cs-pre-left-hmeq-left-reduction
      (cat:cat-init)
      (let ((rdct (cat:cs-pre-left-hmeq-left-reduction (cat:k-z-1)))
            abar-degr
            gnrt
            gbar)
        (cat:pre-check-rdct rdct)
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 2 '(4 5))
                                 abar-degr abar))
            (setf gbar (cat:gbar 2 0 '(1) 0 '()))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn 2 1 gbar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 6 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 3 '(4 5 6))
                                 abar-degr abar))
            (setf gbar (cat:gbar 3 0 '(1 2) 1 '() 0 '()))
            (unless (>= abar-degr 8)
              (setf cat:*tc* (cat:cmbn (+ 6 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn 3 1 gbar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             3 '(4 5 6))
                                 abar-degr abar))
            (setf gbar (cat:gbar 4 0 '(1 2 3) 0 '(4 5) 0 '(6) 0 '()))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn 4 1 gbar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(4 5))
                                 abar-degr abar))
            (setf gbar (cat:gbar 5 8 '(1 2 3) 0 '(4 5 6) 0 '(7 8) 0 '(9)
                                 0 '()))
            (unless (>= abar-degr 10)
              (setf cat:*tc* (cat:cmbn (+ 4 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn 5 1 gbar))
              (check-rdct))))))


(test cs-left-hmeq-left-reduction
      (cat:cat-init)
      (let ((rdct (cat:cs-left-hmeq-left-reduction (cat:k-z-1)))
            abar-degr
            gnrt
            gbar)
        (cat:pre-check-rdct rdct)
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 2 '(4 5))
                                 abar-degr abar))
            (setf gbar (cat:gbar 2 0 '(1) 0 '()))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn 2 1 gbar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 6 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 3 '(4 5 6))
                                 abar-degr abar))
            (setf gbar (cat:gbar 3 0 '(1 2) 1 '() 0 '()))
            (unless (>= abar-degr 8)
              (setf cat:*tc* (cat:cmbn (+ 6 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn 3 1 gbar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             3 '(4 5 6))
                                 abar-degr abar))
            (setf gbar (cat:gbar 4 0 '(1 2 3) 0 '(4 5) 0 '(6) 0 '()))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn 4 1 gbar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(4 5))
                                 abar-degr abar))
            (setf gbar (cat:gbar 5 8 '(1 2 3) 0 '(4 5 6) 0 '(7 8) 0 '(9)
                                 0 '()))
            (unless (>= abar-degr 10)
              (setf cat:*tc* (cat:cmbn (+ 4 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn 5 1 gbar))
              (check-rdct))))))


(test cs-pre-left-hmeq-right-reduction-intr-f
      (cat:cs-pre-left-hmeq-right-reduction-intr-f
       (cat:cmbn 4 2 (cat:tnpr 0 (cat:tnpr 0 cat:+null-gbar+ 0 'i)
                               4 (cat:abar 2 'a 2 'b))
                 3 (cat:tnpr 0 (cat:tnpr 0 cat:+null-gbar+ 0 'i)
                             4 (cat:abar 2 'a 2 'c))
                 5 (cat:tnpr 1 (cat:tnpr 0 cat:+null-gbar+ 1 'a)
                             3 (cat:abar 1 'a 2 'b)))))


(test cs-pre-left-hmeq-right-reduction-g
      (let ((g (cat:cs-pre-left-hmeq-right-reduction-intr-g 'i)))
        (funcall g (cat:cmbn 3 2 (cat:abar 1 'a 2 'b)))))


#|
(test cs-pre-left-hmeq-right-reduction
      (cat:cat-init)
      (let ((rdct (cat:cs-pre-left-hmeq-right-reduction (cat:k-z-1)))
            abar-degr
            gnrt)
        (cat:pre-check-rdct rdct)
        (dotimes (i 10)
          (let ((abar (random-abar 8 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 6 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 0 '(3)
                                                         0 '()) 3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 8)
              (setf cat:*tc* (cat:cmbn (+ 6 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             3 '(4 5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 6 4)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(4 5))
                                 abar-degr abar))
            (unless (>= abar-degr 10)
              (setf cat:*tc* (cat:cmbn (+ 4 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))))
|#

(test cs-left-hmeq-right-reduction
      (cat:cat-init)
      (let ((rdct (cat:cs-left-hmeq-right-reduction (cat:k-z-1)))
            abar-degr
            gnrt)
        (cat:pre-check-rdct rdct)
        (dotimes (i 10)
          (let ((abar (random-abar 4 2)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 3 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             1 '(4))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 3 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 3 1)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 4 (cat:tnpr 2 (cat:gbar 2 0 '(3) 0 '())
                                             2 '(5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 8)
              (setf cat:*tc* (cat:cmbn (+ 4 abar-degr) 1 gnrt)
                    cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))
        (dotimes (i 10)
          (let ((abar (random-abar 3 1)))
            (setf abar-degr (apply #'+ (mapcar #'car (cat:abar-list abar))))
            (setf gnrt (cat:tnpr 5 (cat:tnpr 3 (cat:gbar 3 0 '(1 2) 1 '()
                                                         0 '()) 2 '(5 6))
                                 abar-degr abar))
            (unless (>= abar-degr 9)
              (setf cat:*tc* (cat:cmbn (+ 5 abar-degr) 1 gnrt))
              (setf cat:*bc* (cat:cmbn abar-degr 1 abar))
              (check-rdct))))))


(test cs-left-hmeq
      (cat:cat-init)
      (let* ((h (cat:cs-left-hmeq (cat:k-z-1)))
             (abar (cat:abar 2 '(2) 3 '(3 4))))
        (cat:rf h
                (cat:lg h
                        (cat:lf h
                                (cat:rg h 5 abar))))))


(test classifying-space
      (cat:cat-init)
      (let* ((k (cat:k-z-1))
             (bk (cat:classifying-space k))
             (obk (cat:loop-space bk)))
        (cat:homology k 0 10)
        (cat:homology bk 0 10)
        (cat:homology obk 0 6)))
