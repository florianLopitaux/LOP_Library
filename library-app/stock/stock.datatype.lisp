(in-package :stock)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-enum-type eBookCondition
    (:damage :perfect)

  "State of a BookItem")
