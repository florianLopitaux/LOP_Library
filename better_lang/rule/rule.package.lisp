(in-package :common-lisp-user)

(eval-when (compile load) 
  (require :acache "acache-4.0.1.fasl")
  (require :prolog)
  (require :pcache))

(defpackage :de.h-da.lop.lang.rule
  (:nicknames :rule)
  (:documentation "Rule-based logic programming language based on Prolog and Common Lisp")
  (:use 
   :common-lisp 
   :functional
   :prolog
   ; :triple-store   
   )
  (:shadow select true)
  (:export  
   <- <-- <---
   query query-distinct prove
   ?- 
   ! fail
   and or not = bagof setof
   lisp lisp* lisp! lisp*! lispp lispp* lispp! lispp*! is
   db
   leash unleash
   )
  )

