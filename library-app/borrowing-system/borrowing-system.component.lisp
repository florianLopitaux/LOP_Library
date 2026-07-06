(bis:def-component ::de.h-da.lop.library-app.borrowing-system
  (:nicknames :borrowing-system)
  (:documentation "Package that manage stuff about book borrowing (borrow, return, ...)")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import
    :users
    :resources
    :stock

   )
  (:export
    tDate
    make-tDate

    ;; CLASSES
    BorrowingRecord
    get-start-date
    get-due-date
    get-is-returned
    set-is-returned
    get-customer
    get-book

    ;; FUNCTIONS
    toHistoryStringFormat
    getCustomerRating
    isBookItemAvailable
    borrowBookItem
    returnBookItem
    findAllRecordsFromBookItem
    findAllRecordsFromCustomer
    findAllNormalRecordsFromCustomer
    findAllLateRecordsFromCustomer
    findAllDamageRecordsFromCustomer
   )
  )
