
(in-package :kenzo-test)

(in-suite :kenzo)

(test homology
      (progn
	(cat:cat-init)
	(let ((d (cat:delta 3)))
	  (princ (cat:homology d 0)))))
