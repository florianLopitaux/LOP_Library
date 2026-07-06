(bis:def-component :de.h-da.lop.app.library-app.users
  (:nicknames :users)
  (:documentation "Package that relate to all types of users of the library")
  (:languages :bis :functional :oo :test :rule :workflow)    ;;; delete languages not used here
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
    get-name
    get-address
    get-email
    get-status
    get-role

    ;; FUNCTIONS
    createCustomer
    getCustomerRating
    customerToStringFormat
    customerListToStringFormat
    customerFromStringFormat
    applyDiscount
    findAllStudents
    findAllProfessors
    findAllActiveCustomers
    findAllDisableCustomers
   )
  )
