(in-package :users)


;;; =====================================
;;; BUSINESS RULES
;;; =====================================

(<--- (discount ?role ?percentage)
 "
TODO documentation
 ")

(<- (discount :normal 1)!) ;; no discount for normal customer
(<- (discount :student 0.2)!) ;; 80% discount for student
(<- (discount :professor 0.5)!) ;; 50% discount for student


(<--- (customerRoleDiscount ?base-amount ?cust-role ?result)
 "
TODO documentation
 ")

(<- (customerRoleDiscount ?base-amount ?cust-role ?result)
    (discount ?cust-role ?percentage)
    (is ?result (* ?base-amount ?percentage))
    )
