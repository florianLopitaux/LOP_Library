(in-package :common-lisp-user)

(defpackage :de.h-da.lop.lang.functional
  (:nicknames :functional)
  (:documentation "Functional programming language based on Common Lisp")
  (:use 
   :common-lisp
   )
  (:export  
   ;;; data types
   number integer float string
   
   ;;; boolean constants
   true false 
   t nil
   else otherwise
   
   ;;; data type predicates
   is-number is-list is-atom type-of has-type
   
   ;;; equality predicates
   equal eql
   
   ;;; boolean functions
   and or not 
   
   ;;; function basics
   def-function
   lambda funcall apply
   &rest &key &optional
   
   ;;; list processing
   list add append first rest is-empty length member reverse  remove
   second third 
   collect select detect inject reduce
   sort
   
   ;;; property list processing
   get-all
   
   ;;; assoc list processing
   assoc-all
   
   ;;; math
   
   + - * / 
   = < <= > >=  
   string= string/= string< string> string<= string>= 
   char= char/= char< char> char<= char>=
   mod rem max min abs expt floor ceiling truncate round
   is-even is-odd
   
   ;;; string utilities
   starts-with
   
   ;;; control structures
   if cond case
   dotimes loop for do while until always never thereis from to upto downfrom downto collect append into count sum maximize minimize when unless with as  in on being 
   progn   
   
      
   ;;; input / output
   print format
   
   
   ;;; utils
   random

   
   ;;; package handling
   in-package
   
   
   ;;; macros
   defmacro
   macroexpand
   macroexpand-1

   )
  )

