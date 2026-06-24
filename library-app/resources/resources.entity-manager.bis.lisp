(in-package :resources)


;;; =====================================
;;; DB REQUEST FUNCTIONS
;;; =====================================

(def-function findAllResearchBookReferences ()
  ;; function documentation
  (
    :documentation "Get all book references that are research document"
    :examples "(findAllResearchBookReferences) -> (#<BookReference [4]* ... :research> #<BookReference [27]* ... :research> #<BookReference [51]* ... :research>)"
    :result-type list
  )

  ;; function body
  (query ?b
    (db BookReference ?b type :research)
  )

) ;; end function


(def-function findAllNormalBookReferences ()
  ;; function documentation
  (
    :documentation "Get all book references that are normal document"
    :examples "(findAllResearchBookReferences) -> (#<BookReference [4]* ... :normal> #<BookReference [27]* ... :normal> #<BookReference [51]* ... :normal>)"
    :result-type list
  )

  ;; function body
  (query ?b
    (db BookReference ?b type :normal)
  )

) ;; end function