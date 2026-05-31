(in-package :users)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllStudents ()
  ;; function documentation
  (
    :documentation "Get all customers' library that are students"
    :examples "(findAllStudents) -> (#<Customer[33]* ... :student> #<Customer [45]*  ... :student>)"
    :return-type 'list
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
    :return-type 'list
  )

  ;; function body
  (query ?c
    (db Customer ?c role :professor)
  )

) ;; end function
