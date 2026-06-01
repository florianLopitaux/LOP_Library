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
   


   )
  )

