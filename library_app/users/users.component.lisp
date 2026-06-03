(bis:def-component :de.h-da.lop.app.library-app.users
  (:nicknames :users)
  (:documentation "Package that relate to all types of users of the library")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import
    ;; PACKAGE DEPENDENCIES

   )
  (:export
    ;; DATATYPES
    eCustomerStatus
    eCustomerRole
    tFullName
    make-tFullName
    tAddress
    make-tAddress

    ;; CLASSES
    Customer

    ;; FUNCTIONS
    applyDiscount
    findAllStudents
    findAllProfessors
   )
  )
