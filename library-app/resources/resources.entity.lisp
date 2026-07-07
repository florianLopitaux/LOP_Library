(in-package :resources)


;;; =====================================
;;; ENTITY CLASSES
;;; =====================================

(def-entity BookReference ()
  (
    (title
      :type 'string
      :documentation "title of the book")
    (author
      :type 'string
      :documentation "author of the book")
    (type
      :type 'eBookType
      :initform :normal
      :documentation "The type of the book (research paper, normal book)")
  )

  (:documentation "Book data to serve as a reference")
)
