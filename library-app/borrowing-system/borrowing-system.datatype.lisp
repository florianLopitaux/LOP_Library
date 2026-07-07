(in-package :borrowing-system)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-enum-type eCustomerRating
    (:low :medium :high)

  "Rating bounds of a customer")

(def-enum-type eReturnCase 
    (:normal :late :damage :late-damage)

  "State of the returned book for a borrow")


(def-struct tDate month day year)
