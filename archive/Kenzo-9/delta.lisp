;;;  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA
;;;  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA
;;;  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA  DELTA

(IN-PACKAGE "COMMON-LISP-USER")

(PROVIDE "delta")

#|
(DEFMETHOD PRINT-KEYCONS ((car (eql :delt)) cdr stream)
   (format stream "~A" (hyphenize-list (dlop-int-ext cdr)))
   (cons car cdr))
|#

(DEFSTRUCT DELTA cdr)

(DEFMETHOD PRINT-OBJECT ((delta delta) stream)
  (declare (type stream stream))
  (the delta
    (with-slots (cdr) delta
      (declare (type fixnum cdr))
      (format stream "D")
      (dotimes (i (integer-length cdr))
        (when (logbitp i cdr)
          (format stream "~D" i)))
      delta)))

#|
(d 7)
|#
    

(DEFUN SOFT-DELTA-CMPR (gmsm1 gmsm2)
   (f-cmpr (delta-cdr gmsm1) (delta-cdr gmsm2)))

#|
()
(soft-delta-cmpr (d 2 3) (d 2 3))
|#
   
(DEFUN DELTA-FACE (indx dmns gmsm)
   (declare
      (type fixnum indx gmsm)
      (ignore dmns))
   (the absm
      (do ((pmark 1 (ash pmark 1))
           (bmark indx)
           (gmsm2 gmsm (ash gmsm2 -1)))
          (nil)
         (declare (type fixnum pmark bmark gmsm2))
         (when (oddp gmsm2)
            (when (minusp (decf bmark))
               (return-from delta-face (absm 0 (logxor gmsm pmark))))))))

(DEFUN SOFT-DELTA-FACE (indx dmns gmsm)
   (declare
      (type fixnum indx dmns)
      (type soft-dlop gmsm))
   (absm 0 (d (gmsm (delta-face indx dmns (delta-cdr gmsm))))))

#|
()
(dotimes (i 4)
  (print (dlop-int-ext (gmsm (delta-face i 3 (dlop-ext-int '(0 1 2 3)))))))
(dotimes (i 4)
  (print (dlop-int-ext (gmsm (delta-face i 3 (dlop-ext-int '(0 2 4 6))))))))
(dotimes (i 4)
  (print (soft-delta-face i 3 (d 0 1 2 3))))
(dotimes (i 4)
  (print (soft-delta-face i 3 (d 0 2 4 6))))
|#

(DEFUN DELTA-BNDR (dmns gmsm)
   (declare (type fixnum dmns gmsm))
   (the cmbn
      (if (zerop dmns)
         +zero-negative-cmbn+
         (make-cmbn
            :degr (1- dmns)
            :list (do ((rslt +empty-list+)
                      (gmsm2 gmsm (ash gmsm2 -1))
                      (pmark 1 (ash pmark +1))
                      (sign 1))
                     ((zerop gmsm2) rslt)
                    (declare
                       (list rslt)
                       (type fixnum gmsm2 pmark sign))
                    (when (oddp gmsm2)
                       (push (term sign (logxor gmsm pmark)) rslt)
                       (setf sign (- sign))))))))

(DEFUN SOFT-DELTA-BNDR (dmns gmsm)
   (declare
      (type fixnum dmns)
      (type soft-dlop gmsm))
   (make-cmbn
      :degr (1- dmns)
      :list (mapcar #'(lambda (term)
                         (with-term (cffc gmsm) term
                            (term cffc (d gmsm))))
               (cmbn-list (delta-bndr dmns (delta-cdr gmsm))))))

#|
()
(delta-bndr 0 4)
(delta-bndr 1 3)
(delta-bndr 1 5)
(delta-bndr 1 10)
(delta-bndr 5 63)
(soft-delta-bndr 5 (d (mask 6)))
|#


(DEFUN DELTA-DGNL (dmns gmsm)
   (declare (type fixnum dmns gmsm))
   (the cmbn
      (make-cmbn
         :degr dmns
         :list (do ((rslt +empty-list+)
                    (ldegr dmns)
                    (indx (1- (integer-length gmsm)) (1- indx)))
                   ((minusp indx))
                  (declare
                     (list rslt)
                     (type fixnum indx))
                  (when (logbitp indx gmsm)
                     (push (term 1 (tnpr
                                    ldegr (logand gmsm (mask (1+ indx)))
                                    (- dmns ldegr) (logandc2 gmsm (mask indx))))
                        rslt)
                     (when (minusp (decf ldegr))
                        (return rslt)))))))

(DEFUN SOFT-DELTA-DGNL (dmns gmsm)
   (declare
      (type fixnum dmns)
      (type soft-dlop gmsm))
   (make-cmbn :degr dmns
      :list (mapcar
               #'(lambda (term)
                    (with-term (cffc tnpr) term
                       (with-tnpr (degr1 gmsm1 degr2 gmsm2) tnpr
                          (term cffc
                             (tnpr degr1 (d gmsm1) degr2 (d gmsm2))))))
               (cmbn-list (delta-dgnl dmns (delta-cdr gmsm))))))

#|
()
(delta-dgnl 3 15)
(delta-dgnl 3 170)
(soft-delta-dgnl 3 (d (dlop-ext-int '(1 3 5 7))))
(delta-dgnl 0 64)
|#
                                        
(DEFUN DELTA-INFINITY ()
   (the simplicial-set
      (build-smst
         :cmpr #'f-cmpr
         :basis :locally-effective
         :bspn 1
         :face #'delta-face
         :intr-dgnl #'delta-dgnl
         :dgnl-strt :gnrt
         :intr-bndr #'delta-bndr
         :bndr-strt :gnrt
         :orgn '(delta-infinity))))

#|
()
(cmpr (delta-infinity) 2 4)
(cmpr (delta-infinity) 4 4)
(cmpr (delta-infinity) 8 4)
(basis (delta-infinity) 1)   ;;; => error
(face (delta-infinity) 1 2 21)
(cprd (delta-infinity) 3 15)
(dgnl (delta-infinity) 3 15)
(? (delta-infinity) 2 21)
|#

(DEFUN SOFT-DELTA-INFINITY ()
   (the simplicial-set
      (build-smst
         :cmpr #'soft-delta-cmpr
         :basis :locally-effective
         :bspn (d 1)
         :face #'soft-delta-face
         :intr-dgnl #'soft-delta-dgnl :dgnl-strt :gnrt
         :intr-bndr #'soft-delta-bndr :bndr-strt :gnrt
         :orgn '(soft-delta-infinity))))

#|
()
(cat-init)
(cmpr (soft-delta-infinity) (d 2) (d 4))
(face (soft-delta-infinity) 1 2 (d (dlop-ext-int '(1 3 5))))
(cprd (soft-delta-infinity) 3 (d 15))
(dgnl (soft-delta-infinity) 3 (d 15))
(? (soft-delta-infinity) 2 (d (dlop-ext-int '(0 2 4))))
|#

(DEFUN DELTA-N-BASIS (n)
   (declare (type fixnum n))
  (flet ((rslt (dmns)
               (declare (type fixnum dmns))
             (when (> dmns n)
                (return-from rslt +empty-list+))
             (setf dmns (1+ dmns))
             (do ((rslt +empty-list+)
                  (count (binomial-n-p (1+ n) dmns))
                  (gmsm (mask (1+ n)) (1- gmsm)))
                 ((zerop count) rslt)
                (when (= (logcount gmsm) dmns)
                   (push gmsm rslt)
                   (decf count)))))
      (the basis #'rslt)))

(DEFUN SOFT-DELTA-N-BASIS (n)
   (declare (type fixnum n))
   (flet ((rslt (dmns)
             (when (> dmns n)
                (return-from rslt +empty-list+))
             (setf dmns (1+ dmns))
             (do ((rslt +empty-list+)
                  (count (binomial-n-p (1+ n) dmns))
                  (gmsm (mask (1+ n)) (1- gmsm)))
                 ((zerop count) rslt)
                (when (= (logcount gmsm) dmns)
                   (push (d gmsm) rslt)
                   (decf count)))))
      (the basis #'rslt)))
      

#|
()
(setf basis (delta-n-basis 3))
(setf soft-basis (soft-delta-n-basis 3))
(dotimes (i 5)
  (print (funcall basis i)))
(dotimes (i 5)
  (print (funcall soft-basis i)))
|#   

(DEFUN DELTA (dmns)
   (declare (type fixnum dmns))
   (the simplicial-set
      (build-smst
         :cmpr #'f-cmpr
         :basis (delta-n-basis dmns)
         :bspn 1
         :face #'delta-face
         :intr-dgnl #'delta-dgnl
         :dgnl-strt :gnrt
         :intr-bndr #'delta-bndr
         :bndr-strt :gnrt
         :orgn `(delta ,dmns))))

#|
()
(cat-init)
(setf d3 (delta 3))
(cmpr d3 2 4)
(cmpr d3 4 4)
(cmpr d3 8 4)
(basis d3 1)
(dgnl d3 3 15)
(face d3 1 2 21)
(? d3 2 13)
(setf d (delta-infinity))
(basis d)
(setf d (delta-infinity)))
|#

(DEFUN SKELETON (ss n)
  (declare (type simplicial-set ss) (type fixnum n))
  (assert (and (not (minusp n)) (typep n 'fixnum)))
  (the simplicial-set
    (flet
        ((new-basis
          (dmns)
          (declare (type fixnum dmns))
          (the list
            (if (<= dmns n)
                (basis ss dmns)
              +empty-list+))))
      (declare (ftype (function (type fixnum) list) new-basis))
      (build-smst
       :cmpr (cmpr ss)
       :basis #'new-basis
       :bspn (bspn ss)
       :face (face ss)
       :orgn `(skeleton ,ss ,n)))))

#|
(cat-init)
(setf d3 (delta 3))
(setf d31 (skeleton d3 1))
(display-finite-ss d3 4)
(display-finite-ss d31 4)
|#
          
(DEFUN SOFT-DELTA (dmns)
  (declare (type fixnum dmns))
  (the simplicial-set
    (build-smst
     :cmpr #'soft-delta-cmpr
     :basis (soft-delta-n-basis dmns)
     :bspn (d 1)
     :face #'soft-delta-face
     :intr-dgnl #'soft-delta-dgnl :dgnl-strt :gnrt
     :intr-bndr #'soft-delta-bndr :bndr-strt :gnrt
     :orgn `(soft-delta ,dmns))))
      
#|
()
(cat-init)
(setf d3 (soft-delta 3))
(cmpr d3 (d 2) (d 4))
(basis d3 1)
(dgnl d3 3 (d 15))
(face d3 1 2 (d 21))
(? d3 2 (d 13))
|#

#| For comparison with EAT.
   In 
  (setf delta (delta-infinity))
  (setf d (bndr delta))
  (setf s14 (mask 15))
  (cmbn-? d (gnrt-? d 14 s14))
  (defun t1 (n)
     (time (dotimes (i n) (cmbn-? d (gnrt-? d 14 s14)))))
  (compile 't1)
  (t1 500)
  (setf +too-much-time+ -1)
  (t1 500)
|#
#|
  In EAT:
  (setf delta *delta*)
  (setf d (cc-d (ss-cc delta)))
  (setf s14 (<a-b> 0 14))
  (??? d (? d 14 s14))
  (defun t1 (n)
     (time (dotimes (i n) (??? d (? d 14 s14)))))
  (compile 't1)
  (t1 500)
|#

(DEFUN DELTAB-CMPR (gmsm1 gmsm2)
   (declare (type fixnum gmsm1 gmsm2))
   (if (= 1 (logcount gmsm1))
      :equal
      (f-cmpr gmsm1 gmsm2)))

(DEFUN DELTAB-BNDR (dmns gmsm)
   (declare (type fixnum dmns gmsm))
   (the cmbn
      (if (< dmns 2)
         (zero-cmbn (1- dmns))
         (make-cmbn
            :degr (1- dmns)
            :list (do ((rslt +empty-list+)
                      (gmsm2 gmsm (ash gmsm2 -1))
                      (pmark 1 (ash pmark +1))
                      (sign 1))
                     ((zerop gmsm2) rslt)
                    (declare
                       (list rslt)
                       (type fixnum gmsm2 pmark sign))
                    (when (oddp gmsm2)
                       (push (term sign (logxor gmsm pmark)) rslt)
                       (setf sign (- sign))))))))

(DEFUN DELTAB2-FACE (indx dmns gmsm)
   (declare
      (type fixnum indx dmns gmsm))
   (the absm
      (progn
	(when (= 2 dmns)
	   (return-from deltab2-face (absm 1 1)))
	(do ((pmark 1 (ash pmark 1))
	     (bmark indx)
	     (gmsm2 gmsm (ash gmsm2 -1)))
	    (nil)
	    (declare (type fixnum pmark bmark gmsm2))
	    (when (oddp gmsm2)
		  (when (minusp (decf bmark))
			(return-from deltab2-face (absm 0 (logxor gmsm pmark)))))))))

(DEFUN DELTAB2-DGNL (dmns gmsm)
  (declare (type fixnum dmns gmsm))
  (the cmbn
    (make-cmbn
     :degr dmns
     :list (if (zerop dmns)
               (list (term 1 (tnpr 0 gmsm 0 gmsm)))
             (do ((rslt +empty-list+)
                  (ldegr dmns)
                  (rdegr 0)
                  (indx (1- (integer-length gmsm)) (1- indx)))
                 ((minusp ldegr) rslt)
               (declare (list rslt) (type fixnum ldegr rdegr indx))
               (when (logbitp indx gmsm)
                 (unless (or (eql 1 ldegr) (eql 1 rdegr))
                   (push (term 1 (tnpr
                                  ldegr (logand gmsm (mask (1+ indx)))
                                  rdegr (logandc2 gmsm (mask indx))))
                         rslt))
                 (decf ldegr)
                 (incf rdegr)))))))

#|
()
(dotimes (i 7)
  (unless (eql i 1)
    (print (deltab2-dgnl i (mask (1+ i))))))
|#
  

(DEFUN DELTAB2-BNDR (dmns gmsm)
   (declare (type fixnum dmns gmsm))
   (the cmbn
      (if (< dmns 3)
         (zero-cmbn (1- dmns))
         (make-cmbn
            :degr (1- dmns)
            :list (do ((rslt +empty-list+)
                      (gmsm2 gmsm (ash gmsm2 -1))
                      (pmark 1 (ash pmark +1))
                      (sign 1))
                     ((zerop gmsm2) rslt)
                    (declare
                       (list rslt)
                       (type fixnum gmsm2 pmark sign))
                    (when (oddp gmsm2)
                       (push (term sign (logxor gmsm pmark)) rslt)
                       (setf sign (- sign))))))))

#|
  (deltab-bndr 1 5)
  (deltab-bndr 3 15)
|#

(DEFUN DELTAB ()
  (the simplicial-set
   (build-smst
      :cmpr #'deltab-cmpr
      :basis :locally-effective
      :bspn 1
      :face #'delta-face
      :intr-dgnl #'delta-dgnl
      :dgnl-strt :gnrt
      :orgn '(deltab))))

(DEFUN DELTAB2 ()
  (the simplicial-set
     (build-smst
      :cmpr #'f-cmpr
      :basis :locally-effective
      :bspn 1
      :face #'deltab2-face
      :intr-dgnl #'deltab2-dgnl
      :dgnl-strt :gnrt
      :orgn '(deltab2))))
