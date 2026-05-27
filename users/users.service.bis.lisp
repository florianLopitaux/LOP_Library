(in-package :users)


;;; =====================================
;;; SUBSCRIPTION FUNCTIONS
;;; =====================================

(def-function subscribe-customer (
    (customer :type Customer :documentation "The Customer instance"))
  
  ;; function body
  (set-status customer :active)
  
  ) ;; end function


(def-function unsubscribe-customer (
    (customer :type Customer :documentation "The Customer instance"))
  
  ;; function body
  (set-status customer :disable)

  ) ;; end function


(def-function apply-student-subscribe-reduc (
    (student :type Student :documentation "The Student instance")
    (amount :type number :documentation "The subscription amount to apply the reduction"))
  
  ;; function body
  (- amount (* amount (get-sub-reduc student)))

  ) ;; end function


(def-function apply-professor-subscribe-reduc (
    (professor :type Professor :documentation "The Professor instance")
    (amount :type number :documentation "The subscription amount to apply the reduction"))
  
  ;; function body
  (- amount (* amount (get-sub-reduc professor)))

  ) ;; end function

