(in-package :payment-system)


;;; =====================================
;;; BUSINESS RULES - FACTS
;;; =====================================

(<--- (priceFromTransactionReference ?ref ?result)
 "
 Rule for determining the base price based on the type of transaction.
 Arguments:
 ?ref (input) <eTransactionReference> - the transaction reference identifier (e.g., :subscription, :borrow-book)
 ?result (output) <number> - the associated base price in Euros, defaults to 0 if unknown
 ")

(<- (priceFromTransactionReference :subscription 20)!)
(<- (priceFromTransactionReference :borrow-book 5)!)
(<- (priceFromTransactionReference :penalty-late-return 5)!)
(<- (priceFromTransactionReference :penalty-book-damaged 10)!)

(<- (priceFromTransactionReference ?ref 0)!) ;; default case


(<--- (custRoleCoefficient ?role ?result)
 "
 Rule for mapping a customer role to its corresponding pricing coefficient.
 Arguments:
 ?role (input) <eCustomerRole> - the customer role identifier (e.g., :normal, :student, :professor)
 ?result (output) <number> - the multiplier applied to the base price, defaults to 1
 ")

(<- (custRoleCoefficient :normal 1)!)
(<- (custRoleCoefficient :student 0.2)!)
(<- (custRoleCoefficient :professor 0.5)!)

(<- (custRoleCoefficient ?role 1)!) ;; default case


(<--- (custRatingCoefficient ?rating ?result)
 "
 Rule for mapping a customer rating category to its corresponding risk/reward coefficient.
 Arguments:
 ?rating (input) <eCustomerRating> - the customer rating category (:low, :medium, or :high)
 ?result (output) <number> - the multiplier applied to the price, defaults to 1
 ")

(<- (custRatingCoefficient :low 1.2)!)
(<- (custRatingCoefficient :medium 1)!)
(<- (custRatingCoefficient :high 0.9)!)

(<- (custRatingCoefficient ?rating 1)!) ;; default case


;;; =====================================
;;; BUSINESS RULES - RULES
;;; =====================================

(<--- (computeSubscriptionPrice ?role ?result)
 "
 Rule for calculating the final pricefor a subscription  by applying role coefficients to the base price.
 Use this rule to estimate subscription price instead of 'computePrice' because in this case we still did not create the customer yet.
 Arguments:
 ?role (input) <eCustomerRole> - the role of the future customer
 ?result (output) <number> - the final computed price in Euros
 ")

(<- (computeSubscriptionPrice ?role ?result)
    ;; get base price for a subscription
    (priceFromTransactionReference :subscription ?base-price)

    ;; get discount depending on customer role (student, professor)
    (custRoleCoefficient ?role ?role-coef)

    ;; compute final price
    (is ?result (* ?base-price ?role-coef))
    )


(<--- (computePrice ?cust ?ref ?result)
 "
 Rule for calculating the final transaction price by applying role and rating coefficients to the base price.
 Arguments:
 ?cust (input) <Customer> - the customer instance performing the transaction
 ?ref (input) <eTransactionReference> - the transaction reference identifier
 ?result (output) <number> - the final computed price in Euros
 ")

(<- (computePrice ?cust ?ref ?result)
    ;; get base price depending on transaction reference
    (priceFromTransactionReference ?ref ?base-price)

    ;; get discount depending on customer role (student, professor)
    (is ?cust-role (get-role ?cust))
    (custRoleCoefficient ?cust-role ?role-coef)

    ;; get coefficient depending on customer rating (:low, :medium, :high)
    (is ?cust-rating (getCustomerRating ?cust))
    (custRatingCoefficient ?cust-rating ?rating-coef)

    ;; compute final price
    (is ?result (* (* ?base-price ?role-coef) ?rating-coef))
    )
