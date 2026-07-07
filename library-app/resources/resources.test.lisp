(in-package :resources)


;;; =====================================
;;; TESTS
;;; =====================================

(def-test book-reference-test
  (let ((book
      (make-instance 'BookReference
        :title "Clean Code"
        :author "Robert Martin"
        :type :research)))

    (assert-equal "Clean Code" (get-title book))
    (assert-equal "Robert Martin" (get-author book))
    (assert-equal :research (get-type book))
  )
)
