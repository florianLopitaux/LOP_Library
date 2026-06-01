(in-package :common-lisp-user)

(eval-when (compile load) 
  (require :acache "acache-4.0.1.fasl"))

(defpackage :de.h-da.lop.lang.bis
  (:nicknames :bis)
  (:documentation "DSLs for business information systems")
  (:use 
   :common-lisp 
   :db.allegrocache :db.allegrocache.utils
   :functional
   :oo
   :rule
   )
  (:export  
   ;;; components
   def-component
   
   ;;; application data types
   def-data-type def-enum-type def-struct
   
   ;;; entities
   def-entity get-oid find-by-oid find-all
   delete-instance
   
   ;;; queries
   query query-distinct
   is
   
   ;;; transaction handling
   commit rollback
   
   ;;; database
   open-file-database close-­database

   )
  )

