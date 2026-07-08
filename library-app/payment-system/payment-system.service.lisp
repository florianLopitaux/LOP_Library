(in-package :payment-system)


;;; =====================================
;;; SERVICE FUNCTIONS
;;; =====================================

(def-function computeLibraryBalance ()
  ;; function documentation
  (
    :documentation "Make the sum of all Transactions instances to compute the library balance"
    :examples "(computeLibraryBalance) -> 247"
    :post (>= :result 0)
    :result-type number
  )

  ;; function body
  (reduce '+ (collect 'get-amount (find-all 'Transaction)) :initial-value 0)

) ;; end function


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


(def-function computeSubscriptionPrice (
    (role :type eCustomerRole :documentation "The customer role who is going to subscribe")
  )
  ;; function body
  (first (query ?price
         (is ?r role)
         (computeSubscriptionPrice ?r ?price)
  ))

) ;; end function


(def-function makePayment (
    (customer :type Customer :documentation "The customer instance who does the transaction")
    (payment-reason :type eTransactionReference :documentation "The reason of the transaction")
  )
  ;; function documentation
  (
    :documentation "Create a transaction payment depending on parameters"
    :examples "(makePayment customer1 :subscription) -> #Transaction[59]* ..."
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

    (format t "~%[INFO] ~A has paid ~A euros for ~A." (to-string-summary customer) (get-amount transaction) payment-reason)
    transaction
  )

) ;; end function
