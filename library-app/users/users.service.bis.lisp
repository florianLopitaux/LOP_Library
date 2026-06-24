(in-package :users)


;;; =====================================
;;; EXPORT SERVICE FUNCTIONS
;;; =====================================

(def-function getCustomerRating (
    (cust :type Customer :documentation "The customer instance")
    (borrow-books :type number :documentation "The number of book borrowed by the customer")
    (late-books :type number :documentation "The number of book returned late")
    (damage-books :type number :documentation "The number of book returned damage")
  )
  ;; function documentation
  (
    :documentation "Get the business rules rating of a given customer."
    :examples "(getCustomerRating goodCustomer) -> :high, (getCustomerRating badCustomer) -> :low"
    :pre (not (equal cust nil))
    :result-type eCustomerRating   
  )

  ;; function body
  (first (query ?r (is ?c cust)
            (is ?b borrow-books)
            (is ?l late-books)
            (is ?d damage-books)
            (customer-rating ?c ?b ?l ?d ?r)))

) ;; end function
;; to test the function : (getCustomerRating (find-by-oid 'Customer 1014) 10 2 0)


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
