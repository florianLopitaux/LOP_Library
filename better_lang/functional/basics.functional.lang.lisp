(in-package :de.h-da.lop.lang.functional)


;;; Boolean constants

(defconstant true t "boolean true")

(defconstant false nil "boolean false")

(defconstant else t "to be used in cond statement instead of t")



;;;;<macro def-function> macro definition and auxiliary functions

(defvar *generate-pre-post-conditions* t)
(defvar *generate-type-declarations* t)
(defvar *generate-type-checks* t)


(defmacro def-function (function-name parameter-specifiers &body options-and-body)
  "
Extends and unifies the defun /defmethod /defgeneric macros. Accepts all allowed parameter values of defun.

Extensions:

Qualifiers :before :after :around as for methods

Parameter specifications: 
parameter names can be replaced by (parameter-name :type parameter-type :documentation parameter-documentation)
:type - if provided will be used for type declarations / type checking
:documentation - if provided, will be used in the function documentation
Also, concrete numbers or (qouted) symbols can be provided as literal values instead of a parameter names. They are then matched with the actual parameters.

Options: 
instead of the documentation string, an options property list may be provided.
:documentation - a documentation string describing the rationale of the function 
:examples - a documentation string showing examples of using the function
:pre - preconditions (several :pre expressions may be supplied). Must be Lisp code that evaluates properly. Will be checked at run-time and be part of the documentation
:post - postconditions (several :post expressions may be supplied). The symbol :result may be used to specifiy conditions on the function result
:result-type - a type specifier for the function result. Will be used for type declarations / type checking
:result-documentation - documentation string for the function result
:error - documentation string denoting errors that are signalled by the function

Examples:
(def-function foo ((x :type number :documentation \"1st param\") 
                      (y :documentation \"2nd param\")   
                      &optional
                      z)
  (:documentation \"computes ...\"
                  :result-type list
                  :result-documentation \"a list containing x y and z\"
                  :pre (> x 0)
                  :pre \"this is difficult to express in code\"
                  :post (> (length :result) 2))
  
  (list x y z))

(def-function fact (1) 1)
(def-function fact (n) (* n (- n 1)))
"
  (let* ((qualifier-is-specified (member parameter-specifiers (list :before :after :around))) ;;; special case: qualifier specified before parameters
         (qualifier (if qualifier-is-specified (list parameter-specifiers) nil))  ;; special case: qualifier is passed in variable parameter-specifiers
         (parameter-specifiers* (if qualifier-is-specified (first options-and-body) parameter-specifiers))  ;; special case: parameter-specifiers are passed as first element of options-and-body
         (options-and-body* (if qualifier-is-specified (rest options-and-body) options-and-body))  ;;; special case: first element of options-and-body (now parameter-specifiers*) is removed
         (options-and-body-split (split-options-and-body options-and-body*))
         (doc-string (first options-and-body-split))
         (options (second options-and-body-split)) 
         (declarations (third options-and-body-split)) 
         (body (fourth options-and-body-split))
         (result (gensym)) ; new variable name to avoid variable name conflicts
         (new-method (gensym)) ; new variable name
         (parameters (generate-parameter-list parameter-specifiers*))
         (documentation (generate-documentation parameter-specifiers* options doc-string))
         (preconditions (if *generate-pre-post-conditions* (generate-preconditions options)))
         (postconditions (if *generate-pre-post-conditions* (generate-postconditions options result)))
         (result-type-declaration (if *generate-type-declarations* (generate-result-type-declaration options result)))
         (result-type-check (if *generate-type-checks* (generate-result-type-check options result)))
         (expanded-body (if (or result-type-declaration result-type-check postconditions)
                            (list `(let ((,result (progn ,@body)))
                                     ,@result-type-declaration  ; expand nothing if no result type is specified
                                     ,@result-type-check ; expand nothing if no result type is specified
                                     ,@postconditions
                                     ,result
                                     ))
                          body  ; if neither result type nor postconditions are specified no let form is needed resulting in a simpler expansion     
                          )
                        )
         )
    `(let* ((,new-method 
             (defmethod ,function-name ,@qualifier ,parameters
               ,@declarations    ; additional declare statements provided in the function body
               ,@preconditions
               ,@expanded-body
               )
             ))
       ,(if documentation
            `(excl::put-property
              (quote ,function-name)
              (quote ,documentation)
              'excl::%fun-documentation)
          )
       ,new-method
       )
    )
  )



; Note on providing literal values instead of variable names:
; The implementation uses the eql type specifier of defmethod. 
; It compares via eql which works for numbers and symbols but not for string literals since (eql "x" "x") --> false
; It may be possible to define special (using deftype, and satisfies, type-of, equal etc.). 
; However, this seems to be difficult:
; - deftype and satisfies requires a symbol as predicate -> a predicate needs to be defined globally
; - defmethod needs a symbol as class -> a type needs to be defined globally
; - a type definition does not suffice for defmethod - a class is required.


(defun split-options-and-body (options-and-body)
  "
Analyses options-and-body and returns a list with 4 elements
1. documentation string if provided in classic defun notation - nil otherwise
2. options property list if provided in extended def-function notation - nil otherwise
3. declare statements if specified at the start of the function body - nil otherwise
4. function body without 1.-3.
"
  (let ((remaining-elements options-and-body)
        (current-element (first options-and-body))  ; always first remaining element
        (options nil) 
        (doc-string nil) 
        (declarations nil) 
        (body nil))    
    (loop
      (cond 
       ((and (is-options-list-p current-element) (not doc-string)) ; options list and doc string are exclusive
        (setf options current-element)
        )
       ((and (typep current-element 'string) (not options) (> (length remaining-elements) 1))  
        ; candidate for doc-string: string type and not last statement (then return value)
        (setf doc-string current-element)
        )
       ((is-declaration-p current-element)
        (setf declarations (cons current-element declarations))
        )
       (t (return))  ; from loop
       )
      (setf remaining-elements (rest remaining-elements))  ; prepare for next loop
      (setf current-element (first remaining-elements))                  
      )
    (setf body remaining-elements)
    (list doc-string options declarations body)
    )
  )



(defun is-options-list-p (expr)
  "
checks whether expr is  a property list containing properties :documentation :examples :pre :post :result-type :result-documentation or :error
"
  (handler-case 
      (get-properties expr '(:documentation :examples :pre :post :result-type :result-documentation :error)) ; if none of the keywords matches nil is returned 
    (error () nil)))  ; if expr is a malformed property list or no list at all then nil is returned



(defun is-declaration-p (expr)
  "
Checks whether expr is a declare-statement
"
  (and
   (listp expr)
   (equal (first expr) 'declare)))




(defun generate-function-type-declaration (function-name parameter-specifiers options)
  "
Generates a list containing a function type declaration for function-name based on the parameter and result type declarations.
May signal an error if options is a malformed property list.
"
  (let ((result-type (or (getf options :result-type) t))  
        ; if result type is specified it is used; type t is used, otherwise
        ; may signal an error if options is a malformed property list.
        (parameter-types (mapcar (lambda (parameter-specifier)
                                   (if (find (get-parameter-name parameter-specifier) '(&optional &rest &key &aux))
                                       (get-parameter-name parameter-specifier) ; add &optional etc. to type declaration
                                     (if (has-type-declaration-p parameter-specifier)
                                         (get-type parameter-specifier)
                                       t)))  ; type t if no explicit type was specified
                           parameter-specifiers)))
    (list `(declare (ftype (function ,parameter-types ,result-type) ,function-name)))))



(defun generate-parameter-type-declarations (parameter-specifiers)
  "
collects declare type statements from the :type declarations in parameter-specifiers
"
  (mapcan
      (lambda (parameter-specifier) 
        (and (has-type-declaration-p parameter-specifier) 
             (list `(declare (type ,(get-type parameter-specifier) ,(get-parameter-name parameter-specifier))))))
    ; if has-type-declaration-p evaluates to true then the declare type expression is collected - mapcan removes surrounding list
    ; otherwise, #'and evaluates to nil and mapcan collects nothing
    parameter-specifiers)) 


(defun generate-result-type-check (options result-variable-name)
  "
Generates a list containing a check-type statement for result-variable-name if a type is specified via :result-type
nil otherwise.
May signal an error if options is a malformed property list.
"
  (let ((result-type (getf options :result-type))) ; May signal an error is options is a malformed property list.
    (if result-type
        (list `(check-type ,result-variable-name ,result-type))
      nil)))


(defun generate-result-type-declaration (options result-variable-name)
  "
Generates a list containing a type declaration for result-variable-name if a type is specified via :result-type
nil otherwise.
May signal an error is options is a malformed property list.
"
  (let ((result-type (getf options :result-type))) ; May signal an error is options is a malformed property list.
    (if result-type
        (list `(declare (type ,result-type ,result-variable-name)))
      nil)))



(defun generate-preconditions (options)
  "
generates an assertion for each pre-condition indicated by :pre
"
  (mapcar 
      (lambda (precondition)
        (if (not (typep precondition 'string))
            (let ((error-message (format nil "Pre-condition ~A failed" precondition)))
              `(assert ,precondition nil ,error-message))))
    (get-all options :pre)))



(defun generate-postconditions (options result-variable-name)
  "
generates an assertion for each post-condition indicated by :post
The symbol 'result will be replaced by result-variable-name
"
  (mapcar 
      (lambda (postcondition)
        (let ((transposed-postcondition (replace-all postcondition :result result-variable-name))
              (error-message (format nil "Post-condition ~A failed" postcondition)))
          `(assert ,transposed-postcondition nil ,error-message)))
    (get-all options :post)))




(defun replace-all (list symbol1 symbol2)
  "
Returns a new list in which all occurrences of symbol1 in list (and recursively its sublists) are replaced by symbol2
"
  (if list
      (if (listp (car list))
          (cons 
           (replace-all (car list) symbol1 symbol2)
           (replace-all (cdr list) symbol1 symbol2))
        ; (car list) is scalar
        (if (equal (car list) symbol1)
            (cons symbol2 (replace-all (cdr list) symbol1 symbol2))
          (cons (car list) (replace-all (cdr list) symbol1 symbol2))))
    nil))



(defun get-all (property-list key)
  "
collects all values in property-list that match key
"
  (if property-list
      (if (equal (first property-list) key)
          (cons (second property-list) (get-all (cddr property-list) key))
        (get-all (cddr property-list) key))
    nil))


(defun generate-documentation (parameter-specifiers options doc-string)
  "
Generates the extended function documentation and returns it as a string if at least one :documentation parameter or doc string was provided, nil otherwise.
May signal an error if options is a malformed property list.
"
  (if (or doc-string (member-recursive :documentation parameter-specifiers) (member-recursive :documentation options)) ;; at least some documentation provided
      (with-output-to-string (s)
        (generate-specified-documentation options doc-string s)
        (generate-parameter-documentation parameter-specifiers s)
        (generate-result-documentation options s)
        (generate-error-documentation options s)
        (generate-conditions-documentation :pre options s)
        (generate-conditions-documentation :post options s)
        (generate-examples-documentation options s)
        )
    nil ;; no documentation 
    )
  )



(defun generate-specified-documentation (options doc-string s)
  "
Prints documentation to string-stream s
if specified via :documentation in options.
May signal an error if options is a malformed property list.
"
  (let ((documentation (or doc-string (getf options :documentation)))) 
    ; doc-string is non-nil if classic defun-style documentation is provided as opposed to a property list
    ; if doc-string is provided then options must be nil and vice versa
    ; getf may signal an error if options is a malformed property list
    (when documentation 
      (format s "~%~A" documentation))))  


(defun generate-parameter-documentation (parameter-specifiers s)
  "
Generates printable representation of the parameter specification 
in the form \"parameter-name : type - documentation\"
and prints it to string-stream s.
" 
  (when parameter-specifiers
    (format s "~%Parameters: ~%")
    (dolist (parameter-specifier parameter-specifiers)
      (format s "    ~A" (get-parameter-name parameter-specifier))
      (if (has-type-declaration-p parameter-specifier)
          (format s " : ~A" (get-type parameter-specifier)))
      (if (has-parameter-documentation-p parameter-specifier)
          (format s " - ~A" (get-parameter-documentation parameter-specifier)))
      (format s "~%"))))


(defun generate-result-documentation (options s)
  "
Generates printable representation of the return value 
in the form \"result : result-type - result-documentation\"
and prints it to string-stream s.
May signal an error if options is a malformed property list.
" 
  (let ((result-type (getf options :result-type)) ; may signal an error if options is a malformed property list
        (result-documentation (getf options :result-documentation))) ; may signal an error if options is a malformed property list
    (when (or result-type result-documentation) ; result-type rsp. result-documentation are nil if not provided
      (format s "~%result ")
      (when result-type
        (format s ": ~A " result-type))
      (when (and result-type result-documentation)
        (format s " - "))
      (when result-documentation
        (format s "~A" result-documentation))
      (format s "~%"))))




(defun generate-error-documentation (options s)
  "
Generates printable representation of the error specification 
and prints it to string-stream s.
May signal an error if options is a malformed property list
" 
  (let ((error-specifications (get-all options :error))) ; collection of all specified errors
    (when error-specifications  
      (format s "~%Errors:~%")
      (dolist (error-specification error-specifications) 
        (format s "    ~A~%" error-specification))))
  )



(defun generate-conditions-documentation (pre-post-qualifier options s)
  "
Generates printable representation of the specified 
pre-conditions (if pre-post-qualifiers equals :pre) 
rsp. post-conditions (if pre-post-qualifiers equals :post) 
and prints it to string-stream s.
" 
  (let ((conditions (get-all options pre-post-qualifier))) ; collection of all specified pre- rsp. post-conditions
    (when conditions  
      (format s "~%~A:~%" (ecase pre-post-qualifier (:pre "Preconditions") (:post "Postconditions")))
      (dolist (condition conditions) 
        (format s "    ~A~%" condition)))))





(defun generate-examples-documentation (options s)
  "
Generates printable representation of examples 
if specified via :examples in options
and prints it to string-stream s.
May signal an error if options is a malformed property list
" 
  (let ((examples (getf options :examples))) ; may signal an error if options is a malformed property list
    (when examples 
      (format s "~%Examples:~%~A~%" examples))))




(defun is-extended-parameter-p (parameter-specifier)
  "
checks whether parameter-specifier is a list of the form (parameter-name [:type type-declaration] [:documentation documentation])
"
  (and
   (listp parameter-specifier)
   (> (length parameter-specifier) 2)
   (or (member :type parameter-specifier) (member :documentation parameter-specifier))
   )
  )




(defun get-parameter-name (parameter-specifier)
  "
returns the parameter name no matter whether a simple or extended parameter form is supplied
"
  (if (is-extended-parameter-p parameter-specifier)
      (first parameter-specifier)
    parameter-specifier))  ; simple parameter declaration



(defun parameter-specification (parameter-specifier) 
  "
returns a property list with :type and :documentation keys if parameter-specifier is an extended parameter form
returns nil if if parameter-specifier is a simple parameter form
"
  (if (is-extended-parameter-p parameter-specifier)
      (cdr parameter-specifier) ; parameter specifier stripped by the parameter name
    nil))



(defun get-type (parameter-specifier)
  "
returns the type declaration in parameter-specifier if one is supplied
nil otherwise

May signal an error if the parameter-specification is a malformed property list
"
  (if (is-extended-parameter-p parameter-specifier)
      (getf (parameter-specification parameter-specifier) :type)
    nil))




(defun has-type-declaration-p (parameter-specifier)
  "
checks whether parameter-specifier contains a :type declaration 
"
  (get-type parameter-specifier)) ; get-type returns nil if parameter-specifier is simple or does not contain a :type declaration



(defun has-parameter-documentation-p (parameter-specifier)
  "
checks whether parameter-specifier contains a :documentation declaration 
"
  (get-parameter-documentation parameter-specifier)) ; get-type returns nil if parameter-specifier is simple or does not contain a :type declaration



(defun get-parameter-documentation (parameter-specifier)
  "
returns the documentation string in parameter-specifier if one is supplied
nil otherwise

May signal an error if the parameter-specification is a malformed property list
"
  (if (is-extended-parameter-p parameter-specifier)
      (getf (parameter-specification parameter-specifier) :documentation)))


(defun custom-type-p (type-symbol)
  "Renvoie T si le symbole commence par 'e' ou 't' suivi d'une majuscule."
  (and (symbolp type-symbol)
       (let ((name (symbol-name type-symbol)))
         (and (>= (length name) 2)
              (member (char name 0) '(#\e #\t))
              (upper-case-p (char name 1))))))

(defun generate-parameter-list (parameter-specifiers)
  "
collects all parameter names incl. directives like &optional from the list of parameter specifiers
"
  (loop for parameter-specifier in parameter-specifiers collect 
        (cond ((is-extended-parameter-p parameter-specifier)
               (if (has-type-declaration-p parameter-specifier) ;; type specification via :type
                   (let ((raw-type (get-type parameter-specifier)))
                     ;; SPECIAL CASE FOR ENUM OR DATATYPES
                     (if (custom-type-p raw-type)
                         ;; IGNORE TYPE TO AVOID ERRORS WITH ENUMS AND DATATYPES
                         (get-parameter-name parameter-specifier)
                         ;; ELSE NORMAL CASE (code of professor)
                         (list (get-parameter-name parameter-specifier) (get-type parameter-specifier))))

                   (get-parameter-name parameter-specifier)  ;; no :type specification, only :documentation
                 )
               )
              ((symbolp parameter-specifier)  ;; standard parameter name
               (get-parameter-name parameter-specifier)
               )
              (t  ;; literal value (number or symbol) for argument matching
               `(,(gensym) (eql ,parameter-specifier))
               )
              )
        )
  )


               

(defun generate-type-checks (parameter-specifiers)
  "
collects check-type statements from the :type declarations in parameter-specifiers
"
  (mapcan
      (lambda (parameter-specifier) 
        (and (has-type-declaration-p parameter-specifier) 
             (list `(check-type ,(get-parameter-name parameter-specifier) ,(get-type parameter-specifier)))))
    ; if has-type-declaration-p evaluates to true then the check-type expression is collected - mapcan removes surrounding list
    ; otherwise, #'and evaluates to nil and mapcan collects nothing
    parameter-specifiers)) 


(defun member-recursive (x l) 
  "applies predicate member with test equal for list and sublists"
  (if l  ;; l is not empty
      (cond ((equal x (first l))
             t
             )
            ((listp (first l))
             (or (member-recursive x (first l)) (member-recursive x (rest l)))
             )
            (t
             (member-recursive x (rest l))
             )
            )
    nil ;; l is empty
    )
  )



    
