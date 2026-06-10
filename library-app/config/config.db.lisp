(in-package :config)


;;; =====================================
;;; DB CLEAN FUNCTIONS
;;; =====================================

(def-function _deleteEntityInstances (
    (instances :type list :documentation "All instances to delete")
  )
  ;; function documentation
  (
    :documentation "Clear all instances of entities that are in the list parameter"
    :examples "(_deleteEntityInstances '(instance1 instance2) -> nil"
  )

  ;; function body
  (cond ((= (length instances) 0) nil) ;; recursif break point
        (else (progn
          (delete-instance (first instances))
          (_deleteEntityInstances (rest instances)) ;; recursif call
        ))
  )

) ;; end function

(def-function dbClear (
    (entities :type list :documentation "List of entities to clear")
  )
  ;; function documentation
  (
    :documentation "Clear all instances of entities that are in the list parameter"
    :examples "(dbClear '(BorrowingRecord Customer)) -> nil ;; clear instances of BorrowingRecord and Customer"
  )

  ;; function body
  (cond ((= (length entities) 0) nil)  ;; recursif break point
        (else (progn
          (format t "[DB-CONFIG] Clean database entity '~A' rows~%" (first entities))

          ;; clear all istances of the first entity in the list
          (_deleteEntityInstances (find-all (first entities)))

          (format t "[DB-CONFIG] Entity '~A' cleared !~%" (first entities))

          ;; recursif call
          (dbClear (rest entities))
        ))
  )

) ;; end function


(def-function dbClearAll ()
  ;; function documentation
  (
    :documentation "Clear all the database, so every instance of every entity"
    :examples "(dbClearAll) -> nil ;; clear all instances of all entities"
  )

  ;; function body
  (dbClear '(
      users:Customer
      resources:BookReference
      ;; stock:BookItem
      ;; borrow-system:BorrowingRecord
      ;; payment-system:Transaction
    )
  )

) ;; end function



;;; =====================================
;;; DB SEED FUNCTIONS
;;; =====================================

(def-function _dbSeedCustomer ()
  ;; function documentation
  (
    :documentation "Fill the Customer entity with template entity object"
    :examples "(dbSeedCustomer) -> (#<Customer[1]* ...> #<Customer[2]* ...)"
    :post (> (length :result) 0)
    :return-type 'list
  )

  ;; function body
  (list
    (make-instance 'users:Customer
      :name (users:make-tFullName :first-name "John" :last-name "Doe")
      :email "john.doe84@hotmail.com"
      :status :active)

    (make-instance 'users:Customer
      :email "julien.schieler@gmail.com"
      :status :disable)

    (make-instance 'users:Customer
      :address (users:make-tAddress
        :street "15 Rue de la Paix" 
        :zip "75002" 
        :city "Paris" 
        :country "France")
      :role :professor
      :status :active)

    (make-instance 'users:Customer
      :name (users:make-tFullName :first-name "KiKi" :last-name "...")
      :role :student
      :status :disable)

    (make-instance 'users:Customer
      :name (users:make-tFullName :first-name "Alice" :last-name "Cooper")
      :address (users:make-tAddress 
        :street "500 El Camino Real" 
        :zip "95053" 
        :city "Santa Clara" 
        :country "USA")
      :role :student
      :status :active)
  )

) ;; end function

(def-function _dbSeedBookReference ()
  ;; function documentation
  (
    :documentation "Fill the BookReference entity with template entity object"
    :examples "(dbSeedBookReference) -> (#<BookReference[1]* ...> #<BookReference[2]* ...)"
    :post (> (length :result) 0)
    :return-type 'list
  )

  ;; function body
  (list
    (make-instance 'resources:BookReference
      :title "Clean Code"
      :author "Robert Martin"
      :type :research)
   
    (make-instance 'resources:BookReference
      :title "Harry Potter"
      :author "JK Rowling"
      :type :normal)
   
    (make-instance 'resources:BookReference
      :title "Star Wars"
      :author "Alan Dean Foster")

   


  )

) ;; end function



(def-function dbSeed (
    (entities :type list :documentation "List of entities to seed")
  )
  ;; function documentation
  (
    :documentation "Seed all entities that are in the list parameter with template instances"
    :examples "(dbSeed '(Customer BookItem)) -> ((#<Customer[1]* ...> ...) (#<Bookitem[1]* ...> ...))"
    :return-type 'list
  )

  ;; function body
  (cond ((= (length entities) 0) '())  ;; recursif break point

        (else (let
          ((result (append
            ;; call the seed entity function which has to be properly named
            (funcall (cl:intern (format nil "_dbSeed~A" (first entities)) "config"))

            ;; recursif call
            (dbSeed (rest entities))
          )))

          (format t "[DB-CONFIG] Entity '~A' seeded !~%" (first entities))
          result
        ))
  )

) ;; end function


(def-function dbSeedAll ()
  ;; function documentation
  (
    :documentation "Clear all the database, so every instance of every entity"
    :examples "(dbSeedAll) -> ((entity1 objects) (entity2 objects) (entity3 objects)) ;; clear all instances of all entities"
    :return-type 'list
  )

  ;; function body
  (dbSeed '(
      users:Customer
      resources:BookReference
      ;; stock:BookItem
      ;; borrow-system:BorrowingRecord
      ;; payment-system:Transaction
    )
  )

) ;; end function



;;; =====================================
;;; DB RESET FUNCTIONS
;;; =====================================

(def-function resetAfterTest (
    (entities :type list :documentation "List of entities to reset")
  )
  ;; function documentation
  (
    :documentation "Clear & Seed entities that are in the list parameter"
    :examples "(resetAfterTest '(Customer BookItem)) -> ((#<Customer[1]* ...> ...) (#<Bookitem[1]* ...> ...))"
    :pre (not (equal entities nil))
    :post (= (length :result) (length entities))
    :return-type 'list
  )

  ;; function body
  (progn
    (dbClear entities)
    (dbSeed entities)
  )

) ;; end function


(def-function resetAllAfterTest ()
  ;; function documentation
  (
    :documentation "Clear all the database, then seed it with template instance"
    :examples "(resetAllAfterTest) -> ((entity1 objects) (entity2 objects) (entity3 objects))"
    :return-type 'list
  )

  ;; function body
  (progn
    (dbClearAll)
    (dbSeedAll)
  )

) ;; end function
