(in-package :users)


;;; =====================================
;;; EXPORT SERVICE FUNCTIONS
;;; =====================================

(def-function toStringFormat (
    (cust :type Customer :documentation "Customer instance to transform")
  )
  ;; function body
  (format nil "~A ~C ~A ~A" (get-oid cust) #\~ (tFullName-first-name (get-name cust)) (tFullName-last-name (get-name cust)))

) ;; end function

(def-function toListStringFormat (
    (customers :type list :documentation "List of customer instances to transform")
  )
  ;; function body
  (collect (lambda (x) (toStringFormat x)) customers)

) ;; end function

(def-function fromStringFormat (
    (string-cust :type string :documentation "The formatted string customer to convert into customer instance")
  )
  ;; function body
  (let* ((pos (cl:position #\~ string-cust))
       (cust-oid (cl:parse-integer (cl:subseq string-cust 0 pos))))
    
    (find-by-oid 'Customer cust-oid)
  )

) ;; end function

(def-function applyDiscount (
    (customer :type Customer :documentation "The Customer instance")
    (amount :type number :documentation "The amount to apply the reduction before paying")
  )
  ;; function documentation
  (
    :documentation "Apply a discount on a money amount depending on the role of customer object"
    :examples "(role = :student) -> amount*0.2, (role = professor) -> amount*0.5, (role = normal) -> amount"
    :pre (not (equal customer nil))
    :pre (not (equal amount nil))
    :pre (>= amount 0)
    :post (<= :result amount)
    :result-type number
  )

  ;; function body
  (cond
    ((equal (get-role customer) :professor) (* amount 0.5))  ;; professor case -> 50% discount
    ((equal (get-role customer) :student) (* amount 0.2))  ;; student case -> 80% discount
    (else amount)  ;; normal customer case -> no discount
  ) ;; end cond

) ;; end function

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
    :status :active)
)
