(in-package :stock)


;;; =====================================
;;; BUSINESS RULES - FACTS
;;; =====================================

(<--- (baseDeliveryTime ?result)
 "
 Rule defining the default base delivery time.
 Arguments:
 ?result (output) <number> - the base time in minutes
 ")

(<- (baseDeliveryTime 1)!)


(<--- (copyPenaltyDuration ?book-state ?result)
 "
 Rule defining the penalty duration added for each existing copy in stock depending on their state.
 Arguments:
 ?book-state (input) <eBookCondtion> - the condition of the book copy
 ?result (output) <number> - the penalty duration per copy in minutes (defaults to 1)
 ")

(<- (copyPenaltyDuration :damage 1)!)
(<- (copyPenaltyDuration :perfect 2)!)

(<- (copyPenaltyDuration ?book-state 1)!) ;; default case


;;; =====================================
;;; BUSINESS RULES - RULES
;;; =====================================

(<--- (estimate-delivery-time ?book-ref ?result)
 "
 Rule for calculating the final estimated delivery time for a book 
 based on the number of copies already owned in the stock.
 Arguments:
 ?book-ref (input) <BookReference> - the book reference instance
 ?result (output) <number> - the final computed delivery time in minutes
 ")

(<- (estimate-delivery-time ?book-ref ?result)
    ;; get the base delivery time
    (baseDeliveryTime ?base-time)

    ;; compute the penalty time for each copy state
    (is ?penalty-duration (_computePenaltyDuration ?book-ref))

    ;; compute the final delivery time
    (is ?result (+ ?base-time ?penalty-duration))
    )
