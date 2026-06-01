(in-package :de.h-da.lop.lang.bis)


;;;; components




(defmacro def-component (name &body code)
  "
Defines an application component
name - a symbol as unique name of the component

Keywords:
:nicknames - alternatives for component name
:documentation - string describing the purpose of the component
:languages - languages to be used, e.g., :functional :oo :bis :rule :workflow :test
:import - dependent components to be used
:export - names (symbols) of functions and classes to be exported, i.e., visible to other components
"
  (let* ((nicknames nil)
         (documentation nil)
         (languages nil)
         (imports nil)
         (use nil)
         (export nil))
    (loop for declaration in code collect
          (case (first declaration)
            (:nicknames (setf nicknames (list declaration)))   ;;; wrap in list for splicing ,@
            (:documentation (setf documentation (list declaration))) ;;; wrap in list for splicing ,@
            (:languages (setf languages (rest declaration)))   ;;; omit keyword :languages since defpackage has different keyword            
            (:import (setf imports (rest declaration)))         ;;; omit keyword :import since defpackage has different keyword
            (:export (setf export (list declaration)))         ;;; wrap in list for splicing ,@
            (otherwise (error "wrong declaration"))
            )
          )

    (if (or languages imports)   ;;; one of both not nil
        (setf use (list (cons :use (append languages imports)))))  ;;; wrap in list for splicing ,@
    `(progn
       (in-package :common-lisp-user)
       (defpackage ,name
         ,@nicknames
         ,@documentation
         ,@use
         ,@export
         )
       )
    )
  )

           


;;;; data types

(defmacro def-data-type (name base-type predicate &optional documentation)
  "
Defines an application datatype based on base-type with predicate as restriction

Example:
(def-data-type positive-number integer is-positive)
"
  
  `(deftype ,name ()
     ,documentation
     '(and ,base-type (satisfies ,predicate))  
     )
  )




(defmacro def-enum-type (name values &optional documentation)
    "
Defines an enumeration datatype with a specified set of values

Example:
(def-enum-type status (active passive) \"customer status\")
"
  `(deftype ,name ()
     ,documentation
     '(member ,@values)
     )
  )



(defmacro def-struct (name-and-options &rest slot-descriptions)
    "
Defines structured datatype using cl:defstruct and allows it to be persisted in the database

Example:
(def-struct address (street zip city country))
(make-address :street \"Wall St\" :city \"New York\" :country \"USA\") 
"  
  (let*
      ((struct (if (listp name-and-options) (first name-and-options) name-and-options))
       (object (gensym))
       (value (gensym)))
    `(progn
       (defstruct ,name-and-options ,@slot-descriptions)
       (defmethod encode-object ((,object ,struct)) (write-to-string ,object))
       (defmethod decode-object ((,object ,struct) ,value) (let ((,object (read-from-string ,value))) ,object))
       (quote ,struct))))




;;;; Entities



(def-class abstract-entity ()
  ()
  (:documentation "base class for all entity types"
                  :metaclass persistent-class
                  :default-initargs
                  :default-getters
                  :default-setters
                  :all-indexed
                  )
  )


;;; return :unbound and do not throw an exception if unbound entity attributes are accessed
(defmethod slot-unbound (class (instance abstract-entity) attribute)
  (declare (ignore class))
  (declare (ignore attribute))
             :unbound)


(defmacro def-entity (name  superclasses slots &rest options)
  "
Defines a persistent class with initargs, getters and setters for all slots; all slots indexed
Also defines a default print-object method showing oid and all slot values

Parameters:
name - name of the class
superclasses - list of superclasses
slots - list of: slot name or list with slot name and slot parameters

Example:
(def-entity customer () (name address))

"

  `(progn
     (def-class ;; generate class definition
         ,name 
         ,(append  superclasses (list 'abstract-entity))   ;;; add abstract-entity as last super class in order to avoid circularity in the local precedence relations when subclassing entities
       ,slots 
       ,(append 
         '(:metaclass persistent-class :default-initargs t :default-getters t :default-setters t :all-indexed t) 
         (first options))
       )     
     (defprinter ,name ,@(slotnames slots)) ;; generate default print-object method       
     (find-class (quote ,name))  ; return the class - not the print-object method - for better readability
     )
  )


(def-function slotnames (slots)
  (loop for slot in slots collect
        (if (listp slot)
            (first slot)
          slot
          )
        )
  )



(defgeneric get-oid (entity)
  (:documentation "
gets the automatically created id of an entity object

Parameter:
entity - instance of a subclass of abstract-entity
"))


(defmethod get-oid ((entity abstract-entity))
  (db-object-oid entity))



(def-function find-by-oid ((class-name :documentation "quoted name of the entity class")
                           (id :documentation "value of unique identifier"))
  (:documentation "
Returns an entity instance of the given class and subclasses with the given id if such an entity is found in the current database
nil otherwise
")
  (oid-to-object class-name id))



(def-function find-all ((class-name :documentation "quoted name of the entity class"))
  (:documentation "
Returns a list of entity instances of the given class and subclasses found in the current database
")
  (let ((result nil))
    (doclass* (o class-name)
              (push o result))
    result))



