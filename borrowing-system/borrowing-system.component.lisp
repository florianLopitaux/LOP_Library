(bis:def-component ::de.h-da.lop.library-app.borrowing-system
  (:nicknames :borrowing-system)
  (:documentation "Package that manage stuff about book borrowing (borrow, return, ...)")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import
    ;; PACKAGE DEPENDENCIES
    :users
    :stock

   )
  (:export
    ;; DATATYPES
    tDate

    ;; CLASSES
    BorrowingRecord

    ;; FUNCTIONS
    isBookItemAvailable
    borrowBookItem
    returnBookItem
   
    ;; REFORWARD EXPORT (ast to professor if there is another solution)
    eCustomerRole
    tFullName
    Customer
    applyDiscount
   )
  )
