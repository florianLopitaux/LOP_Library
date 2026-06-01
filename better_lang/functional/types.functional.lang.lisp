(in-package :de.h-da.lop.lang.functional)

;;; data  type predicates

(def-function is-number (item)
  (:documentation "checks whether an item is a number or not (cl:numberp)"
                  :examples "
(is-number 3) --> true
(is-number 3.14) --> true
(is-number '(1 2 3) --> false
")
  (numberp item)
  )

(def-function is-list (item)
  (:documentation "
checks whether an item is a list or not (cl:listp)
"
                  :examples "
(is-list '(1 2 3) --> true
(is-list 3) --> false
")
  (listp item)
  )

(def-function is-atom (item)
  (:documentation "
checks whether an item is an atom or not (cl:atom)
"
                  :examples "
(is-atom 3) --> true
(is-atom '(1 2 3) --> false
")
  (atom item)
  )

(def-function has-type (object type-specifier)
  (:documentation "
Returns true  if object is of the type  specified by type-specifier; otherwise, returns false. "
  )
  (typep object type-specifier)
  )
