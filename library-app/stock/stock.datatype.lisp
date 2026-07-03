(in-package :stock)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-enum-type eBookCondition
    (:damage :perfect)

  "Status of a customer to the library")


(def-event eventBookDelivered
  (
    (book-ref
      :type 'BookReference
      :documentation "The reference of the book ordered and who has been delivered")
  )
)
