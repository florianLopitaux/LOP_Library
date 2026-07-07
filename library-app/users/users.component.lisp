(bis:def-component :de.h-da.lop.app.library-app.users
  (:nicknames :users)
  (:documentation "Package that relate to all types of users of the library")
  (:languages :bis :functional :oo :test :rule :workflow)
  (:import
    ;; PACKAGE DEPENDENCIES

   )
  (:export
    ;; DATATYPES
    eCustomerStatus
    eCustomerRole
    tFullName
    make-tFullName ;; constructor of struct tFullName
    tFullName-first-name ;; getter of struct tFullName
    tFullName-last-name ;; getter of struct tFullName
    tAddress
    make-tAddress ;; constructor of struct tAddress
    tAddress-street ;; getter of struct tAddress
    tAddress-zip ;; getter of struct tAddress
    tAddress-city ;; getter of struct tAddress
    tAddress-country ;; getter of struct tAddress

    ;; CLASSES / ENTITIES
    Customer
    get-name ;; getter of class Customer
    get-address ;; getter of class Customer
    get-email ;; getter of class Customer
    get-status ;; getter of class Customer
    get-role ;; getter of class Customer

    ;; ENTITY MANAGER FUNCTIONS
    findAllStudents
    findAllProfessors
    findAllActiveCustomers
    findAllDisableCustomers

    ;; SERVICE FUNCTIONS
    createCustomer
   )
  )
