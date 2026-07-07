(in-package :users)


;;; =====================================
;;; EXPORT SERVICE FUNCTIONS
;;; =====================================

(def-function createCustomer (
    (customer-name :type tFullName :documentation "The name of the customer")
    (customer-role :type eCustomerRole :documentation "The role of the new customer")
    &key 
    (address :type tAddress :documentation "(optional) The home address of the customer")
    (email :type 'string :documentation "(optional) The email of the customer")
  )
  ;; function documentation
  (
    :documentation "Create a new customer"
    :examples "(createCustomer 'cust1) -> false, (CreateCustomer 'cust2) -> true"
    :pre (not (equal customer-name nil))
    :pre (not (equal customer-role nil))
    :result-type Customer
  )

  (make-instance 'Customer
    :name customer-name
    :address address
    :email email
    :role customer-role
  )
)
