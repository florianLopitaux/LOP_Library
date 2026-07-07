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



;;; ========================================
;;;  Method overrides from better_lang package oo
;;; ========================================

(defmethod oo:to-string-summary ((transaction Transaction))
  ;; method body
  (format nil "~A \~ reference: ~A | customer: ~A"
      (get-oid transaction)
      (get-refence transaction)
      (oo:to-string-summary (get-customer transaction))
  )

) ;; end method

(defmethod oo:to-string-details ((transaction Transaction))
  ;; method body
  (format nil "~%Transaction [~A] {~% - reference: ~A~% - date: ~A~% - amount: ~A~% - customer: ~A~%}"
    (get-oid transaction)
    (get-reference transaction)
    (get-date transaction)
    (get-amount transaction)
    (oo:to-string-details (get-customer transaction))
  )

) ;; end method

(defmethod oo:from-string-summary ((target-class (eql 'Transaction)) str)
  ;; method body
  (let* ((pos (cl:position #\~ str))
         (transaction-oid (cl:parse-integer (cl:subseq str 0 pos))))
    
    (find-by-oid 'Transaction transaction-oid)
  )

) ;; end method
