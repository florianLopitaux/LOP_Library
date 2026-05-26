(in-package :sample-component)


(def-function borrowResearchDocument (professor-id book-id borrowDate)
    (:documentation "Make the variable isAvailable of the book of interest turn to nil"
    
    
    )
    (let
    ((c (find-by-oid 'Professor professor-id))
     (d (find-by-oid 'Book book-id))
     (make-instance 'BorrowingRecord
        :borrowDate borrowDate
        :returnDate (+ borrowDate 000200)
        :dueDate (+ borrowDate 000200)
        :status :active))
     
    (setf (get-isAvailable c) nil))
)

(def-function borrowBook (book-id customer-id borrowDate)
  (:documentation "Borrow book"
   )
  (let
      ((c (find-by-oid 'Book book-id))
       (d (find-by-oid 'Customer customer-id))
       (make-instance 'BorrowingRecord
        :borrowDate borrowDate
        :returnDate (+ borrowDate 000100)
        :dueDate (+ borrowDate 000100)
        :status :active)
  (setf (get-isAvailable c) nil))
  
)

(def-function returnBook (book-id customer-id)
    (:documentation
    )
    (let 
        ((c (find-by-oid 'Book book-id))
         (d (find-by-oid 'Customer book-id)))
    (setf (get-isAvailable c) nil))
;;; implement services




   
