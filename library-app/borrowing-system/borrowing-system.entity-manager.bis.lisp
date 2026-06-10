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
    (db BorrowingRecord ?br book ?b)
    (is ?b item)
  )

) ;; end function
