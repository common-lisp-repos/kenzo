;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

(in-package :kenzo-test-8)

(in-suite :kenzo-8)

(defun ccn ()
  (the cat-8:chain-complex
       (cat-8:build-chcm
        :cmpr #'cat-8:f-cmpr
        :basis #'(lambda (n)
                   (cat-8:<a-b< (* 10 n) (* 10 (1+ n))))
        :bsgn 0
        :intr-dffr #'(lambda (dgr gnr)
                       (if (evenp (+ dgr gnr))
                           (cat-8:cmbn (1- dgr) 1 (- gnr 10))
                           (cat-8:cmbn (1- dgr))))
        :strt :gnrt
        :orgn '(ccn))))


(test ccn
      (progn
        (cat-8:cat-init)
        (let* ((ccn (ccn))
               (upper-shift (cat-8:build-mrph
                             :sorc ccn :trgt ccn :strt :gnrt :degr 1
                             :intr #'(lambda (d gn) (cat-8:cmbn (1+ d)
                                                              1 (+ gn 10)))
                             :orgn '(ccn shift +10)))
               (lower-shift (cat-8:build-mrph
                             :sorc ccn :trgt ccn :strt :gnrt :degr -1
                             :intr #'(lambda (d gn) (cat-8:cmbn (1- d)
                                                              1 (- gn 10)))
                             :orgn '(ccn shift -10)))
               (comb1 (cat-8:? ccn 2 22))
               (combn (cat-8:cmbn 5 1 50 5 55 9 59))
               (d-combn (cat-8:? ccn combn))
               (dd-combn (cat-8:? ccn d-combn))
               (comb2 (cat-8:? upper-shift 0 6))
               (comb3 (cat-8:? lower-shift 5 51))
               (comb4 (cat-8:? lower-shift comb3))
               (identity? (cat-8:cmps upper-shift lower-shift))
               (comb5 (cat-8:cmbn 1 1 10 2 11 3 12 4 13))
               (comb6 (cat-8:? identity? comb5))
               (comb7 (cat-8:2cmbn-sbtr (cat-8:cmpr ccn) comb5 comb6))
               (upper2-shift (cat-8:cmps upper-shift upper-shift))
               (comb8 (cat-8:? upper2-shift comb5))
               (twice-up-shift (cat-8:add upper-shift upper-shift))
               (comb9 (cat-8:? twice-up-shift comb5))
               (up-d (cat-8:cmps upper-shift (cat-8:dffr1 ccn)))
               (d-up (cat-8:cmps (cat-8:dffr1 ccn) upper-shift))
               (comb10 (cat-8:? up-d 1 11))
               (comb11 (cat-8:? d-up 1 11))
               (comb12 (cat-8:cmbn 1 1 10 2 11 3 12 4 13 5 14 6 15))
               (comb13 (cat-8:? up-d comb12))
               (comb14 (cat-8:? d-up comb12))
               )
          (is (equal (cat-8:cmbn-degr comb1) 1))
          (is (equal (cat-8:cmbn-list comb1) '((1 . 12))))
          (is (null (cat-8:cmbn-non-zero-p (cat-8:? ccn comb1))))
          (is (equal (cat-8:cmbn-degr d-combn) 4))
          (is (equal (cat-8:cmbn-list d-combn) '((5 . 45) (9 . 49))))
          (is (equal (cat-8:cmbn-degr dd-combn) 3))
          (is (equal (cat-8:cmbn-list dd-combn) nil))
          (is (equal (cat-8:cmbn-degr comb2) 1))
          (is (equal (cat-8:cmbn-list comb2) '((1 . 16))))
          (is (equal (cat-8:cmbn-degr comb3) 4))
          (is (equal (cat-8:cmbn-list comb3) '((1 . 41))))
          (is (equal (cat-8:cmbn-degr comb4) 3))
          (is (equal (cat-8:cmbn-list comb4) '((1 . 31))))
          (is (equal (cat-8:degr identity?) 0))
          (is (equal (cat-8:cmbn-degr comb6) 1))
          (is (equal (cat-8:cmbn-list comb6) '((1 . 10) (2 . 11) (3 . 12)
                                             (4 . 13))))
          (is (equal (cat-8:cmbn-degr comb7) 1))
          (is (equal (cat-8:cmbn-list comb7) nil))
          (is (equal (cat-8:degr upper2-shift) 2))
          (is (equal (cat-8:cmbn-degr comb8) 3))
          (is (equal (cat-8:cmbn-list comb8) '((1 . 30) (2 . 31) (3 . 32)
                                             (4 . 33))))
          (is (equal (cat-8:degr twice-up-shift) 1))
          (is (equal (cat-8:cmbn-degr comb9) 2))
          (is (equal (cat-8:cmbn-list comb9) '((2 . 20) (4 . 21) (6 . 22)
                                             (8 . 23))))
          (is (equal (cat-8:cmbn-degr comb10) 1))
          (is (equal (cat-8:cmbn-list comb10) '((1 . 11))))
          (is (equal (cat-8:cmbn-degr comb11) 1))
          (is (equal (cat-8:cmbn-list comb11) nil))
          (is (equal (cat-8:cmbn-degr comb13) 1))
          (is (equal (cat-8:cmbn-list comb13) '((2 . 11) (4 . 13) (6 . 15))))
          (is (equal (cat-8:cmbn-degr comb14) 1))
          (is (equal (cat-8:cmbn-list comb14) '((1 . 10) (3 . 12) (5 . 14)))))))