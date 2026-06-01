(in-package :common-lisp-user)

(eval-when (compile load) (require :process)) 
(setq excl::*warn-smp-usage* nil)  ;;; do not warn on use of deprecated macro without-scheduling




(defpackage :de.h-da.lop.lang.workflow
  (:nicknames :workflow)
  (:documentation "DSL for business processes and workflows")
  (:use 
   :common-lisp
   :multiprocessing
   :functional
   :oo
   )
  (:export  
   ;;; processes
   def-process
   
   
   
   ;;; Events
   def-event
   handle-event
   remove-event
   get-handled-events
   
   ;;; activities
   activity workflow-activity invoke-activity manual-activity
   execute-activity  
   get-executing-activities
   
   ;;; invocation
   invoke-synch invoke-asynch
   invoke-workflow-synch invoke-workflow-asynch
   invoke-activity-synch invoke-activity-asynch 
   
   ;;; Joining
   wait-for wait-for-first wait-for-all
   
   ;;; Vouchers
   voucher 
   get-value set-value has-value wait-for
   timer-voucher event-voucher
   
   
   ;;; workflow-engine
   get-activities

   )
  )

