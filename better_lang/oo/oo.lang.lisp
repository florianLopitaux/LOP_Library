(cl:in-package :de.h-da.lop.lang.oo)

;;;;<macro def-class> macro definition and auxiliary functions

(defparameter *default-options*  '((:default-initargs . t) (:default-accessors . nil) (:default-getters . t) (:default-setters . t) (:persistent . nil) (:all-indexed . nil)))

(defmacro def-class (name direct-superclasses direct-slots &rest options-list)
  "
Extends the defclass macro. Accepts all forms of defclass.

Extended class options - if provided and non nil:
- :default-initargs (default t) provides :initarg options for all slots, e.g., for slot name --> :initarg :name
- :default-accessors provides :accessor options for all slots, e.g., for slot name --> :accessor name
- :default-getters (default t) provides :reader options for all slots, e.g., for slot name --> :reader get-name
- :default-setters (default t) provides :writer options for all slots, e.g., for slot name --> :writer set-name

- :all-indexed (requires allegro-cache only relevant if (:metaclass persistent-class) is specified) provides (:index :any) options for all slots
"
  ; TODO cleaner: allegro-cache specific options in separate macro
  (let* ((options (first options-list)) ; options list is first element of rest parameter - nil if no options specified
         (specified-default-generation-options (extract-default-generation-options options))
         (slot-specifiers (generate-all-slots-options direct-slots specified-default-generation-options))
         (standard-options (remove-default-generation-options options))
         (standard-options-list (if standard-options (list standard-options) nil)) ; list necessary for splicing options in backquote expression
         )
    `(defclass ,name ,direct-superclasses ,slot-specifiers ,@standard-options-list)
    )
  ) 




(defun remove-default-generation-options (options)
  (loop for (default-option . nil) in *default-options* do
        (remf options default-option ) ; removes the property with the default option from the property list
        )
  options
  )



(defun extract-default-generation-options (options)
  (loop for (default-option . default) in *default-options* 
      if (let ((value (getf options default-option :not-specified))) ; value specified in options list
           (if (equal :not-specified value)
               default
             value
             )
           )
      collect default-option
        )
  )



(defun generate-all-slots-options (slots options)
  (loop for slot in slots collect 
        (generate-slot-options slot options)
        )
  )

(defun generate-slot-options (slot options)
  (let* ((slot-specifier (if (listp slot) slot (list slot)))
         (slot-name (first slot-specifier))
         )
    (loop for option in options do
          (setf slot-specifier (append slot-specifier (generate-slot-option slot-name option)))
          )
    slot-specifier
    )
  )

(defmethod generate-slot-option (slot-name (option (eql :default-initargs)))
  (list :initarg (intern (symbol-name slot-name) "keyword")) ; e.g., name --> :initarg :name
  )

(defmethod generate-slot-option (slot-name (option (eql :default-accessors)))
  (list :accessor slot-name) ; e.g., name --> :accessor name
  )

(defmethod generate-slot-option (slot-name (option (eql :default-getters)))
  (list :reader (intern (concatenate 'string "get-" (symbol-name slot-name)))) ; e.g., name --> :reader get-name
  )

(defmethod generate-slot-option (slot-name (option (eql :default-setters)))
  (list :writer (intern (concatenate 'string "set-" (symbol-name slot-name)))) ; e.g., name --> :reader set-name
  )



(defmethod generate-slot-option (slot-name (option (eql :all-indexed)))
  (declare (ignore slot-name))
  (list :index :any) 
  )


