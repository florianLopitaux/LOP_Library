(bis:def-component ::de.h-da.lop.library-app.resources
  (:nicknames :resources)
  (:documentation "Package that relate to all types of resources in the library")
  (:languages :functional :oo :bis :rule :workflow :test)
  (:import  
    ;; PACKAGE DEPENDENCIES
	  
   )
  (:export
    ;; DATATYPES
    eBookType

    ;; CLASSES / ENTITIES
    BookReference
    get-title ;; getter of class BookReference
    get-author ;; getter of class BookReference
    get-type ;; getter of class BookReference

    ;; ENTITY MANAGER FUNCTIONS
    findAllNormalBookReferences
    findAllResearchBookReferences
   )
  )
