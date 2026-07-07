(in-package :payment-system)


;;; =====================================
;;; SERVICE FUNCTIONS
;;; =====================================

(def-function computeTransactionPrice (
    (cust :type Customer :documentation "The customer instance who make the transaction")
    (transaction-ref :type eTransactionReference :documentation "The reference of the transaction (the reason)")
  )
  ;; function body
  (first (query ?price
         (is ?c cust)
         (is ?r transaction-ref)
         (computePrice ?c ?r ?price)
  ))

) ;; end function

(def-function makePayment (
    (customer :type Customer :documentation "The customer instance who does the transaction")
    (payment-reason :type eTransactionReference :documentation "The reason of the transaction")
  )
  ;; function documentation
  (
    :documentation "Create a transaction payment depending on parameters"
    :examples "(makePayment 'customer, :subscription) -> #Transaction[59]* ..."
    :pre (not (equal customer nil))
    :pre (not (equal payment-reason nil))
    :result-type Transaction
  )

  ;; function body
  (let* ((current-time (cl:multiple-value-list (cl:get-decoded-time)))
    (today-day   (cl:fourth current-time))
    (today-month (cl:fifth current-time))
    (today-year  (cl:sixth current-time))

    (transaction (make-instance 'Transaction
        :reference payment-reason
        :date (make-tDate :month today-month :day today-day :year today-year)
        :amount (computeTransactionPrice customer payment-reason)
        :customer customer)))

    (format t "~%[INFO] ~A has paid ~A euros for ~A.~%" (customerToStringFormat customer) (get-amount transaction) payment-reason)
    transaction
  )

) ;; end function


(def-function subscribeNewCustomer (
    (customer-name :type tFullName :documentation "The name of the customer")
    (customer-role :type eCustomerRole :documentation "The role of the new customer")
    &key 
    (customer-address :type tAddress :documentation "(optional) The home address of the customer")
    (customer-email :type 'string :documentation "(optional) The email of the customer")
  )
  ;; function documentation
  (
    :documentation "Create a record of the BookItem borrowing by the customer"
    :examples "(borrowBookItem 'item1) -> false, (borrowBookItem 'item2) -> true"
    :pre (not (equal customer-name nil))
    :pre (not (equal customer-role nil))
    :result-type Customer
  )

  ;; function body

  (let ((new-customer
    (createCustomer customer-name customer-role :address customer-address :email customer-email)
    ))

    (makePayment new-customer :subscription)
    new-customer
  )

) ;; end function
