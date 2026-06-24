(bis:def-component ::de.h-da.lop.library-app.resources
  (:nicknames :resources)
  (:documentation "Package that relate to all types of resources in the library")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import  
      ;;; no dependencies
	  
   )
  (:export
    ;; DATATYPES
    eBookType

    ;; CLASSES
    BookReference
    get-title
    get-author
    get-type

    ;; FUNCTIONS
    findAllResearchBookReferences
    findAllNormalBookReferences
   )
  )
