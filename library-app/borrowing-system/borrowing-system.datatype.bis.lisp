(in-package :borrowing-system)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-struct tDate month day year)


(def-enum-type eCustomerRating
    (:low :medium :high)

  "Rating of a customer")


(def-enum-type eReturnCase 
    (:normal :late :damage :late-damage)

  "State of the returned book")
