(in-package :users)

;;; =====================================
;;; TESTS
;;; =====================================

(def-test customer-default-values-test
  (let ((customer
         (make-instance 'Customer
           :name (make-tFullName :first-name "John" :last-name "Doe")
           :address (make-tAddress :street "Main Street" :zip 12345 :city "Darmstadt" :country "Germany")
           :email "john@doe.com")))

    (assert-equal :disable (get-status customer))
    (assert-equal :normal (get-role customer))
  )
)

(def-test find-all-students-test

  (let* ((student
           (make-instance 'Customer
             :role :student))

         (professor
           (make-instance 'Customer
             :role :professor))

         (result (findAllStudents)))

    (assert-true (member student result))
    (assert-false (member professor result))
  )
)
