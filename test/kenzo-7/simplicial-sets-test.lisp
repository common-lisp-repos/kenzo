;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

(in-package :kenzo-test-7)

(in-suite :kenzo-7)

(test dgop-ext-int
      (is (= 0 (cat-7:dgop-ext-int '())))
      (signals simple-error (cat-7:dgop-ext-int '(2 2)))
      (is (= 17 (cat-7:dgop-ext-int '(4 0)))))


(test dgop-int-ext
      (is (null (cat-7:dgop-int-ext 0)))
      (is (equal '(2) (cat-7:dgop-int-ext 4)))
      (is (equal '(5 4 3 2 1 0) (cat-7:dgop-int-ext 63)))
      (dotimes (i 33)
        (is (= i (cat-7:dgop-ext-int (cat-7:dgop-int-ext i))))))


(test hyphenize-list
      (is (string= "-" (cat-7:hyphenize-list '())))
      (is (string= "3" (cat-7:hyphenize-list '(3))))
      (is (string= "5-3-1" (cat-7:hyphenize-list '(5 3 1)))))


(test moore
      (let ((m (cat-7:moore 2 2)))
        (dotimes (i 4)
          (print (cat-7:basis m i :dgnr)))))

#|
(test intr-diagonal
      (let* ((cmpr #'cat-7:f-cmpr)
             (face #'cat-7:delta-face)
             (diag (cat-7:intr-diagonal face)))
        (funcall diag 4 (cat-7:mask 5))
        (funcall diag 0 4)
        (setf cmpr #'cat-7:s-cmpr face (cat-7:sphere-face 4))
        (setf diag (cat-7:intr-diagonal face))
        (funcall diag 4 's4)
        (funcall diag 0 '*)
        (setf s4 (cat-7:sphere 4))
        (cat-7:dgnl s4 4 's4)))
|#

(test face-bndr
      (let* ((face #'(lambda (indx dmns gmsm)
                       (cat-7:absm 0 (append
                                    (subseq gmsm 0 indx)
                                    (subseq gmsm (1+ indx))))))
             (bndr (cat-7:face-bndr #'cat-7:l-cmpr face)))
        (funcall bndr 0 '(a))
        (funcall bndr 1 '(a b))
        (funcall bndr 2 '(a b c))
        (funcall bndr 3 '(a b c d))
        (funcall bndr 3 '(d c b a))
        (funcall bndr 1 '(a a))
        (funcall bndr 2 '(a a a))
        (funcall bndr 3 '(a a a a))
        (setf face #'(lambda (index dmns gmsm)
                       (cat-7:absm (cat-7:dgop-ext-int
                                  (nreverse (cat-7:<a-b< 0 (1- dmns)))) 'a)))
        (setf bndr (cat-7:face-bndr #'cat-7:s-cmpr face))
        (funcall bndr 1 '(a b))
        (funcall bndr 2 '(a b c))))


(test face*-bndr
      (let* ((face* #'(lambda (indx dmns gmsm)
                        (if (and (= dmns 3) (evenp indx))
                            'm2
                            :degenerate)))
             (bndr (cat-7:face*-bndr #'cat-7:s-cmpr face*)))
        (funcall bndr 3 'm3)
        (funcall bndr 2 'm2)
        (funcall bndr 0 '*)
        (setf face* #'(lambda (indx dmns gmsm)
                        (if (and (= dmns 3) (< indx 2))
                            'm2
                            :degenerate)))
        (setf bndr (cat-7:face*-bndr #'cat-7:s-cmpr face*))
        (funcall bndr 3 'm3)
        (funcall bndr 2 'm2)
        (funcall bndr 0 '*)))


(test a-cmpr3
      (is (equal :less (cat-7:a-cmpr3 #'cat-7:s-cmpr
                                    (cat-7:absm 0 'a)
                                    (cat-7:absm 1 'b))))
      (is (equal :greater (cat-7:a-cmpr3 #'cat-7:s-cmpr
                                       (cat-7:absm 2 'a)
                                       (cat-7:absm 1 'b))))
      (is (equal :less (cat-7:a-cmpr3 #'cat-7:s-cmpr
                                    (cat-7:absm 1 'a)
                                    (cat-7:absm 1 'b))))
      (is (equal :greater (cat-7:a-cmpr3 #'cat-7:s-cmpr
                                       (cat-7:absm 1 'c)
                                       (cat-7:absm 1 'b))))
      (is (equal :equal (cat-7:a-cmpr3 #'cat-7:s-cmpr
                                     (cat-7:absm 1 'a)
                                     (cat-7:absm 1 'a)))))


(test bspn-p
      (let* ((d (cat-7:delta-infinity))
             (cmpr (cat-7:cmpr d)))
        (is (cat-7:bspn-p cmpr 1 5 (cat-7:absm (cat-7:mask 5) 1)))
        (is (not (cat-7:bspn-p cmpr 1 5 (cat-7:absm (cat-7:mask 5) 2))))
        (is (not (cat-7:bspn-p cmpr 1 5 (cat-7:absm (cat-7:mask 4) 3))))))


(test dlop-ext-int
      (is (= 0 (cat-7:dlop-ext-int '())))
      (signals simple-error (cat-7:dlop-ext-int '(2 2)))
      (is (= 17 (cat-7:dlop-ext-int '(0 4)))))


(test dlop-ext-int
      (is (null (cat-7:dlop-int-ext 0)))
      (is (equal '(2) (cat-7:dlop-int-ext 4)))
      (is (equal '(0 1 2 3 4 5) (cat-7:dlop-int-ext 63)))
      (dotimes (i 33)
        (is (= i (cat-7:dlop-ext-int (cat-7:dlop-int-ext i))))))


(test 1dgop*dgop
      (dotimes (i 20)
        (dotimes (j 5)
          (format t "~% (~D) o ~A = ~A"
                  j (cat-7:dgop-int-ext i)
                  (cat-7:dgop-int-ext (cat-7:1dgop*dgop j i))))))


(test dgop*dgop
      (dotimes (i 10)
        (dotimes (j 10)
          (format t "~%~A o ~A = ~A"
                  (cat-7:dgop-int-ext i) (cat-7:dgop-int-ext j)
                  (cat-7:dgop-int-ext (cat-7:dgop*dgop i j))))))


(test remove-bit
      (is (= 51 (cat-7:remove-bit 107 3))))


(test dgop/dgop
      (is (= 67 (cat-7:dgop/dgop 67 0)))
      (is (= 32 (cat-7:dgop/dgop 68 4)))
      (is (= 7 (cat-7:dgop/dgop 31 5))))


(test 1dlop-dgop
      (dotimes (i 5)
        (dotimes (j 17)
          (multiple-value-bind (dgop 1dlop) (cat-7:1dlop-dgop i j)
            (format t "~% del-~D o ~A = ~A o del-~A"
                    i (cat-7:dgop-int-ext j) (cat-7:dgop-int-ext dgop) 1dlop)))))

#|
(test a-face4
      (let ((simp (cat-7:dlop-ext-int '(0 1 2 3 4 5 6))))
        (dotimes (i 5)
          (dotimes (j 17)
            (let ((face (cat-7:a-face4 (cat-7:face (cat-7:delta-infinity))
                                     i (+ 6 (logcount j))
                                     (cat-7:absm j simp))))
              (format t "~%del-~D o ~A (0 1 2 3 4 5 6) = ~A ~A"
                      i (cat-7:dgop-int-ext j)
                      (cat-7:dgop-int-ext (cat-7:dgop face))
                      (cat-7:dlop-int-ext (cat-7:gmsm face))))))))
|#


(test 1dgnr
      (print (cat-7:1dgnr 2 (cat-7:absm 17 'a))))


(test ndgnr
      (print (cat-7:ndgnr 2 (cat-7:absm 17 'a))))


(test nface
      (let ((f (cat-7:face (cat-7:delta-infinity)))
            p)
        (dotimes (dlop 31)
          (print (cat-7:dlop-int-ext (cat-7:gmsm (cat-7:nface f dlop 4 31)))))
        (setf p (cat-7:r-proj-space))
        (setf f (cat-7:face p))
        (dotimes (dlop 31)
          (format t "~%~A ~A"
                  (cat-7:hyphenize-list (cat-7:dlop-int-ext dlop))
                  (cat-7:nface f dlop 4 4)))))


(test check-faces
      (let ((d (cat-7:delta-infinity)))
        (is (cat-7:check-faces #'cat-7:f-cmpr (cat-7:face d) 4 31))))


(test check-smst
      (signals simple-error (cat-7:check-smst (cat-7:delta-infinity) 5))
      (is (cat-7:check-smst (cat-7:delta 3) 2))
      (is (cat-7:check-smst (cat-7:delta 3) 2 4)))
