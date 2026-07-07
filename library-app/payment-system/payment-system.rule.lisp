(in-package :payment-system)


;;; =====================================
;;; BUSINESS RULES
;;; =====================================

(<--- (priceFromTransactionReference ?ref ?result)
 "
TODO documentation
 ")

(<- (priceFromTransactionReference :subscription 20)!)
(<- (priceFromTransactionReference :borrow-book 5)!)
(<- (priceFromTransactionReference :penalty-late-return 5)!)
(<- (priceFromTransactionReference :penalty-book-damaged 10)!)

(<- (priceFromTransactionReference ?ref 0)!) ;; default case


(<--- (custRoleCoefficient ?role ?result)
 "
TODO documentation
 ")

(<- (custRoleCoefficient :normal 1)!)
(<- (custRoleCoefficient :student 0.2)!)
(<- (custRoleCoefficient :professor 0.5)!)

(<- (custRoleCoefficient ?role 1)!) ;; default case


(<--- (custRatingCoefficient ?rating ?result)
 "
TODO documentation
 ")

(<- (custRatingCoefficient :low 1.2)!)
(<- (custRatingCoefficient :medium 1)!)
(<- (custRatingCoefficient :high 0.9)!)

(<- (custRatingCoefficient ?rating 1)!) ;; default case


(<--- (computePrice ?cust ?ref ?result)
 "
TODO documentation
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
