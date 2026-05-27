(in-package :borrowing-system)

(def-entity BorrowingRecord ()
    (
     (startDate
      :type 'tDate
      :documentation "The date when the book has been borrowed")
     (dueDate
      :type 'tDate
      :documentation "The maximum date when the book has to be return")
     (isReturn
      :type 'boolean
      :initform false
      :documentation "boolean to know if the book has already been return or not")
     
     (customer
      :type 'customer
      :documentation "The customer instance who borrowed the book")
     (book
      :type 'Book
      :documentation "The book instance which has been borrow")
     )
      
  (:documentation "Record of a book borrowed by a customer")
  )
