(bis:def-component ::de.h-da.lop.library-app.borrowing-system
  (:nicknames :borrowing-system)
  (:documentation "Package that manage stuff about book borrowing (borrow, return, ...)")
  (:languages :functional :oo :bis :rule :workflow :test)
  (:import
    ;; PACKAGE DEPENDENCIES
    :users
    :resources
    :stock

   )
  (:export
    ;; DATATYPES
    eCustomerRating
    eReturnCase
    tDate
    make-tDate ;; constructor of struct tDate

    ;; CLASSES / ENTITIES
    BorrowingRecord
    get-start-date ;; getter of class BorrowingRecord
    get-due-date ;; getter of class BorrowingRecord
    get-is-returned ;; getter of class BorrowingRecord
    get-customer ;; getter of class BorrowingRecord
    get-book ;; getter of class BorrowingRecord

    ;; ENTITY MANAGER FUNCTIONS
    findAllRecordsFromBookItem
    findAllRecordsFromCustomer
    findAllNormalRecordsFromCustomer
    findAllLateRecordsFromCustomer
    findAllDamageRecordsFromCustomer

    ;; SERVICE FUNCTIONS
    dateToStringFormat
    getCustomerRating
    isBookItemAvailable
    borrowBookItem
    returnBookItem
    calculDueDate
   )
  )
