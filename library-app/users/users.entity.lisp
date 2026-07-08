(in-package :users)


;;; =====================================
;;; ENTITY CLASSES
;;; =====================================

(def-entity Customer ()
  (
    (name
      :type 'tFullName
      :documentation "First and last name of the customer")
    (address
      :type 'tAddress
      :documentation "full address as string")
    (email
      :type 'string
      :documentation "An email linked to the customer")
    (status
      :type 'eCustomerStatus
      :initform :active
      :documentation "Status to know if the customer is subscribe to the library")
    (role
      :type 'eCustomerRole
      :initform :normal
      :documentation "Role of a customer")
  )

  (:documentation "General customer of the library")
)


;;; ========================================
;;;  Method overrides from better_lang package oo
;;; ========================================

(defmethod oo:to-string-summary ((cust Customer))
  ;; method body
  (format nil "~A ~~ ~A ~A"
      (get-oid cust)
      (tFullName-first-name (get-name cust))
      (tFullName-last-name (get-name cust))
  )

) ;; end method

(defmethod oo:to-string-details ((cust Customer))
  ;; method body
  (format nil "~%Customer [~A] {~% - name: ~A~% - address: ~A~% - email: ~A~% - status: ~A~% - role: ~A~%}"
    (get-oid cust)
    (get-name cust)
    (get-address cust)
    (get-email cust)
    (get-status cust)
    (get-role cust)
  )

) ;; end method

(defmethod oo:from-string-summary ((target-class (eql 'Customer)) str)
  ;; method body
  (let* ((pos (cl:position #\~ str))
         (cust-oid (cl:parse-integer (cl:subseq str 0 pos))))
    
    (find-by-oid 'Customer cust-oid)
  )

) ;; end method
