(in-package :borrowing-system)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllRecordsFromBookItem (
    (item :type BookItem :description "The BookItem instance to use")
  )
  ;; function documentation
  (
    :documentation "Get all BorrowingRecords linked with a specific BookItem"
    :examples "(findAllRecordsFromBookItem 'item1) -> (#<BorrowingRecord[33]* ...> #<BorrowingRecord [45]*  ...>)"
    :pre (not (equal item nil))
    :result-type list
  )

  ;; function body
  (query ?br
    (is ?b item)
    (db BorrowingRecord ?br book ?b)
  )

) ;; end function


(def-function findAllRecordsFromCustomer (
    (cust :type Customer :description "The Customer instance to use")
  )
  ;; function documentation
  (
    :documentation "Get all BorrowingRecords linked with a specific Customer"
    :examples "(findAllRecordsFromCustomer 'customer1) -> (#<BorrowingRecord[33]* ...> #<BorrowingRecord [45]*  ...>)"
    :pre (not (equal cust nil))
    :result-type list
  )

  ;; function body
  (query ?br
    (is ?c cust)
    (db BorrowingRecord ?br customer ?c)
  )

) ;; end function


(def-function findAllLateRecordsFromCustomer (
    (cust :type Customer :description "The Customer instance to use")
  )
  ;; function documentation
  (
    :documentation "Get all BorrowingRecords returned late and linked with a specific Customer"
    :examples "(findAllLateRecordsFromCustomer 'customer1) -> (#<BorrowingRecord[33]* ...> #<BorrowingRecord [45]*  ...>)"
    :pre (not (equal cust nil))
    :result-type list
  )

  ;; function body
  (query ?br
    (is ?c cust)
    (db BorrowingRecord ?br customer ?c return-case ?rc)
    (lispp (or (equal ?rc :late) (equal ?rc :late-damage)))
  )

) ;; end function


(def-function findAllDamageRecordsFromCustomer (
    (cust :type Customer :description "The Customer instance to use")
  )
  ;; function documentation
  (
    :documentation "Get all BorrowingRecords returned damage and linked with a specific Customer"
    :examples "(findAllDamageRecordsFromCustomer 'customer1) -> (#<BorrowingRecord[33]* ...> #<BorrowingRecord [45]*  ...>)"
    :pre (not (equal cust nil))
    :result-type list
  )

  ;; function body
  (query ?br
    (is ?c cust)
    (db BorrowingRecord ?br customer ?c return-case ?rc)
    (lispp (or (equal ?rc :damage) (equal ?rc :late-damage)))
  )
  
) ;; end function
