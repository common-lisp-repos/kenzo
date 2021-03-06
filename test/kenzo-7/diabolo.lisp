;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

(in-package :kenzo-test-7)

(in-suite :kenzo-7)

(defun diabolo-basis (dmn)
  (case dmn
    (0 '(s0 s1 s2 s3 s4 s5))
    (1 '(s01 s02 s12 s23 s34 s35 s45))
    (2 '(s345))
    (otherwise nil)))

(defun diabolo-pure-dffr (dmn gnr)
  (unless (<= 0 dmn 2)
    (error "Incorrect dimension for diabolo-dp."))
  (case dmn
    (0 (cat-7:cmbn -1))
    (1 (case gnr
         (s01 (cat-7:cmbn 0 -1 's0 1 's1))
         (s02 (cat-7:cmbn 0 -1 's0 1 's2))
         (s12 (cat-7:cmbn 0 -1 's1 1 's2))
         (s23 (cat-7:cmbn 0 -1 's2 1 's3))
         (s34 (cat-7:cmbn 0 -1 's3 1 's4))
         (s35 (cat-7:cmbn 0 -1 's3 1 's5))
         (s45 (cat-7:cmbn 0 -1 's4 1 's5))))
    (2 (case gnr
         (s345 (cat-7:cmbn 1 1 's34 -1 's35 1 's45))))
    (otherwise (error "Bad generator for complex diabolo."))))

(test diabolo
      (progn
        (cat-7:cat-init)
        (let ((diabolo (cat-7:build-chcm :cmpr #'cat-7:s-cmpr
                                       :basis #'diabolo-basis
                                       :bsgn 's0
                                       :intr-dffr #'diabolo-pure-dffr
                                       :strt :GNRT
                                       :orgn '(diabolo-for-example))))
          (is (equal (cat-7:basis diabolo 0) '(s0 s1 s2 s3 s4 s5)))
          (is (equal (cat-7:basis diabolo 1) '(s01 s02 s12 s23 s34 s35 s45)))
          (is (equal (cat-7:basis diabolo 2) '(s345)))
          (is (null (cat-7:basis diabolo 10)))

          (let* ((comb (cat-7:dffr diabolo 2 's345))
                 (comb1 (cat-7:dffr diabolo comb)))
            (is (equal (cat-7:cmbn-degr comb) 1))
            (is (equal (cat-7:cmbn-list comb) '((1 . s34) (-1 . s35) (1 . s45))))
            (is (equal (cat-7:cmbn-degr comb1) 0))
            (is (equal (cat-7:cmbn-list comb1) nil))))))
