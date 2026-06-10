(in-package :borrowing-system)


;;; =====================================
;;; TESTS
;;; =====================================

(def-test borrowing-record-test
  (let* ((customer (make-instance 'Customer))
         (book-ref (make-instance 'BookReference
                     :title "Book"
                     :author "Author"))
         (book-item (make-instance 'BookItem
                      :book-ref book-ref))
         (record
          (make-instance 'BorrowingRecord
            :start-date (make-tDate :day 1 :month 1 :year 2025)
            :due-date (make-tDate :day 15 :month 1 :year 2025)
            :customer customer
            :book book-item)))

    (assert-false (get-is-returned record))
    (assert-equal customer (get-customer record))
    (assert-equal book-item (get-book record))
  )
)

(def-test return-book-item-test
  (let ((record
         (make-instance 'BorrowingRecord
           :start-date (make-tDate :day 1 :month 1 :year 2025)
           :due-date (make-tDate :day 15 :month 1 :year 2025))))
    
    (assert-false (get-is-returned record))
    (returnBookItem record)
    (assert-true (get-is-returned record))
  )
)

(def-test is-book-item-available-test

  (let* ((book (make-instance 'BookReference
                :title "Book"
                :author "Author"))
        (customer (make-instance 'Customer)))

    (let* ((item (make-instance 'BookItem
                  :book-ref book)))

      (assert-true (isBookItemAvailable item))

      (borrowBookItem item customer)

      (assert-false (isBookItemAvailable item))
    )
  )
)
