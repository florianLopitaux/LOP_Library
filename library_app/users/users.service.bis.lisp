(in-package :users)


;;; =====================================
;;; EXPORT SERVICE FUNCTIONS
;;; =====================================

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
    :return-type 'number
  )

  ;; function body
  (cond
    ((equal (get-role customer) :professor) (* amount 0.5))  ;; professor case -> 50% discount
    ((equal (get-role customer) :student) (* amount 0.2))  ;; student case -> 80% discount
    (else amount)  ;; normal customer case -> no discount
  ) ;; end cond

) ;; end function
