(in-package :users)


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

;; score < 1.5 -> :low
;; between [1.5 : 2.5] -> :medium
;; score > 2.5 -> :high
(<- (customer-mapping-bounds 0.3 0.75)!)


(<---(rating ?category ?value ?rating)
"
Fact for specifying rating values
Arguments:
?category : atom –rating category, e.g., :occupation
?value  -attribute value, e.g., :manual-physical
?rating : number -rating if ?attribute has ?value
")

(<- (rating role :prof 0.2)!)

(<- (rating borrowedBook :perfect 1)!)
(<- (rating borrowedBook :late -2)!)
(<- (rating borrowedBook :damage -5)!)

(<- (rating ?category ?value 0)!)


(<--- (customer-rating ?cust ?borrow-books ?late-books ?damage-books ?rating)
 "
TODO documentation
 ")

(<- (customer-rating ?cust ?borrow-books ?late-books ?damage-books ?rating)    
    ;; get score for customer role
    (rating role (get-role ?cust) ?bonus-role)
    ;; compute number of perfect returned book
    (is ?perfect-books (- ?borrow-books (+ ?late-books ?damage-books)))
    ;; +1 / prefect returned  |  -2 / late  |  -5 / damage
    (is ?points (- ?perfect-books (+ (* ?late-books 2) (* ?damage-books 5))))
    ;; compute ratio
    (is ?ratio (/ ?points ?borrow-books))
    ;; final score
    (is ?score (+ ?bonus-role ?ratio))
    ;; get mapping bounds (from final score)
    (customer-mapping ?score ?rating))
