(in-package :users)


;;; =====================================
;;; DATATYPES
;;; =====================================

(def-enum-type eCustomerStatus
    (:active :disable)

  "Status of a customer to the library")


(def-enum-type eCustomerRole
    (:normal :student :professor)
  "Role of a costumer")


(def-enum-type eCustomerRating
    (:low :medium :high)
  "Rating of a customer")


(def-struct tFullName first-name last-name)


(def-struct tAddress street zip city country)
