(in-package :payment-system)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-enum-type eTransactionReference
    (:subscription :borrow-book :penalty-late-return :penalty-book-damaged)

  "Different reasons of transaction from customer to the library")
