(in-package :borrowing-system)

(def-entity BorrowingRecord ()
    (
     (start-date
      :type 'tDate
      :documentation "The date when the book has been borrowed")
     (due-date
      :type 'tDate
      :documentation "The maximum date when the book has to be return")
     (is-returned
      :type 'boolean
      :initform false
      :documentation "boolean to know if the book has already been return or not")
     (return-case
      :type 'eReturnCase
      :initform :normal
      :documentation "The condition of the returned book borrow (could be late, damage, ...)")

     (customer
      :type 'customer
      :documentation "The customer instance who borrowed the book")
     (book
      :type 'BookItem
      :documentation "The book instance which has been borrowed")
     )
      
  (:documentation "Record of a book borrowed by a customer")
  )


;;; ========================================
;;;  Method overrides from better_lang package oo
;;; ========================================

(defmethod oo:to-string-summary ((record BorrowingRecord))
  ;; method body
  (format nil "~A \~ book: ~A | customer: ~A"
      (get-oid record)
      (oo:to-string-summary (get-book record))
      (oo:to-string-summary (get-customer record))
  )

) ;; end method

(defmethod oo:to-string-details ((record BorrowingRecord))
  ;; method body
  (format nil "BorrowingRecord [~A] {~% - borrow date: ~A~% - max due date: ~A~% - is returned: ~A~% - return case: ~A~%  - book: ~A~%  - customer: ~A~%}"
      (get-oid record)
      (dateToStringFormat (get-start-date record))
      (dateToStringFormat (get-due-date record))
      (get-is-returned record)
      (get-return-case record)
      (oo:to-string-details (get-book record))
      (oo:to-string-details (get-customer record))
  )

) ;; end method

(defmethod oo:from-string-summary ((target-class (eql 'BorrowingRecord)) str)
  ;; method body
  (let* ((pos (cl:position #\~ str))
         (record-oid (cl:parse-integer (cl:subseq str 0 pos))))
    
    (find-by-oid 'BorrowingRecord record-oid)
  )

) ;; end method
