(bis:def-component :de.h-da.lop.app.sample-app.stock
  (:nicknames :stock)
  (:documentation "Package that relate to all types of managing the stock of the library")
  (:languages :functional :oo :bis :rule :workflow :test)
  (:import
    ;; PACKAGE DEPENDENCIES
    :resources

   )
  (:export
    ;; DATATYPES
    eBookCondition

    ;; CLASSES / ENTITIES
    BookItem
    get-book-ref ;; getter of class BookItem
    get-state ;; getter of class BookItem

    ;; ENTITY MANAGER FUNCTIONS
    findAllBookItemsFromBook
    findAllBookItemsDamaged
    findAllBookItemsPerfect

    ;; SERVICE FUNCTIONS
    createBookItem
   )
  )
