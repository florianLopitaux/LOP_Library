(in-package :users)


;;; =====================================
;;; ENTITY CLASSES
;;; =====================================

(def-entity Customer ()
  (
    (name
      :type 'tFullName
      :documentation "First and last name of the customer")
    (address
      :type 'tAddress
      :documentation "full address as string")
    (email
      :type 'string
      :documentation "An email linked to the customer")
    (status
      :type 'eCustomerStatus
      :initform :disable
      :documentation "Status to know if the customer is subscribe to the library")
    (role
      :type 'eCustomerRole
      :initform :normal
      :documentation "Role of a customer")
  )


  (:documentation "General customer of the library")
)
