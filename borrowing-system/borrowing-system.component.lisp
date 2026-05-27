(bis:def-component ::de.h-da.lop.library-app.borrowing-system
  (:nicknames :borrowing-system)
  (:documentation "Package that manage stuff about book borrowing (borrow, return, ...)")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import
    ;; :users (import error)
    :resources
   )
  (:export
    tDate
    BorrowingRecord 
   )
  )
