(in-package :users)


;;; =====================================
;;; CUSTOMERS CLASSES
;;; =====================================

(def-entity Librarian ()
  ((name
    :type 'string
    :documentation "Name of the librarian")
   )
  
  (:documentation "A worker of the library")
  )

;;; =====================================
;;; CUSTOMERS CLASSES
;;; =====================================

(def-entity Customer ()
  ((name
    :type 'string
    :documentation "Surname of customer")
   (address
    :type 'string
    :documentation "full address as string")
   (email
    :type 'string
    :documentation "An email linked to the customer")
   (status
    :type 'customer-status
    :initform :disable
    :documentation "Status to know if the customer is subscribe to the library")
  (role
   :type 'customer-role
   :initform :normal
   :documentation "Role of a customer"))

  (:documentation "General customer of the library")
  )
