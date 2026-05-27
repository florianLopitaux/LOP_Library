(in-package :resources)


(def-entity Book ()
    (
     (title
      :type 'string
      :documentation "title of the book")
     (author
      :type 'string
      :documentation "author of the book")
     (isAvailable
      :type 'boolean
      :documentation "boolean for if a book is available or not")
     )
    
  (:documentation "Book")
  )


(def-entity ResearchDocument (Book)
    (
     (university
      :type 'string
      :documentation "document from university name")
     )
    
  (:documentation "Private research document (only available for university professors)")
  )
