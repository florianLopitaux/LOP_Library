(in-package :users)


(def-enum-type customer-status
    (:active :disable)

  "Status of a customer to the library")


(def-data-type study-license string
  (lambda (str) (= (length str) 6))
  "1 letter (first character of customer name) and 5-digit")


(def-enum-type customer-role
    (:normal :student :professor)
  "Role of a costumer ")