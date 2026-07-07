(in-package :payment-system)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllTransactionsFromCustomer (
    (cust :type Customer :description "The Customer instance to use")
  )
  ;; function documentation
  (
    :documentation "Get all Transactions associated with a specific customer"
    :examples "(findAllTransactionsFromCustomer 'customer1) -> (#<Transaction[5]* ...> #<Transaction [16]*  ...>)"
    :pre (not (equal cust nil))
    :result-type list
  )

  ;; function body
  (query ?t
    (is ?c cust)
    (db Transaction ?t customer ?c)
  )

) ;; end function
