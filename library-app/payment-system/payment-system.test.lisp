(in-package :payment-system)


;;; =====================================
;;; TESTS
;;; =====================================

(def-test transaction-test
  (let* ((customer
          (make-instance 'Customer
            :role :normal))
         (transaction
          (make-instance 'Transaction
            :reference :subscription
            :date (make-tDate :day 1 :month 1 :year 2025)
            :amount 10
            :customer customer)))

    (assert-equal :subscription (get-reference transaction))
    (assert-equal 10 (get-amount transaction))
    (assert-equal customer (get-customer transaction))
  )
)

(def-test make-payment-test
  (let* ((customer
           (make-instance 'Customer
             :role :normal))

         (transaction
           (makePayment customer :subscription)))

    (assert-equal :subscription
                  (get-reference transaction))

    (assert-equal customer
                  (get-customer transaction))
  )
)
