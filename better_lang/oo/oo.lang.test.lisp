(in-package :de.h-da.lop.lang.lop-test)

;;; test macro def-class 

(cl:defclass defined-via-defclass ()
  (slot0 )
  (:documentation "defined via defclass")
  )




(def-class defined-via-def-class (defined-via-defclass)
  (slot1
   (slot2 :type string)
   )
  (:documentation "defined via def-class"
    :default-initargs t
    :default-accessors t
    :default-setters t
    :default-getters t
    )
  )


(def-test def-class-test
  (let ((instance (make-instance 'defined-via-def-class :slot1 42 :slot2 "hello")))
    (assert-equal 42 (get-slot1 instance))
    (assert-equal "hello" (get-slot2 instance))
    (set-slot1 "world" instance)
    (assert-equal "world" (get-slot1 instance))
    )  
  )


(def-test extract-default-generation-options-test
  (assert-equal 
   '(:default-initargs :default-setters) 
   (oo::extract-default-generation-options '(:documentation "doc" :default-initargs t :default-accessors nil :default-getters nil)))  
  )

(def-test remove-default-generation-options-test
  (assert-equal
   '(:documentation "doc")
   (oo::remove-default-generation-options '(:documentation "doc" :default-initargs t :default-accessors nil :default-setters t))            
   )  
  )

