(in-package :de.h-da.lop.lang.lop-test)


;;;; data types

(cl:defun is-positive (n)
  (> n 0)
  )

(def-data-type positive-number integer is-positive
  "positive numbers excluding 0"
  )


(def-test def-data-type-test
  (assert-true (typep 3 'positive-number))
  (assert-false (typep -3 'positive-number))
  (assert-false (typep "2" 'positive-number))
  )



(def-enum-type customer-status (active passive) 
  "customer status"
  )


(def-test def-enum-type-test  
  (assert-true (typep 'active 'customer-status))
  (assert-true (typep 'passive 'customer-status))
  (assert-false (typep 'something 'customer-status))
  )



(def-struct address street number zip city country)



(def-test def-struct-test
    (let ((addr (make-address :street "Banool St" :number 8 :zip 2500 :city "Wollongong" :country "Australia")))
      (assert-equal "Wollongong" (address-city addr))
      (setf (address-city addr) "Sydney")
      (assert-equal "Sydney" (address-city addr))
      (assert-equal (write-to-string addr) (write-to-string (debug.ac:decode-object (make-address) (debug.ac:encode-object addr))))))
                 
                 
                 
;;;; entities

(def-entity test-entity ()
  ((attribute-1 :type 'string)
   (attribute-2 :type 'integer)
   attribute-3))




#|
(make-instance 'test-entity :attribute-3 (make-instance 'address :street "myStreet"))
|#


(def-test def-entity-test
    (let 
        (instance-1
         instance-2
         )
      (setf instance-1 (make-instance 'test-entity :attribute-3 (make-address :street "Hill St")))
      (set-attribute-1  "Hello"  instance-1)
      (set-attribute-2 42 instance-1)
      (setf instance-2 (find-by-oid 'test-entity (get-oid instance-1)))
      (assert-equal "Hello" (get-attribute-1 instance-1))
      (assert-equal 42 (get-attribute-2 instance-1))
      (assert-equal "Hill St" (address-street (get-attribute-3 instance-1)))
      )
  )

(def-test find-all-test
    (let 
        (instances-before
         instances-after
         )
      (setf instances-before (find-all 'test-entity))
      (make-instance 'test-entity)
      (make-instance 'test-entity)
      (make-instance 'test-entity)
      (setf instances-after (find-all 'test-entity))
      (assert-equal 3 (- (length instances-after) (length instances-before)))
      )
  )



;;; queries


(def-test query-entities-test
    (let 
        (instances-before
         instances-after
         )
      (setf instances-before (query ?e (db test-entity ?e attribute-1 "Hello")))
      (make-instance 'test-entity :attribute-1 "Hello" :attribute-2 1)
      (make-instance 'test-entity :attribute-1 "Hello" :attribute-2 2)
      (make-instance 'test-entity :attribute-1 "World")
      (make-instance 'test-entity)
      (setf instances-after (query ?e (db test-entity ?e attribute-1 "Hello")))
      (assert-equal 2 (- (length instances-after) (length instances-before)))
      )
  )


