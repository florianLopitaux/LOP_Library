(in-package :de.h-da.lop.lang.functional)

;;;; sequence primitives


(def-function is-empty ((list :type sequence))
  (:documentation "
returns true if list is empty
false, otherwise"
   :examples "
(is-empty '()) --> true
(is-empty '(1 2 3)) --> false"
  )
  (if list
    false
    true
   )
)


(def-function add (e (list :type sequence))
  (:documentation "
adds e as first element of the list (cons)
"
                  :examples "
(add 1 '(2 3)) --> (1 2 3)
"
)
  (cons e list)
  )




;;;;<Smalltalk-style iteration functions> 



(def-function collect ((transformer :documentation "transformation function") (list :type sequence))
  (:documentation 
"
Returns a new list constructed by gathering the results of evaluating the function transformer with
each element of the list.
"
   :pre "transformer must have one argument which is applicable to all elements of list"
   :result-type sequence
   :examples
"
(collect 'is-even '(1 2 3)) --> (nil t nil)
"
)
  (loop for e in list collect (funcall transformer e))
;;;  alternative implementation: 
;;;  (mapcar transformer list)
  )



;;;(defun collect-if (list condition transformer)
;;;  "
;;;Returns a new list constructed by gathering the results of evaluating the function transformer with
;;;each element of the list - if evaluating the function condition with the respective element evaluates to t
;;;"
;;;  (mapcan
;;;      (lambda (element) (and (funcall condition element) (list (funcall transformer element))))
;;;    ; if condition evaluates to true then the evaluation of transformer is collected - mapcan removes surrounding list
;;;    ; otherwise, #'and evaluates to nil and mapcan collects nothing
;;;    list 
;;;    )
;;;  )


(def-function select ((condition :documentation "search function") (list :type sequence))
  (:documentation
"
Returns a new list containing those elements for which the function condition with the respective element evaluates to true
"
   :pre "condition must have one parameter, be applicable to all elements of list and return a boolean value"
   :return-type sequence
   :examples
   "
(select 'is-even '(1 2 3 4)) --> (2 4)
"
   )
  (loop for e in list if (funcall condition e) collect e)
;;;  alternative implementation:
;;;  (mapcan
;;;      (lambda (element) (and (funcall condition element) (list element)))
;;;    ; if condition evaluates to true then the evaluation of transformer is collected - mapcan removes surrounding list
;;;    ; otherwise, #'and evaluates to nil and mapcan collects nothing
;;;    list 
;;;    )
  )

(def-function detect ((condition :documentation "search function") (list :type sequence))
  (:documentation
  "
Returns the first element of list which causes condition to evaluate to t when used as the argument to the evaluation. Return nil if no such element is found.
"
   :pre "condition must have one parameter, be applicable to all elements of list and return a boolean value"
   )
  (find-if condition list)
  )



(def-function inject ((operation :documentation "function to be applied") (list :type sequence) initial-value)
  (:documentation
  "
Returns the final result of evaluating operation using each element of list and the previous evaluation result as the parameters.
"
   :pre "operation must have two parameters, be applicable to initial-value and all elements of sequence and return a value of the same type"
   :examples
   "
(inject '+ '(1 2 3) 0 ) --> 0 + 1 + 2 + 3 = 6
"
)
  (loop with result = initial-value
      for e in list do (setf result (funcall operation result e))
      finally (return result)
        )
  )
    

;;;; Assoc list utils

(defun assoc-all (key a-list)
  "
returns a list of all values matching key in association list a-list. 
Test: 'equal
"
  (loop for assoc in a-list if (equal key (car assoc)) collect 
        (cdr assoc)                           
        )
  )

;;;;<string utilities>

;;; currently not exported
(defgeneric  starts-with ( string1 string2)
  ( :documentation 
   "
checks whether a string starts with another string

param string1: string that is checked
param string2: start string (to be checked)
result: T if string1 starts with string2, nil otherwise 

Examples:
  (starts-with \"Hello World!\" \"Hello\") --> true
  (starts-with \"Hello World!\" \"\") --> true
  (starts-with \"Hello World!\" \"Hello World!\") --> true
  (starts-with \"Hello World!\" \"World!\") --> nil
  (starts-with \"Hello World!\" \"Hello World!!\") --> nil
  (starts-with \"\" \"Hello World!\") --> nil
"
   )
  )

(defmethod starts-with (( string1 string) ( string2 string))
  (let ((comparison (string<= string2 string1)))
    (and 
     comparison
     (>= comparison (length string2))
     )
    )
  )




    
