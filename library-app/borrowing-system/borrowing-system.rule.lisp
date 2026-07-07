(in-package :borrowing-system)


;;; =====================================
;;; BUSINESS RULES
;;; =====================================

(<--- (customer-mapping ?value ?low-medium-high)
"
Rule for mapping a numeric value to :low, :medium or :high
Arguments:
?value (input) <number> - attribute value
?low-medium-high (output) <eCustomerRating> - mapped value
")

(<- (customer-mapping ?value ?low-medium-high)
    (customer-mapping-bounds ?low-bound ?high-bound)
    (is  ?low-medium-high 
        (cond ((< ?value ?low-bound) :low) 
            ((<= ?value ?high-bound) :medium) 
            (else :high))))


(<---(customer-mapping-bounds ?low-bound ?high-bound)
"
Fact for specifying bounds for categorizing values in 
:low, :medium, and :high.
Arguments:
?medium-bound (input) <number> - all values less than ?medium-bound are considered :low
?high-bound (input) <number> - all values greater or equal ?high-bound are considered :high; 
All values in-between are considered :medium
")

;; score < 0 -> :low
;; between [0 : 0.75] -> :medium
;; score > 0.75 -> :high
(<- (customer-mapping-bounds 0 0.75)!)



(<--- (customer-rating ?cust ?rating)
 "
Rule for calculating a customer score and mapping it to a rating category.
Arguments:
?cust (input) <Customer> - the customer instance to evaluate
?rating (output) : <eCustomerRating> - the computed rating category (:low, :medium, or :high)
 ")

(<- (customer-rating ?cust ?rating)
    ;; get data from customer to calcul the score
    (is ?nb-borrow (length (findAllRecordsFromCustomer ?cust)))
    (is ?nb-normal (length (findAllNormalRecordsFromCustomer ?cust)))
    (is ?nb-late (length (findAllLateRecordsFromCustomer ?cust)))
    (is ?nb-damage (length (findAllDamageRecordsFromCustomer ?cust)))
    
    ;; +1 / normal return  |  -2 / late  |  -5 / damage
    (is ?points (- ?nb-normal (+ (* ?nb-late 2) (* ?nb-damage 5))))
    ;; compute final score with average ratio
    (is ?ratio (/ ?points ?nb-borrow))

    ;; get mapping bounds to return from final score computed
    (customer-mapping ?ratio ?rating))
