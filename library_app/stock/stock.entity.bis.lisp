(in-package :stock)


;;; =====================================
;;; ENTITY CLASSES
;;; =====================================

(def-entity BookItem ()
  (
    (book-ref
      :type 'BookReference
      :documentation "Book references of the item")
    (state
      :type 'eBookCondition
      :initform :perfect
      :documentation "The current condition of the book copy")
  )
    
  (:documentation "BookItem that represents one copy of a Book in the storage of the library")
)
