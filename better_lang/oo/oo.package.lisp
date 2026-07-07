(in-package :common-lisp-user)



(defpackage :de.h-da.lop.lang.oo
  (:nicknames :oo)
  (:documentation "Object-Oriented programming language based on Common Lisp")
  (:use 
   :common-lisp 
   )
  (:export  
   ;;; object-oriented basics
   def-class make-instance initialize-instance  defgeneric defmethod
   call-next-method
   
   
   ;;; imperative programming; handling of variables
   let let* setf
   
   ;;; exception handling
   error
   
   ;;; method to override by entity to handle string serialization
   to-string-summary
   to-list-string-summary
   to-string-details
   to-list-string-details
   from-string-summary
   from-list-string-summary

   )
  )
