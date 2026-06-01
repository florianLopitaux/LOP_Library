(in-package :de.h-da.lop.lang.functional)


;;; predicates

(def-function is-even ((n :type integer))
  (:documentation 
"
returns true if n is even,
false otherwise
"
   :examples 
"
(is-even 2) --> true
(is-even 3) --> false
(is-even 3.5) --> error
"
  )
  (evenp n)
)


(def-function is-odd ((n :type integer))
  (:documentation 
"
returns true if n is odd,
false otherwise
"
   :examples 
"
(is-even 2) --> true
(is-even 3) --> false
(is-even 3.5) --> error
"
  )
  (oddp n)
)