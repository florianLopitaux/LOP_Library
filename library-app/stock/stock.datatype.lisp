(in-package :stock)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-enum-type eBookCondition
    (:damage :perfect)

  "State of a BookItem")


(def-event eventBookDelivered
  (
    (order-book-ref
      :type BookReference
      :documentation "The reference of the book ordered and who has been delivered")
    (output-stream
      :documentation "The console stream of the main thread to redirect the prints")
  )
)
