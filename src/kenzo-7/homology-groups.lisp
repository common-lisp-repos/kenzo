;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*

;;  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS
;;  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS
;;  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS  HOMOLOGY-GROUPS

(IN-PACKAGE #:cat-7)

(provide "homology-groups")

;;
;;  Computing ordinary homology-groups.
;;


;; Functions.

(defun creer-matrice (n1 n2)
  (let ((mat (make-matrice
              :leftcol (make-array (1+ n1))
              :uplig (make-array (1+ n2)))))
    (setf (baselig mat 0) (make-t-mat :ilig 0 :icol 0))
    (setf (basecol mat 0) (baselig mat 0))
    (do ((i 1 (1+ i)))
        ((> i n1))
      (setf (baselig mat i)
            (make-t-mat :ilig i :icol 0 :up (baselig mat (1- i))))
      (setf (left (baselig mat i)) (baselig mat i)))
    (do ((j 1 (1+ j)))
        ((> j n2))
      (setf (basecol mat j)
            (make-t-mat :ilig 0 :icol j :left (basecol mat (1- j))))
      (setf (up (basecol mat j)) (basecol mat j)))
    (setf (up (baselig mat 0)) (baselig mat n1))
    (setf (left (basecol mat 0)) (basecol mat n2))
    mat))

(defun chercher-hor (p ic)
  (do ((p2 p p1)
       (p1 (left p) (left p1)))
      ((<= (icol p1) ic) p2)))

(defun chercher-ver (p il)
  (do ((p2 p p1)
       (p1 (up p) (up p1)))
      ((<= (ilig p1) il) p2)))

(defun inserer-terme (pl pc val)
  (setf (left pl) (make-t-mat :val val
                              :ilig (ilig pl)
                              :icol (icol pc)
                              :left (left pl)
                              :up (up pc))
        (up pc) (left pl)))

(defun supprimer-terme (pl pc)
  (setf (left pl) (left (left pl))
        (up pc) (up (up pc))))

(defun maj-terme (pl pc val)
  (if (= val 0)
      (if (eq (left pl) (up pc)) (supprimer-terme pl pc))
      (if (eq (left pl) (up pc))
          (setf (val (left pl)) val)
          (inserer-terme pl pc val))))

(defun maj-ligne (mat il liste)
  (let ((ptl (baselig mat il)))
    (mapcar
     #'(lambda (elem)
         (maj-terme (chercher-hor ptl (first elem))
                    (chercher-ver (basecol mat (first elem)) il)
                    (second elem)))
     liste)
    ptl))

(defun maj-colonne (mat ic liste)
  (let ((ptc (basecol mat ic)))
    (mapcar
     #'(lambda (elem)
         (maj-terme (chercher-hor (baselig mat (first elem)) ic)
                    (chercher-ver ptc (first elem))
                    (second elem)))
     liste)
    ptc))

(defun maj-matrice (mat liste)
  (mapcar
   #'(lambda (elem) (apply #'maj-ligne mat elem))
   liste)
  mat)

(defun disp-p (p)
  `((,(ilig p) ,(icol p) ,(val p))
    (,(ilig (left p)) ,(icol (left p)) ,(val (left p)))
    (,(ilig (up p)) ,(icol (up p)) ,(val (up p)))))

(defun disp-ligne (mat il)
  (terpri)
  (princ "L")
  (princ il)
  (princ "=")
  (mapcar
   #'(lambda (elem)
       (princ "(")
       (princ (first elem))
       (princ ":")
       (princ (second elem))
       (princ ")"))
   (let ((ptl (baselig mat il))
         (res '()))
     (do ((pl (left ptl) (left pl)))
         ((eq pl ptl))
       (push (list (icol pl) (val pl)) res))
     res))
  (values ))

(defun disp-colonne (mat ic)
  (terpri)
  (princ "C")
  (princ ic)
  (princ "=")
  (mapcar
   #'(lambda (elem)
       (princ "(")
       (princ (first elem))
       (princ ":")
       (princ (second elem))
       (princ ")"))
   (let ((ptc (basecol mat ic))
         (res '()))
     (do ((pc (up ptc) (up pc)))
         ((eq pc ptc))
       (push (list (ilig pc) (val pc)) res))
     res))
  (values ))

(defun nlig (mat) (1- (array-dimension (leftcol mat) 0)))
(defun ncol (mat) (1- (array-dimension (uplig mat) 0)))

(defun disp-matrice (mat)
  (let ((nlig (nlig mat)))
    (do ((i 1 (1+ i)))
        ((> i nlig))
      (disp-ligne mat i)))
  (done))

#+clisp(eval-when (:compile-toplevel :load-toplevel :execute)
         (setf (ext:package-lock :clos) nil))
(DEFMETHOD PRINT-OBJECT ((mtrx matrice) stream)
  (declare (stream stream))
  (the matrice (progn
                 (let ((nlig (nlig mtrx))
                       (ncol (ncol mtrx)))
                   (declare (fixnum nlig ncol))
                   (format stream "~%========== MATRIX ~D lines + ~D columns ====="
                           nlig ncol)
                   (do ((ilig 1 (1+ ilig)))
                       ((> ilig nlig))
                     (declare (fixnum ilig))
                     (format stream "~%L~D=" ilig)
                     (dolist (item (let ((baselig (baselig mtrx ilig)))
                                     (declare (type t-mat baselig))
                                     (do ((rslt +empty-list+ (cons t-mat rslt))
                                          (t-mat (left baselig) (left t-mat)))
                                         ((eq t-mat baselig) rslt)
                                       (declare
                                        (list rslt)
                                        (type t-mat t-mat)))))
                       (declare (type t-mat item))
                       (format stream "[C~D=~D]" (icol item) (val item))))
                   (format stream "~%========== END-MATRIX"))
                 mtrx)))
#+clisp(eval-when (:compile-toplevel :load-toplevel :execute)
         (setf (ext:package-lock :clos) t))


(defun disp-matrice-colonnes (mat)
  (let ((ncol (ncol mat)))
    (do ((i 1 (1+ i)))
        ((> i ncol))
      (disp-colonne mat i)))
  (done))

(defun terme (mat i j)
  (let ((p (left (chercher-hor (baselig mat i) j))))
    (if (= j (icol p))
        (val (left p))
        nil)))

(defun mat-aleat (n1 n2 dens x)
  (let ((mat (creer-matrice n1 n2))
        (n (truncate (* dens n1 n2)))
        (2x (* 2 x))
        (res nil))
    (dotimes (i n)
      (let* ((il (1+ (random n1)))
             (ic (1+ (random n2)))
             (val (let ((pval (- (random 2x) x)))
                    (if (minusp pval)
                        pval
                        (1+ pval))))
             (elem (member il res
                           :test #'(lambda (x y) (eql x (first y))))))
        (if elem
            (push (list ic val) (cadar elem))
            (push (list il (list (list ic val))) res))))
    (maj-matrice mat res)))

(defun op-elem (pl pc alpha)
  (if (eq (left pl) (up pc))
      (if (= alpha (val (left pl)))
          (supprimer-terme pl pc)
          (decf (val (left pl)) alpha))
      (inserer-terme pl pc (- alpha))))

(defun peigne-ver (mat ptl il)
  (if (< il (ilig ptl))
      (do ((res nil (cons (chercher-ver pl il)
                          res))
           (pl (left ptl) (left pl)))
          ((eq pl ptl) (nreverse res)))
      (do ((res nil (cons (chercher-ver (basecol mat (icol pl)) il)
                          res))
           (pl (left ptl) (left pl)))
          ((eq pl ptl) (nreverse res)))))

(defun peigne-hor (mat ptc ic)
  (if (< ic (icol ptc))
      (do ((res nil (cons (chercher-hor pc ic)
                          res))
           (pc (up ptc) (up pc)))
          ((eq pc ptc) (nreverse res)))
      (do ((res nil (cons (chercher-hor (baselig mat (ilig pc)) ic)
                          res))
           (pc (up ptc) (up pc)))
          ((eq pc ptc) (nreverse res)))))

(defun op-lig (ptl1 ptl2 peigne lambda)
  (do ((pl1 (left ptl1) (left pl1))
       (pp peigne (rest pp))
       (pl2 ptl2))
      ((endp pp) ptl2)
    (setf pl2 (chercher-hor pl2 (icol pl1)))
    (op-elem pl2 (first pp) (* lambda (val pl1)))))

(defun op-col (ptc1 ptc2 peigne lambda)
  (do ((pc1 (up ptc1) (up pc1))
       (pp peigne (rest pp))
       (pc2 ptc2))
      ((endp pp) ptc2)
    (setf pc2 (chercher-ver pc2 (ilig pc1)))
    (op-elem (first pp) pc2 (* lambda (val pc1)))))

(defun op-lig-n (mat l1 l2 lambda)
  (op-lig (baselig mat l1)
          (baselig mat l2)
          (peigne-ver mat (baselig mat l1) l2)
          lambda))

(defun op-col-n (mat c1 c2 lambda)
  (op-col (basecol mat c1)
          (basecol mat c2)
          (peigne-hor mat (basecol mat c1) c2)
          lambda))

(defun n-lig (mat)
  (1- (array-dimension (leftcol mat) 0)))

(defun n-col (mat)
  (1- (array-dimension (uplig mat) 0)))

(defun copier-matrice (mat)
  (let ((mat2 (creer-matrice (n-lig mat) (n-col mat))))
    (do ((i 1 (1+ i)))
        ((> i (n-lig mat)) mat2)
      (do ((ptl1 (baselig mat i))
           (pl1 (left (baselig mat i)) (left pl1))
           (pl2 (baselig mat2 i) (left pl2)))
          ((eq pl1 ptl1))
        (inserer-terme pl2 (basecol mat2 (icol pl1)) (val pl1))))))

(defun reste (a b)
  (second (multiple-value-list (round a b))))

(defun diviseur (a b)
  (round a b))

(defun maj-peigne-ver (peigne il)
  (do ((pp peigne (rest pp)))
      ((endp pp) peigne)
    (setf (first pp) (chercher-ver (first pp) il))))

(defun maj-peigne-hor (peigne ic)
  (do ((pp peigne (rest pp)))
      ((endp pp) peigne)
    (setf (first pp) (chercher-hor (first pp) ic))))

(defun identite (n)
  (let ((mat (creer-matrice n n)))
    (do ((ptl (baselig mat n) (up ptl))
         (ptc (basecol mat n) (left ptc)))
        ((eq ptl ptc))
      (inserer-terme ptl ptc 1))
    mat))

(defun init-peigne-ver (mat ptl)
  (do ((res nil (cons (basecol mat (icol pl))
                      res))
       (pl (left ptl) (left pl)))
      ((eq pl ptl) (nreverse res))))

(defun init-peigne-hor (mat ptc)
  (do ((res nil (cons (baselig mat (ilig pc))
                      res))
       (pc (up ptc) (up pc)))
      ((eq pc ptc) (nreverse res))))

(defun disp-peigne (peigne)
  (mapcar #'(lambda (elem) (first (disp-p elem)))
          peigne))

(defun terme-minimal-matrice (mat)
  (catch '?
    (do* ((fin (baselig mat 0))
          (ptl (up fin) (up ptl)))
         ((eq ptl fin) (throw '? nil))
      (if (not (eq ptl (left ptl)))
          (let* ((pmin (left ptl))
                 (min (abs (val pmin))))
            (if (= min 1) (throw '? pmin))
            (do ((ptl ptl (up ptl)))
                ((eq ptl fin) (throw '? pmin))
              (do ((pl (left ptl) (left pl)))
                  ((eq pl ptl))
                (let ((val (abs (val pl))))
                  (when (< val min)
                    (if (= val 1) (throw '? pl))
                    (setq pmin pl min val))))))))))

(defun tuer-ligne (mat il)
  (let* ((ptl (baselig mat il))
         (peigne (peigne-ver mat ptl il)))
    (do ((pp peigne (rest pp)))
        ((endp pp))
      (supprimer-terme ptl (first pp)))
    (setf (up (chercher-ver (baselig mat 0) il)) (up ptl)))
  mat)

(defun tuer-colonne (mat ic)
  (let* ((ptc (basecol mat ic))
         (peigne (peigne-hor mat ptc ic)))
    (do ((pp peigne (rest pp)))
        ((endp pp))
      (supprimer-terme (first pp) ptc))
    (setf (left (chercher-hor (basecol mat 0) ic)) (left ptc)))
  mat)

(defun pivot (mat p)
  (let* ((div (val p))
         (ptl (baselig mat (ilig p)))
         (ptc (basecol mat (icol p)))
         (peigne (init-peigne-ver mat ptl))
         (peigne2 '*non-defini*))
    (do ((pc (up ptc) (up pc)))
        ((eq pc ptc))
      (maj-peigne-ver peigne (ilig pc))
      (if (eq pc p)
          (setf peigne2 (copy-list peigne))
          (op-lig ptl
                  (baselig mat (ilig pc))
                  peigne
                  (truncate (val pc) div))))
    (do ((pp peigne2 (rest pp)))
        ((endp pp))
      (supprimer-terme ptl (first pp)))
    (setf (left (chercher-hor (basecol mat 0) (icol p))) (left ptc))
    (setf (up   (chercher-ver (baselig mat 0) (ilig p))) (up   ptl))
    (list (ilig p) (icol p) (val p))))

(defun pivot-parallele (M N p)
  (let* ((div (val p))
         (ic (icol p))
         (ptl (baselig M (ilig p)))
         (ptc (basecol N ic))
         (peigne (init-peigne-hor N ptc))
         (peigne2 '*non-defini*))
    (do ((pl (left ptl) (left pl)))
        ((eq pl ptl))
      (maj-peigne-hor peigne (icol pl))
      (if (eq pl p)
          (setf peigne2 (copy-list peigne))
          (op-col ptc
                  (basecol N (icol pl))
                  peigne
                  (truncate (val pl) div))))
    (do ((pp peigne2 (rest pp)))
        ((endp pp))
      (supprimer-terme (first pp) ptc))
    (setf (left (chercher-hor (basecol N 0) ic)) (left ptc))))

(defun generateur-torsion-H* (B N p)
  (let ((tab (make-array (1+ (n-lig B)) :initial-element 0))
        (ptcN (basecol N (icol p))))
    (do ((pcN (up ptcN) (up pcN)))
        ((eq pcN ptcN))
      (let ((facteur (truncate (val pcN) (val p)))
            (ptcB (basecol B (ilig pcN))))
        (do ((pcB (up ptcB) (up pcB)))
            ((eq pcB ptcB))
          (incf (aref tab (ilig pcB)) (* (val pcB) facteur)))))
    (cons (abs (val p))
          (let ((res '()))
            (do ((ind (n-lig B) (1- ind)))
                ((zerop ind) res)
              (if (/= 0 (aref tab ind))
                  (push (cons (aref tab ind) ind) res)))))))

(defun terminer-H* (B)
  (let ((res '())
        (fin (basecol B 0)))
    (do ((ptc (left fin) (left ptc)))
        ((eq ptc fin) res)
      (push (cons 0
                  (do ((pc (up ptc) (up pc))
                       (res '() (cons (cons (val pc) (ilig pc)) res)))
                      ((eq pc ptc) res)))
            res))))

(defun reste-minimal-ligne (mat p)
  (block ?
    (let ((div (val p))
          (ptl (baselig mat (ilig p))))
      (do ((pl (left ptl) (left pl)))
          ((eq pl ptl) (return-from ? nil))
        (let ((val (reste (val pl) div)))
          (if (/= 0 val)
              (if (= 1 val)
                  (return-from ? pl)
                  (let ((pmin pl)
                        (min val))
                    (do ((pl (left pl) (left pl)))
                        ((eq pl ptl) (return-from ? pmin))
                      (let ((val (reste (val pl) div)))
                        (if (and (/= 0 val) (< val min))
                            (if (= 1 val)
                                (return-from ? pl)
                                (setf pmin pl min val)))))))))))))

(defun reste-minimal-colonne (mat p)
  (block ?
    (let ((div (val p))
          (ptc (basecol mat (icol p))))
      (do ((pc (up ptc) (up pc)))
          ((eq pc ptc) (return-from ? nil))
        (let ((val (reste (val pc) div)))
          (if (/= 0 val)
              (if (= 1 val)
                  (return-from ? pc)
                  (let ((pmin pc)
                        (min val))
                    (do ((pc (up pc) (up pc)))
                        ((eq pc ptc) (return-from ? pmin))
                      (let ((val (reste (val pc) div)))
                        (if (and (/= 0 val) (< val min))
                            (if (= 1 val)
                                (return-from ? pc)
                                (setf pmin pc min val)))))))))))))



(defun homologie (M N)
  (prog ((B (identite (n-col M)))
         (res nil)
         (p1) (p2) (div))
   depart1
   (setf p1 (terme-minimal-matrice M))
   loop1
   (if (null p1)
       (go depart2)
       (if (= 1 (abs (val p1)))
           (go pivot1)
           (progn (setf p2 (reste-minimal-colonne M p1))
                  (if (null p2)
                      (progn (setf p2 (reste-minimal-ligne M p1))
                             (if (null p2)
                                 (go pivot1)
                                 (go op-col1)))
                      (go op-lig1)))))
   op-lig1
   (op-lig-n M (ilig p1) (ilig p2) (diviseur (val p2) (val p1)))
   (setf p1 p2)
   (go loop1)
   op-col1
   (setf div (diviseur (val p2) (val p1)))
   (op-col-n M (icol p1) (icol p2) div)
   (op-col-n B (icol p1) (icol p2) div)
   (op-lig-n N (icol p2) (icol p1) (- div))
   (setf p1 p2)
   (go loop1)
   pivot1
   (tuer-ligne N (icol p1))
   (pivot-parallele M B p1)
   (pivot M p1)
   (go depart1)

   depart2
   (setf p1 (terme-minimal-matrice N))
   loop2
   (if (null p1)
       (go depart3)
       (if (= 1 (abs (val p1)))
           (go pivot2)
           (progn (setf p2 (reste-minimal-ligne N p1))
                  (if (null p2)
                      (progn (setf p2 (reste-minimal-colonne N p1))
                             (if (null p2)
                                 (go pivot2-torsion)
                                 (go op-lig2)))
                      (go op-col2)))))
   op-lig2
   (setf div (diviseur (val p2) (val p1)))
   (op-col-n B (ilig p2) (ilig p1) (- div))
   (op-lig-n N (ilig p1) (ilig p2) div)
   (setf p1 p2)
   (go loop2)
   op-col2
   (op-col-n N (icol p1) (icol p2) (diviseur (val p2) (val p1)))
   (setf p1 p2)
   (go loop2)
   pivot2-torsion
   (setf res (cons (generateur-torsion-H* B N p1) res))
   pivot2
   (tuer-colonne B (ilig p1))
   (pivot N p1)
   (go depart2)

   depart3
   (return (append res (terminer-H* B)))))


(DEFUN CHCM-MAT (chcm n)
  (declare
   (type chain-complex chcm)
   (fixnum n))
  (when (eq (basis chcm) :locally-effective)
    (error "CHCMC-MAT cannot work with a LOCALLY-EFFECTIVE chain complex."))
  (let ((sorc (basis chcm n))
        (trgt (basis chcm (1- n)))
        (cmpr (cmpr chcm)))
    (declare
     (list sorc trgt)
     (type cmprf cmpr))
    (format t "~%Computing boundary-matrix in dimension ~D.
Rank of the source-module : ~D.~2%"
            n (length sorc))
    (let ((sorcl (length sorc))
          (mat (creer-matrice (length trgt) (length sorc)))
          (test #'(lambda (gnrt1 gnrt2)
                    (eq (funcall cmpr gnrt1 gnrt2) :equal))))
      (declare
       (fixnum sorcl)
       (type matrice mat)
       (function test))
      (do ((i 1 (1+ i))
           (mark sorc (cdr mark)))
          ((endp mark))
        (declare
         (fixnum i)
         (list mark))
        (when *homology-verbose*
          (clock)
          (format t "Computing the boundary of the generator ~D/~D (dimension ~D) :"
                  i sorcl n)
          (print (car mark)))
        (maj-colonne mat i
                     (mapcar #'(lambda (term)
                                 (declare (type term term))
                                 (list
                                  (1+ (position (gnrt term) trgt :test test))
                                  (cffc term)))
                             (cmbn-list (? chcm n (car mark)))))
        (when *homology-verbose*
          (format t "~%End of computing.~2%")))
      mat)))


(defun chcm-homology (cc n)
  (declare (type chain-complex cc) (type fixnum n))
  (let ((rsl (homologie (chcm-mat cc n) (chcm-mat cc (1+ n)))))
    (declare (type list rsl))
    (format t "~3%Homology in dimension ~D :~%" n)
    (dolist (item rsl)
      (declare (type list item))
      (format t "~2%Component Z")
      (unless (zerop (first item))
        (format t "/~DZ" (first item)))))
  (terpri) (terpri)
  (done))


(defun chcm-homology-gen (cc n)
  (declare (type chain-complex cc) (type fixnum n))
  (let ((src (cons :unused (basis cc n)))
        (rsl (homologie (chcm-mat cc n) (chcm-mat cc (1+ n)))))
    (declare (type list src rsl))
    (format t "~3%Homology in dimension ~D :~%" n)
    (dolist (item rsl)
      (declare (type list item))
      (format t "~%Component Z")
      (unless (zerop (first item))
        (format t "/~DZ" (first item))))
    (terpri) (terpri)
    (setf rsl (mapcar #'cdr rsl))
    (setf rsl (mapcar #'(lambda (item)
                          (declare (type list item))
                          (mapcar #'(lambda (term)
                                      (declare (type term term))
                                      (term (car term) (nth (cdr term) src)))
                                  item))
                      rsl))
    (setf rsl (mapcar #'(lambda (item)
                          (declare (type list item))
                          (make-cmbn :degr n :list item))
                      rsl))
    rsl))


(defun chcm-homology-gen-old (cc n)
  (declare (type chain-complex cc) (type fixnum n))
  (let ((src (cons :unused (basis cc n)))
        (rsl (homologie (chcm-mat cc n) (chcm-mat cc (1+ n)))))
    (declare (type list src rsl))
    (format t "~3%Homology in dimension ~D :~%" n)
    (dolist (item rsl)
      (declare (type list item))
      (format t "~2%Component Z")
      (unless (zerop (first item))
        (format t "/~DZ" (first item)))
      (format t "~2%Generator :")
      (dolist (item2 (rest item))
        (declare (type cons item2))
        (format t "~%~D~6T*  ~S" (car item2) (nth (cdr item2) src)))))
  (done))
