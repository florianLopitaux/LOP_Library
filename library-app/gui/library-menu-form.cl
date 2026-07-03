;;; Code for the form named :library-menu-form of class library-menu-dialog.
;;; The inspector may add event-handler starter code here,
;;; and you may add other code for this form as well.
;;; The code for recreating the window is auto-generated into 
;;; the *.bil file having the same name as this *.cl file.

(in-package :common-graphics-user)

(defclass library-menu-dialog (dialog)
  ())


;;; =====================================
;;; ON CLICK FUNCTIONS
;;; =====================================

(defun library-menu-stock-btn-on-click (dialog widget)
  (declare (ignorable dialog widget))
  (format t "je click sur stock button")
  (make-library-stock-form)
  
  t) ;; end function

(defun library-menu-customer-btn-on-click (dialog widget)
  (declare (ignorable dialog widget))
  (print "je click sur customer button")
  (make-library-customer-form)
  
  t) ;; end function

(defun library-menu-borrowing-btn-on-click (dialog widget)
  (declare (ignorable dialog widget))
  (print "je click sur borrowing button")
  (make-library-borrow-form)
  
  t) ;; end function
