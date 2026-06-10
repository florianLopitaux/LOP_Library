(in-package :borrowing-system)


;;; =====================================
;;; SERVICE FUNCTIONS
;;; =====================================

(def-function isBookItemAvailable (
    (item :type BookItem :description "The BookItem instance to check")
  )
  ;; function documentation
  (
    :documentation "Check if a BookItem object is available or currently borrowed"
    :examples "(isBookItemAvailable 'item1) -> false, (isBookItemAvailable 'item2) -> true"
    :pre (not (equal item nil))
  )

  ;; function body
  (_checkAliveBorrowingRecords (findAllRecordsFromBookItem item))

) ;; end function


(def-function borrowBookItem (
    (item :type BookItem :description "The BookItem instance to borrow")
    (customer :type Customer :description "The Cutomser instance who borrow a book")
  )
  ;; function documentation
  (
    :documentation "Create a record of the BookItem borrowing by the customer"
    :examples "(borrowBookItem 'item1) -> false, (borrowBookItem 'item2) -> true"
    :pre (not (equal item nil))
    :pre (isBookItemAvailable item)
    :result-type BorrowingRecord
  )

  ;; function body
  (let* ((current-time (cl:multiple-value-list (cl:get-decoded-time)))
       (today-day   (cl:fourth current-time))
       (today-month (cl:fifth current-time))
       (today-year  (cl:sixth current-time)))

    (make-instance 'BorrowingRecord
      :start-date (make-tDate :month today-month :day today-day :year today-year)
      :due-date (_createDueDate today-month today-day today-year)
      :customer customer
      :book item
    )
  )

) ;; end function


(def-function returnBookItem (
    (record :type BorrowingRecord :documentation "The BorrowRecord instance that the contains the return Book borrow by the customer")
  )
  ;; function documentation
  (
    :documentation "Do changes to confirm the return of the borrow"
    :examples "(returnBookItem 'item1) -> nil"
    :pre (not (equal record nil))
    :pre (not (get-is-returned record))
  )

  ;; function body
  (set-is-returned true record)

) ;; end function



;;; =====================================
;;; PRIVATE (not exported) FUNCTIONS
;;; =====================================

(def-function _checkAliveBorrowingRecords (
    (records :type list :documentation "list of BorrowingRecord objects")
  )
  ;; function documentation
  (
    :documentation "Check if there is at least one record which still not returned from a list"
    :examples "(_checkAliveBorrowingRecords '()) -> false, (_checkAliveBorrowingRecords '()) -> true"
  )

  ;; function body
  (cond ((= (length records) 0) true)
        ((not (get-is-returned (first records))) false)

        (else (_checkAliveBorrowingRecords (rest records)))
  )

) ;; end function


(def-function _createDueDate (
    (month :type integer :documentation "The month number of the start date")
    (day :type integer :documentation "The day number of the start date")
    (year :type integer :documentation "The year number of the start date")
  )
  ;; function documentation
  (
    :documentation "Check if there is at least one record which still not returned from a list"
    :examples "(_computeDueDate '(07 19 2003)) -> (), (_checkAliveBorrowingRecords '()) -> true"
    :pre (>= month 1)
    :pre (<= month 12)
    :pre (>= day 1)
    :pre (<= day 31)
    :pre (>= year 2000) ;; we are a new library and we haven't invented the time machine yet.
    :result-type tDate
  )

  ;; function body
  (cond ((= month 12) (make-tDate :month 1 :day day :year (+ year 1)))
        (else (make-tDate :month (+ month 1) :day day :year year))
  )

) ;; end function
