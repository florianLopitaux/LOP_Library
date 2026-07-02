(in-package :borrowing-system)


;;; =====================================
;;; BUSINESS RULES
;;; =====================================

(<--- (customer-mapping ?value ?low-medium-high)
"
Rule for mapping a numeric value to :low, :medium or :high
Arguments:
?category : atom (input) - category for which mapping is defined
?value : number (input) - attribute value
?low-medium-high : atom (output) - mapped value
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
?medium-bound : number -all values less than ?medium-bound are considered :low
?high-bound : number -all values greater or equal ?high-bound are considered :high; 
All values in-between are considered :medium
")

;; score < 0.3 -> :low
;; between [0.3 : 0.75] -> :medium
;; score > 0.75 -> :high
(<- (customer-mapping-bounds 0.3 0.75)!)



(<--- (customerRating ?cust ?rating)
 "
TODO documentation
 ")

(<- (customerRating ?cust ?rating)
    ;; get data from customer to calcul the score
    (is ?nb-borrow (length (findAllRecordsFromCustomer ?cust)))
    (is ?nb-late (length (findAllLateRecordsFromCustomer ?cust)))
    (is ?nb-damage (length (findAllDamageRecordsFromCustomer ?cust)))

    ;; compute number of perfect returned book
    (is ?nb-normal (- ?nb-borrow (+ ?nb-late ?nb-damage)))
    ;; +1 / prefect returned  |  -2 / late  |  -5 / damage
    (is ?points (- ?nb-normal (+ (* ?nb-late 2) (* ?nb-damage 5))))
    ;; compute final score with average ratio
    (is ?ratio (abs (/ ?points ?nb-borrow)))

    ;; get mapping bounds to return from final score computed
    (customer-mapping ?ratio ?rating))
