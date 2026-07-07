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


;;; ========================================
;;;  Method overrides from better_lang package oo
;;; ========================================

(defmethod oo:to-string-summary ((book BookItem))
  ;; method body
  (format nil "~A \~ ~A"
      (get-oid book)
      (get-title (get-book-ref book))
  )

) ;; end method

(defmethod oo:to-string-details ((book BookItem))
  ;; method body
  (format nil "~%BookReference [~A] {~% - book-ref: ~A~% - state: ~A~%}"
    (get-oid book)
    (oo:to-string-details (get-book-ref book))
    (get-state book)
  )

) ;; end method

(defmethod oo:from-string-summary ((target-class (eql 'BookReference)) str)
  ;; method body
  (let* ((pos (cl:position #\~ str))
         (book-oid (cl:parse-integer (cl:subseq str 0 pos))))
    
    (find-by-oid 'BookItem book-oid)
  )

) ;; end method
