(in-package :sample-component)


(def-entity BorrowingRecord (Librarian BorrowingRecord)
    (
     (borrowDate
      :type 'Date
      :documentation "title of the book")
     (dueDate
      :type 'string
      :documentation "author of the book")
     (returnDate
      :type 'boole
      :documentation "boolean for if a book is available or  not")
      
    (:documentation "Book")
    )
)




   
