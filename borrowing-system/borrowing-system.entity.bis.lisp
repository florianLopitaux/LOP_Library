(in-package :borrowing-system)


;;; =====================================
;;; ENTITY CLASSES
;;; =====================================

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
     
    (customer
      :type 'Customer
      :documentation "The customer instance who borrowed the book")
    (book
      :type 'BookItem
      :documentation "The book instance which has been borrow")
  )
      
  (:documentation "Record of a book borrowed by a customer")
)
