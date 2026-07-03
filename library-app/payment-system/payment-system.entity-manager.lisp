(in-package :payment-system)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllTransactionsFromCustomer (
    (customer :type Customer :description "The Customer instance to use")
  )
  ;; function documentation
  (
    :documentation "Get all Transactions associated with a specific customer"
    :examples "(findAllTransactionsFromCustomer 'customer1) -> (#<Transaction[5]* ...> #<Transaction [16]*  ...>)"
    :pre (not (equal customer nil))
    :result-type list
  )

  ;; function body
  (query ?t
    (db Transaction ?t customer ?c)
    (is ?c customer)
  )

) ;; end function
