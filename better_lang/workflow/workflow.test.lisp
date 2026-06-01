(in-package :de.h-da.lop.lang.lop-test)
                         


(def-test voucher-test
    (let ((voucher (make-instance 'voucher)))
      (assert-equal nil (has-value voucher))
      (set-value :hello voucher)
      (assert-equal t (has-value voucher))
      (assert-equal :hello (get-value voucher))
      (assert-equal :hello (get-value voucher))
      )
  )


(def-event sample-event1
    (slot))

(def-event sample-event2
    (slot))


(def-process sample-process (event :type sample-event1)
  (print "DONE"))



(def-test process-test
    (let* 
        ((e1 (make-instance 'sample-event1 :slot 42))
         e2)
      (handle-event e1)))

(def-class test-event (workflow::workflow-event)
  (input
   )
  (:default-initargs t :default-getters t :default-setters t)
  )


(def-test event-voucher-test
    (let*
        ((v (event-voucher 'sample-event2)))
      (assert-false (has-value v))
      (handle-event (make-instance 'sample-event2 :slot 10))
      (assert-true (has-value v))
      (assert-equal 10 (get-slot (get-value v)))))


(def-test invoke-synch-test
    (let* ((result (invoke-synch #'identity :invoke-synch))
           )
      (assert-equal :invoke-synch result)
      )
  )


(def-test invoke-asynch-test
    (let* ((result (invoke-asynch #'identity :invoke-asynch))
           )
      (assert-equal :invoke-asynch (get-value result))
      )
  )





(def-test wait-for-first-test
    (let ((voucher1 (make-instance 'voucher))
          (voucher2 (make-instance 'voucher))
          )
      (set-value :value voucher2)
      (wait-for-first voucher1 voucher2)
      (assert-true t)  ; check whether this code is reached
      )
  )

(def-test wait-for-all-test
    (let ((voucher1 (make-instance 'voucher))
          (voucher2 (make-instance 'voucher))
          )
      (set-value :value voucher2)
      (set-value :value voucher1)
      (wait-for-all voucher1 voucher2)
      (assert-true t)  ; check whether this code is reached
      )
  )


(def-class test-event2 (workflow::workflow-event)
  (input
   )
  (:default-initargs t :default-getters t :default-setters t)
  )



(def-test loop-queue-test
    (let* ((q1 (make-instance 'mp:queue))
           (q2 (make-instance 'mp:queue))
           (queues (list q1 q2))
           result
           )
      (loop for queue in queues do
            (mp:enqueue queue :value)
            )
      (setf result (loop for queue in queues collect
            (mp:dequeue queue :wait t)
                         )
        )
      (assert-equal '(:value :value) result)
      )
  )


(def-event contract-signed-event
    (contract-id)
  )



