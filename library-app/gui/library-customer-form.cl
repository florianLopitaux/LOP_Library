;;; Code for the form named :library-customer-form of class library-customer-dialog.
;;; The inspector may add event-handler starter code here,
;;; and you may add other code for this form as well.
;;; The code for recreating the window is auto-generated into 
;;; the *.bil file having the same name as this *.cl file.

(in-package :common-graphics-user)

(defclass library-customer-dialog (dialog)
  ())


(defun fillCustomerDropdown (dialog)
  ;; function body
  (let* (
    (customer-dropdown (find-component :customer-dropdown dialog))
    (customers (bis:find-all 'users:Customer))
    )
  
  (setf (range customer-dropdown) (functional:add "No Customer Selected" (users:customerListToStringFormat customers)))
  )

) ;; end function

(defun extractRecordsCount (records)
  ;; function body
  (cond
    ((equal records nil) 0)
    (functional:else (length records))
  )

) ;; end function


(defmethod initialize-instance :after ((dialog library-customer-dialog) &key)
  ;; function body
  (fillCustomerDropdown dialog)

) ;; end function


(defun customer-details-on-change (widget new-value old-value)
  ;; function body
  (declare (ignorable widget new-value old-value))
  (let* ((dialog (parent widget))
    (rating-field (find-component :rating-field dialog))
    (borrow-count-field (find-component :borrow-field dialog))
    (late-count-field (find-component :late-field dialog))
    (damage-count-field (find-component :damage-field dialog))
    (history-field (find-component :history-field dialog))
    )
  
  (cond
    ((equal new-value "No Customer Selected") nil)
    (functional:else
      (let ((customer (users:customerFromStringFormat new-value)))
      
      (setf (value rating-field) (borrowing-system:getCustomerRating customer))
      (setf (value borrow-count-field) (extractRecordsCount (borrowing-system:findAllRecordsFromCustomer customer)))
      (setf (value late-count-field) (extractRecordsCount (borrowing-system:findAllLateRecordsFromCustomer customer)))
      (setf (value damage-count-field) (extractRecordsCount (borrowing-system:findAllDamageRecordsFromCustomer customer)))
      (setf (value history-field) (borrowing-system:toHistoryStringFormat (borrowing-system:findAllRecordsFromCustomer customer)))
      )
    )
  ))
t) ;; end function


(defun customer-role-on-change (widget new-value old-value)
  ;; function body
  (declare (ignorable widget new-value old-value))
  (let* ((dialog (parent widget))
    (price-field (find-component :price-field dialog))
    )
  
  (setf (value price-field) (users:applyRoleDiscount new-value 20))
  )

t) ;; end function

(defun customer-register-button-on-click (dialog widget)
  ;; function body
  (declare (ignorable dialog widget))
  (let* (
    (first-name (value (find-component :first-name-field dialog)))
    (last-name (value (find-component :last-name-field dialog)))
    (email (value (find-component :email-field dialog)))
    (role (value (find-component :role-dropdown dialog)))
    (street (value (find-component :street-field dialog)))
    (zip (value (find-component :zip-field dialog)))
    (city (value (find-component :city-field dialog)))
    (country (value (find-component :country-field dialog)))
    )
  
  (cond
    ((= (length first-name) 0) (format t "~%[ERROR] The first-name of the new customer is required !"))
    ((= (length last-name) 0) (format t "~%[ERROR] The last-name of the new customer is required !"))
    (functional:else
      (format t "~%[INFO] New Customer created : ~A"
        (users:createCustomer
          (users:make-tFullName :first-name first-name :last-name last-name)
          role
          :address (users:make-tAddress :street street :zip zip :city city :country country)
          :email email
        ))
      
      (fillCustomerDropdown dialog) ;; update the dropdown to add the created customer
    )
  ))

t) ;; end function
