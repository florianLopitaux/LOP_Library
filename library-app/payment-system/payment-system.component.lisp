(bis:def-component ::de.h-da.lop.library-app.payment-system
  (:nicknames :payment-system)
  (:documentation "Package that manage stuff about payments for the library (subscription, penalty, ...)")
  (:languages :functional :oo :bis :rule :workflow :test)
  (:import
    ;; PACKAGE DEPENDENCIES
    :users
    :borrowing-system

   )
  (:export
    ;; DATATYPES
    eTransactionReference

    ;; CLASSES / ENTITIES
    Transaction
    get-reference ;; getter of class Transaction
    get-date ;; getter of class Transaction
    get-amount ;; getter of class Transaction
    get-customer ;; getter of class Transaction

    ;; ENTITY MANAGER FUNCTIONS
    findAllTransactionsFromCustomer

    ;; SERVICE FUNCTIONS
    computeLibraryBalance
    computeTransactionPrice
    computeSubscriptionPrice
    makePayment
   )
  )
