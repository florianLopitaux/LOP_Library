(in-package :rule)



(defmacro <--- (clause &optional documentation)
  "
declares a Prolog functor and retracts all rules for the functor with the same arity

Example:
(<--- (father ?father ?child)
      \"Rule with parameters:
      ?father : atom - id of person
      ?child : atom - id of person
      
      is satisfied if ?father is a male parent of ?child\"
      )
"
(declare (ignore documentation))
  `(<-- ,clause (fail))
  )


(defmacro query (template &body clauses)
"
Evaluates the Prolog clauses and returns a list of all solutions.

Parameters:
template - a Prolog variable or a list of Prolog variables which are used in the clauses
clauses - Prolog clauses

Returns a result list with all variables replaced by the results of the Prolog query

Example:
(<- person John)

(query ?p (person ?p)) --> (John)
(query (?p) (person ?p)) --> ((John))
"   
  (let ((results (gensym))
        (result (if (listp template) `(list ,@template) template))
        )
    `(let ((,results nil))
       (prolog 
        ,@clauses
        (lisp (push ,result ,results))
        )
        ,results
       )
    )
  )
  
  


(defmacro query-distinct (template &body clauses)
"
Evaluates the Prolog clauses and returns a list of all distinct solutions.

Parameters:
template - a Prolog variable or a list of Prolog variables which are used in the clauses
clauses - Prolog clauses

Returns a result list with all variables replaced by the results of the Prolog query

Example:
(<- person John)

(select-rule ?p (person ?p)) --> (John)
(select-rule (?p) (person ?p)) --> ((John))
"   
  (let ((results (gensym))
        (result (if (listp template) `(list ,@template) template))
        )
    `(let ((,results nil))
       (prolog 
        ,@clauses
        (lisp (pushnew ,result ,results :test 'equal))
        )
        ,results
       )
    )
  )
  
   
  
  
  
(defmacro prove (&body clauses)
"
Checks whether Prolog clauses are satisfied.

Parameters:
clauses - Prolog clauses

returns t if clauses are satisfied, nil otherwise
"   
    `(block prove
       (prolog 
        ,@clauses
        (lisp (return-from prove t))
        )
        (return-from prove nil)
       )
  )