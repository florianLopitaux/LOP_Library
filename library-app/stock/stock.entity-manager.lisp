(in-package :stock)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllBookItemsFromBook (
    (book :type BookReference :documentation "The Book instance used to retrieve the linked BookItems")
  )
  ;; function documentation
  (
    :documentation "Get all book items that reference the given book"
    :examples "(findAllBookItemsFromBook #<Book [13]* 'Harry Potter'>) -> (#<BookItem [66]* #<Book [13]* 'Harry Potter'> :damage> #<BookItem [84]* #<Book [13]* 'Harry Potter'> :perfect>)"
    :pre (not (equal book nil))
    :result-type list
  )

  ;; function body
  (query ?bi
    (db BookItem ?bi book-ref ?b)
    (is ?b book)
  )

) ;; end function


(def-function findAllBookItemsDamaged ()
  ;; function documentation
  (
    :documentation "Get all book items that are currently damaged"
    :examples "(findAllBookItemsDamaged) -> (#<BookItem [7]* ... :damage #<BookItem [10]* ... :damage #<BookItem [89]* ... :damage)"
    :result-type list
  )

  ;; function body
  (query ?bi
    (db BookItem ?bi state :damage)
  )

) ;; end function


(def-function findAllBookItemsPerfect ()
  ;; function documentation
  (
    :documentation "Get all book items that are currently in a perfect condition"
    :examples "(findAllBookItemsPerfect) -> (#<BookItem [3]* ... :perfect #<BookItem [5]* ... :perfect #<BookItem [18]* ... :perfect)"
    :result-type list
  )

  ;; function body
  (query ?bi
    (db BookItem ?bi state :perfect)
  )

) ;; end function
