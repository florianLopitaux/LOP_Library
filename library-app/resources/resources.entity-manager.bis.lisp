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
