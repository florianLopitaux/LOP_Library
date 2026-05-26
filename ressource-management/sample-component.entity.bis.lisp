(in-package :sample-component)


(def-entity Book (Librarian BorrowingRecord)
    (
     (title
      :type 'string
      :documentation "title of the book")
     (author
      :type 'string
      :documentation "author of the book")
     (isAvailable
      :type 'boole
      :documentation "boolean for if a book is available or  not")
    
    (:documentation "Book")
    )
)




(def-entity ResearchDocument (Professor)
    (
     (title
      :type 'string
      :documentation "title of the book")
     (author
      :type 'string
      :documentation "author of the book")
     (isAvailable
      :type 'boole
      :documentation "boolean for if a book is available or  not")
    
    (:documentation "Book")
    )
)




   
