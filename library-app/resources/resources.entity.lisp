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


;;; ========================================
;;;  Method overrides from better_lang package oo
;;; ========================================

(defmethod oo:to-string-summary ((book-ref BookReference))
  ;; method body
  (format nil "~A ~~ ~A"
      (get-oid book-ref)
      (get-title book-ref)
  )

) ;; end method

(defmethod oo:to-string-details ((book-ref BookReference))
  ;; method body
  (format nil "~%BookReference [~A] {~% - title: ~A~% - author: ~A~% - type: ~A~%}"
    (get-oid book-ref)
    (get-title book-ref)
    (get-author book-ref)
    (get-type book-ref)
  )

) ;; end method

(defmethod oo:from-string-summary ((target-class (eql 'BookReference)) str)
  ;; method body
  (let* ((pos (cl:position #\~ str))
         (book-ref-oid (cl:parse-integer (cl:subseq str 0 pos))))
    
    (find-by-oid 'BookReference book-ref-oid)
  )

) ;; end method
