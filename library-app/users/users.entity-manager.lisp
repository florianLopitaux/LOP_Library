(in-package :users)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllStudents ()
  ;; function documentation
  (
    :documentation "Get all customers' library that are students"
    :examples "(findAllStudents) -> (#<Customer[33]* ... :student> #<Customer [45]*  ... :student>)"
    :result-type 'list
  )

  ;; function body
  (query ?c
    (db Customer ?c role :student)
  )

) ;; end function


(def-function findAllProfessors ()
  ;; function documentation
  (
    :documentation "Get all customers' library that are university professors"
    :examples "(findAllProfessors) -> (#<Customer[20]* ... :professor> #<Customer [23]*  ... :professor>)"
    :result-type 'list
  )

  ;; function body
  (query ?c
    (db Customer ?c role :professor)
  )

) ;; end function


(def-function findAllActiveCustomers ()
  ;; function documentation
  (
    :documentation "Get all customers' library that are active (currently subscribed)"
    :examples "(findAllActiveCustomers) -> (#<Customer[20]* ... :active> #<Customer [23]*  ... :active>)"
    :result-type 'list
  )

  ;; function body
  (query ?c
    (db Customer ?c status :active)
  )
) ;; end function

(def-function findAllDisableCustomers ()
  ;; function documentation
  (
    :documentation "Get all customers' library that are disable (currently unsubscribed or 'delete' their account)"
    :examples "(findAllActiveCustomers) -> (#<Customer[20]* ... :active> #<Customer [23]*  ... :active>)"
    :result-type 'list
  )

  ;; function body
  (query ?c
    (db Customer ?c status :disable)
  )
) ;; end function
