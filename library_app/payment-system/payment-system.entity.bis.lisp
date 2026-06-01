(in-package :payment-system)


;;; =====================================
;;; ENTITY CLASSES
;;; =====================================

(def-entity Transaction ()
  (
    (reference 
      :type 'eTransactionReference
      :documentation "The reason of the transaction (see enum eTransactionReference)")
    (date
      :type 'tDate
      :documentation "The date when the transaction was made")
    (amount
      :type 'number
      :documentation "The amount of money of the transaction")
     
    (customer
      :type 'Customer
      :documentation "The customer instance who borrowed the book")
  )
      
  (:documentation "Record of a transaction from a customer to the library")
)
