(bis:def-component ::de.h-da.lop.library-app.payment-system
  (:nicknames :payment-system)
  (:documentation "Package that manage stuff about payments for the library (subscription, penalty, ...)")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import
    ;; PACKAGE DEPENDENCIES
   :borrowing-system
   :users

   )
  (:export
    ;; DATATYPES
    eTransactionReference

    ;; CLASSES
    Transaction

    ;; FUNCTIONS
    findAllTransactionsFromCustomer
    makePayment
    subscribeNewCustomer
   )
  )
