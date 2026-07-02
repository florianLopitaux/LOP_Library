(in-package :borrowing-system)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-struct tDate month day year)


(def-enum-type eReturnCase 
    (:normal :late :damage :late-damage)

  "state of the returned book")
