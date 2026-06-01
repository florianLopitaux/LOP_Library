(in-package :workflow)

(setq excl::*warn-smp-usage* nil)  ;;; do not warn on use of deprecated macro without-scheduling



;;; Macro def-process


  "
defines a new process and registers it to the workflow engine

Parameters:
process-name - symbol representing the process name
events - list of the form (<variable-name> :type <event-class>)
body - forms using <variable-name> and invoke-asynch, wait-for-first, wait-for-all etc.

Example:
(def-process rejecting-process (event :type request-rejected-event)
  (inform-reject (get-username event)))
"


(defmacro def-process (process-name event-declaration &body body)
  (assert (has-type event-declaration 'list))
  (assert (= (length event-declaration) 3))
  (assert (equal (second event-declaration) :type))
  ;;; assert (third event-declaration) is subclass of workflow-event
  (let 
      ((event-var (first event-declaration))
       (event-type (third event-declaration))
       (process-var (gensym)))
    `(progn
       (register-trigger ',event-type ',process-name)
       (defmethod execute-process ((,process-var (eql ',process-name)) (,event-var ,event-type)) 
         ,@body))))





;;;; Workflow-Engine

(def-class workflow-engine ()
  ((triggers :initform nil :documentation "association list event-type -> process-name")
   (events :initform nil :documentation "list of events")
   (activities :initform nil :documentation "list of activities")
   (event-listeners :initform nil :documentation "association list event-name -> (test voucher)")
   ;;; deprecated:
   ;;;(workflows :initform nil :documentation "list of symbols representing workflow names")
   ;;;(workflow-triggers :initform nil :documentation "association list event-name -> workflow-name")
   )
  (:documentation "Central workflow engine")
  )


;;; Global variable for the central workflow engine. 
;;; Is re-assigned at every compilation 
(defparameter *workflow-engine*
    (make-instance 'workflow-engine)
  )




(defun register-trigger (event-type process-name &optional (workflow-engine *workflow-engine*))
  "
adds association symbol (representing workflow-event class) -> symbol (representing process name) to triggers of workflow-engine
"
  (pushnew (cons event-type process-name) (slot-value workflow-engine 'triggers) :test #'equal)
  ) 




(defun register-event-listener (event-class test voucher &optional (workflow-engine *workflow-engine*))
  "
registers association event-class -> (test voucher) with workflow-engine. 
If the event already has arrived the voucher is set to the event

Parameters:
event-class - symbol representing a class derived from workflow-event
test - a predicate (boolean returning function) with event as argument
voucher - a voucher which eventually will contain the event
workflow-engine - a workflow-engine

No return value specified
"
  (without-scheduling  ; atomic action not to be interleaved
    (loop for event in (get-events workflow-engine) 
        if (and (equal event event-class) (funcall test event)) do ; event has already arrived - should be a rare case
          (set-value event voucher)
          (return-from register-event-listener) ; if event has already arrived nothing needs to be registered
          )
    (pushnew (list event-class test voucher) (slot-value workflow-engine 'event-listeners) :test #'equal) ; new association event-class -> (test voucher)
    nil
    )
  )




(defgeneric execute-process (process-name event)
  (:documentation "
Executes busines process

Parameters:
process-name : Symbol - the name of the process
event : object derived from workflow-event

No return value
"
                  )
  )




(defun get-executing-activities (activity-class-name &optional (workflow-engine *workflow-engine*))
  "
returns all currently executing activities in the workflow-engine

Parameters:
activity-class-name : Symbol - the name of the activity subclass

returns: list of activity objects

Example:
(get-executing-activities 'sample-manual-activity)
"
    (loop for activity 
      in (get-activities workflow-engine) 
      if (and (typep activity activity-class-name) (equal :executing (get-status activity)))
      collect activity)
  )




;;;; Events


(def-class workflow-event ()
  ((id :initform (generate-id))
   )
  (:documentation "Base class for all events")
  )


(defmacro def-event (name direct-slots &rest options)
  `(def-class ,name (workflow-event) ,direct-slots ,@options)
  )
;;; TODO test options 




(defun handle-event (event &optional (workflow-engine *workflow-engine*))
  "
executes all workflows that are to be triggered by event
triggers all event-listeners

Parameters:
event - a workflow-event object
workflow-engine - a workflow-engine

No return value
"
  ;;; TODO ensure event is a workflow-event
  (without-scheduling  ; atomic section not to be interrupted
  (let* 
      ((event-name (class-name (class-of event)))
       (triggers (get-triggers workflow-engine))
       (process-names (assoc-all event-name triggers)) ; all processes that need to be executed
       (event-listeners-before (get-event-listeners workflow-engine))
       (event-listeners-after nil)
       )
    (pushnew event (slot-value workflow-engine 'events))
    (loop for process-name in process-names do 
          (without-scheduling
            (execute-process process-name event)))
    (loop for (listening-event test voucher) in event-listeners-before do
          (if (and (equal event-name listening-event) (funcall test event)) ; listener matches
              (set-value event voucher) ; set event to waiting voucher - waiting activities can now continue
            (push (list listening-event test voucher) event-listeners-after) ; matching event listeners are removed from list - others stay
            )
          )
    (set-event-listeners event-listeners-after workflow-engine)
    nil)))
;;; TODO: execute in parallel





(defun remove-event (event &optional (workflow-engine *workflow-engine*))
  "
Removes an event object from workflow-engine

Parameters:
event - a workflow-event object
workflow-engine - a workflow-engine

No return value
"
  (set-events  
   (remove event (get-events workflow-engine))
   workflow-engine))




(defun get-handled-events (event-class &optional (test (lambda (event) t)) (workflow-engine *workflow-engine*))
  "
returns all events that are handled by the workflow-engine

Parameters:
event-class : Symbol - the name of the event subclass (quoted)
&optional
test : Filter predicate with event object as parameter
workflow-engine : default value: *workflow-engine*

returns: list event objects that are handeled by workflow-engine and satisfy test

Example:
(get-handled-events 'customer-accepted-event '(lambda (event) (equal (get-username event) JohnDoe)))
"
  (select 
   (lambda (event) 
     (and      
      (has-type event event-class)
      (funcall test event)))
   (get-events workflow-engine)))






;;;; Activities


(def-class activity ()
  ((id :initform (generate-id))
   (voucher :initform (make-instance 'voucher))
   (status :initform :initial)
   )
  (:documentation "Base class for all activities")
  )





(def-class invoke-activity (activity)
  (method
   arguments
   )
  (:documentation "activity of invoking a function")
  )


(def-class manual-activity (activity)
  (
   )
  (:documentation "activity to be performed by humans")
  )



(defmethod initialize-instance :after ((activity activity) &key) 
  (push activity (slot-value *workflow-engine* 'activities))
  )


(defgeneric execute-activity (activity)
  (:documentation   "
executes activity. Must be implemented by subclasses
"
                  )
  )


(defmethod execute-activity :before ((activity activity))
  (set-status :executing activity)
  )





(defmethod execute-activity ((activity invoke-activity))
  (process-run-function
   (format nil "invoke-activity ~a" (get-id activity))
   #'(lambda () 
       (let* ((method (get-method activity))
              (arguments (get-arguments activity))  
              (voucher (get-voucher activity))
              (result (apply method arguments))
              )
         (set-value result voucher)
         (set-status :executed activity)
         )
       )
   )
  )


(defmethod execute-activity ((activity manual-activity))
  ;;; do nothing - must be executed externally
  )


(defmethod set-value (value (activity activity))
  "
sets value to the voucher of activity
Changes activity state to :executed
"
  (set-value value (get-voucher activity))
  (set-status :executed activity)
  value
  )

(defmethod get-value ((activity activity))
  "
sets value to the voucher of activity
Changes activity state to :executed
"
  (let ((result (get-value (get-voucher activity))))
    (set-status :executed activity)
    result
    )
  )


;;;; Invocation

(def-function invoke-synch (method &rest arguments)
  "
Synchronously invokes method with arguments and returns result.
Generates an invoke-activity
"
  (let ((activity (make-instance 'invoke-activity :method method :arguments arguments))
        )
    (execute-activity activity)
    (get-value (get-voucher activity))
    )
  )


(def-function invoke-asynch (method &rest arguments)
  "
Asynchronously invokes method with arguments and returns a voucher.
Generates an invoke-activity
"
  (let ((activity (make-instance 'invoke-activity :method method :arguments arguments))
        )
    (execute-activity activity)
    (get-voucher activity)
    )
  )



(def-function invoke-activity-asynch (activity)
  "
Asynchronously executes activity and returns a voucher
"
  (execute-activity activity)
  (get-voucher activity)
  )

(def-function invoke-activity-synch (activity)
  "
Synchronously executes activity and returns a voucher
"
  (execute-activity activity)
  (get-value (get-voucher activity))
  )


;;;; Joining

(defgeneric wait-for (condition) ; event or voucher or timer
  )


(def-function wait-for-first (&rest (vouchers :documentation "events or vouchers or timers")) 
  (:documentation "Waits for voucher values in parallel. As soon as one voucher has a value, this value is returned")
  (let ((result-voucher (make-instance 'voucher))
        )
    (mapcar (lambda (voucher)
              (process-run-function "wait-for-first" 
                                    (lambda () (set-value (get-value voucher) result-voucher))
                                    )
              )
      vouchers
      )
    ;;; the following code does not work although seemingly equivalent - a bug in loop?
    ;;;    (loop for voucher in vouchers do 
    ;;;          (process-run-function "wait-for-first" 
    ;;;                                #'(lambda () (set-value (get-value voucher) result-voucher))
    ;;;                                )
    ;;;          )
    (get-value result-voucher)
    )
  )


(def-function wait-for-all (&rest (vouchers :documentation "events or vouchers or timers"))
  (:documentation "Waits for all voucher values in parallel. Returns a list of all voucher values as soon as the last voucher has a value")
  (loop for voucher in vouchers collect 
        (get-value voucher)
        )
  )


;;;; vouchers

(def-class voucher ()
  ((queue :initform (make-instance 'queue))
   value)
  (:default-initargs nil :default-setters nil :default-getters nil) ; slots should not be accessed externally
  )


(defmethod get-value ((voucher voucher))
  "
returns the value of a voucher. 
Returns immediately if the value has already been computed. 
Waits until the value is computed, otherwise
returns the same value on multiple invocations
"
  (let ((queue (slot-value  voucher 'queue))
        )
    (if (queue-empty-p queue)
        (dequeue queue :wait t)
      (first (mp::queue-tail queue))
      )
    )
  )
  



(defmethod set-value (value (voucher voucher))
  "
sets the value of voucher so that it can be retrieved via get-value
"
 ; (setf (slot-value voucher 'value) value)
  (enqueue (slot-value voucher 'queue) value)
  )



(defmethod has-value ((voucher voucher))
  "
returns t if voucher already has a set value, nil otherwise
"
  (not (queue-empty-p (slot-value voucher 'queue)))
  )





(defmethod wait-for ((voucher voucher))
  "
waits until the voucher has been set a value
"
  (get-value voucher)
  )





(defun timer-voucher (&key (years 0) (months 0) (weeks 0) (days 0) (hours 0) (minutes 0) (seconds 0))
  (let ((voucher (make-instance 'voucher))
        )
    (incf days (* years 365))
    (incf days (* months 30))
    (incf days (* weeks 7))
    (incf hours (* days 24))
    (incf minutes (* hours 60))
    (incf seconds (* minutes 60))
    (process-run-function "Timer" #'(lambda () (sleep seconds) (set-value :timer-finished voucher)))
    voucher
    )
  )



(defun event-voucher (event-class &optional (test (lambda (event) t)) (workflow-engine *workflow-engine*))
  "
Returns a voucher that returns an event that satisfies conditions as soon as it has arrived.

Parameters:
event-class : Symbol representing an event class which must be the class of the event returned
&optional test : predicate with one parameter (event) to validate event object 

Returns
First event object of event-class that satisfies test
"
  (let ((voucher (make-instance 'voucher))
        )
    (register-event-listener event-class test voucher workflow-engine)
    voucher
    )
  )








;;;; auxiliary classes and functions


(defvar *id* 1)

(def-function generate-id ()
  (incf *id*)
  )





#|
;;; Deprecated:



;;; Macro def-workflow

(defmacro def-workflow (workflow parameters options &body body)
  "
defines a new workflow and registers it to the workflow engine

Parameters:
workflow - symbol representing the workflow name
parameters - list of parameters for workflow execution
options - property list of options. Possible properties:
          :event - symbol of Workflow-Event class that triggers the workflow execution (not quoted)
body - forms using invoke-*, etc.

Example:
(def-workflow sample-workflow (param-1)
  (:event sample-event) 
  (invoke-synch #'action-1 param-1))
"
  (let* ((events (get-all options :event))
         (event (gensym))
         (args (gensym))
         )
    `(progn
       (register-workflow ',workflow)
       (loop for ,event in ',events do
             (register-workflow-trigger ,event ',workflow)
             )
       (defmethod execute-workflow ((workflow (eql ',workflow)) ,args) 
         (let ,(loop for parameter in parameters 
                   for i from 0 to (1- (length parameters))
                   collect
                     `(,parameter (nth ,i ,args))
                     ) 
           ,@body
           )
         )
       )
    )
  )




(defun register-workflow (workflow-name &optional (workflow-engine *workflow-engine*))
  "
adds symbol workflow-name to list of workflows in workflow-engine
"
  (pushnew workflow-name (slot-value workflow-engine 'workflows))
  )


(defun register-workflow-trigger (event workflow &optional (workflow-engine *workflow-engine*))
  "
adds association symbol (representing workflow-event class) -> symbol (representing workflow) to workflow-triggers of workflow-engine
"
  (pushnew (cons event workflow) (slot-value workflow-engine 'workflow-triggers) :test #'equal)
  ) 



(defgeneric extract-workflow-arguments (workflow event)
  (:documentation "
extracts the arguments of workflow execution from an event. Must be implemented by workflow designers

Parameters:
workflow-name : symbol - name of the workflow
event : workflow-event - event object

Returns
List of arguments to be passed to workflow execution

Example:
(defmethod extract-workflow-arguments ((workflow-name (eql 'event-triggered-workflow)) (event sample-event))
  (list (get-id event))
  )
"
                  )
  )



(defgeneric execute-workflow (workflow arguments)
  (:documentation "
Executes workflow

Parameters:
workflow : Symbol - the name of the workflow
arguments : List - parameters for workflow execution

Returns:
workflow result
"
                  )
  )


(defun handle-event (event &optional (workflow-engine *workflow-engine*))
  "
executes all workflows that are to be triggered by event
triggers all event-listeners

Parameters:
event - a workflow-event object
"
  (without-scheduling  ; atomic section not to be interrupted
    (let* ((event-name (class-name (class-of event)))
           (workflow-triggers (get-workflow-triggers workflow-engine))
           (workflows (assoc-all event-name workflow-triggers)) ; all workflows that need to be executed
           (event-listeners-before (get-event-listeners workflow-engine))
           (event-listeners-after nil)
           )
      (pushnew event (slot-value workflow-engine 'events))
      (loop for workflow in workflows do ; all workflows that need to be executed
            (let ((activity (make-instance 'workflow-activity 
                              :workflow workflow 
                              :arguments (extract-workflow-arguments workflow event)
                              )
                            )
                  )
              (execute-activity activity)
              )
            )
      (loop for (listening-event test voucher) in event-listeners-before do
            (if (and (equal event-name listening-event) (funcall test event)) ; listener matches
                (set-value event voucher) ; set event to waiting voucher - waiting activities can now continue
              (push (list listening-event test voucher) event-listeners-after) ; matching event listeners are removed from list - others stay
              )
            )
      (set-event-listeners event-listeners-after workflow-engine)
      nil
      )
    )
  )

(def-class workflow-activity (activity)
  ((workflow   :documentation "symbol representing the workflow name")
   (arguments :documentation "list of arguments for workflow execution")
   )
  (:documentation "activity of executing an entire workflow")
  )




(def-function invoke-workflow-synch (
  (workflow :documentation "a symbol representing a workflow name (quoted)") 
  &rest 
  (arguments :documentation "arguments to workflow execution")
  )
  (:documentation "Synchronously executes a workflow and returns a voucher.
Generates a workflow-activity"
   :result-documentation "the result of workflow execution as soon as it is available"
   :examples "(invoke-workflow-synch 'sample-workflow 15)"
  )
  (let ((activity (make-instance 'workflow-activity :workflow workflow :arguments arguments)))
    (execute-activity activity)
    (get-value (get-voucher activity))
    )
  )

(def-function invoke-workflow-asynch (
  (workflow :documentation "a symbol representing a workflow name (quoted)") 
  &rest 
  (arguments :documentation "arguments to workflow execution")
  )
  (:documentation "Asynchronously executes a workflow and returns a voucher.
Generates a workflow-activity"
   :result-documentation "a voucher with the result"
   :examples "(invoke-workflow-asynch 'sample-workflow 15)"
  )
  (let ((activity (make-instance 'workflow-activity :workflow workflow :arguments arguments)))
    (execute-activity activity)
    (get-voucher activity)
    )
  )



(defmethod execute-activity ((activity workflow-activity))
  (process-run-function 
   (format nil "workflow-activity ~a" (get-id activity)) 
   (lambda ()
       (let* ((workflow (get-workflow activity))
              (arguments (get-arguments activity))  
              (voucher (get-voucher activity))
              (result (apply #'execute-workflow (list workflow arguments)))
              )
         (set-value result voucher)
         (set-status :executed activity)
         )
       )
   )
  )


|#
