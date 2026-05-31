(bis:def-component :de.h-da.lop.app.sample-app.stock
  (:nicknames :stock)
  (:documentation "Package that relate to all types of managing the stock of the library")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import
    ;; PACKAGE DEPENDENCIES
    :resources

   )
  (:export
    ;; DATATYPES
    eBookCondition

    ;; CLASSES
    BookItem

    ;; FUNCTIONS
    findAllBookItemsFromBook
    findAllBookItemsDamaged
    findAllBookItemsPerfect
   )
  )
