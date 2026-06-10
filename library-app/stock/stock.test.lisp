(in-package :stock)


;;; =====================================
;;; TESTS
;;; =====================================

(def-test book-item-default-state-test
  (let* ((ref (make-instance 'BookReference
                 :title "Harry Potter"
                 :author "JK Rowling"))
         (item (make-instance 'BookItem
                 :book-ref ref)))

    (assert-equal :perfect (get-state item))
  )
)

(def-test book-item-values-test
  (let* ((ref (make-instance 'BookReference
                 :title "Harry Potter"
                 :author "JK Rowling"))
         (item (make-instance 'BookItem
                 :book-ref ref
                 :state :damage)))

    (assert-equal :damage (get-state item))
    (assert-equal ref (get-book-ref item))
  )
)

(def-test find-all-book-items-from-book-test

  (let* ((book (make-instance 'BookReference
                 :title "Harry Potter"
                 :author "J.K. Rowling"))

         (item1 (make-instance 'BookItem
                  :book-ref book
                  :state :perfect))

         (item2 (make-instance 'BookItem
                  :book-ref book
                  :state :damage))

         (result (findAllBookItemsFromBook book)))

    (assert-true (member item1 result))
    (assert-true (member item2 result))
  )
)

(def-test find-all-book-items-damaged-test

  (let* ((book (make-instance 'BookReference
                 :title "Harry Potter"
                 :author "Rowling"))

         (item1 (make-instance 'BookItem
                  :book-ref book
                  :state :damage))

         (item2 (make-instance 'BookItem
                  :book-ref book
                  :state :perfect))

         (result (findAllBookItemsDamaged)))

    (assert-true (member item1 result))
    (assert-false (member item2 result))
  )
)
