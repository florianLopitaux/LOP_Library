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
      stock:BookItem
      borrowing-system:BorrowingRecord
      payment-system:Transaction
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
      :name (users:make-tFullName :first-name "Julien" :last-name "Shieler")
      :email "julien.schieler@gmail.com"
      :status :disable)

    (make-instance 'users:Customer
      :name (users:make-tFullName :first-name "Florian" :last-name "Lopitaux")
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
      :author "Robert Martin")
   
    (make-instance 'resources:BookReference
      :title "Harry Potter"
      :author "JK Rowling"
      :type :normal)
   
    (make-instance 'resources:BookReference
      :title "Star Wars"
      :author "Alan Dean Foster"
      :type :normal))
  
) ;; end function

(def-function _dbSeedBookItem ()
  ;; function documentation
  (
    :documentation "Fill the BookItem entity with template entity object"
    :examples "(dbSeedBookItem) -> (#<BookItem[1]* ...> #<BookItem[2]* ...)"
    :post (> (length :result) 0)
    :return-type 'list
  )

  ;; function body
  (list
    (make-instance 'stock:BookItem
      :book-ref (find-by-oid 'resources:BookReference 1019)
      )
    (make-instance 'stock:BookItem
      :book-ref (find-by-oid 'resources:BookReference 1019)
      :state :damage
      )
    (make-instance 'stock:BookItem
      :book-ref (find-by-oid 'resources:BookReference 1017)
      )
  )


  ) ;; end function

(def-function _dbSeedBorrowingRecord ()
  ;; function documentation
  (
    :documentation "Fill the BorrowingRecord entity with template entity object"
    :examples "(dbSeedBorrowingRecord) -> (#<BorrowingRecord[1]* ...> #<BorrowingRecord[2]* ...)"
    :post (> (length :result) 0)
    :return-type 'list
  )

  ;; function body
  (list
    (make-instance 'borrowing-system:BorrowingRecord
      :start-date (borrowing-system:make-tDate :month 6 :day 15 :year 2026)
      :due-date (borrowing-system:make-tDate :month 7 :day 15 :year 2026)
      :is-returned false
      :customer (find-by-oid 'users:Customer 1013)
      :book (find-by-oid 'stock:BookItem 1021)
      )
    (make-instance 'borrowing-system:BorrowingRecord
      :start-date (borrowing-system:make-tDate :month 6 :day 18 :year 2026)
      :due-date (borrowing-system:make-tDate :month 7 :day 18 :year 2026)
      :is-returned false
      :customer (find-by-oid 'users:Customer 1015)
      :book (find-by-oid 'stock:BookItem 1023)
      )
    (make-instance 'borrowing-system:BorrowingRecord
      :start-date (borrowing-system:make-tDate :month 5 :day 18 :year 2026)
      :due-date (borrowing-system:make-tDate :month 6 :day 18 :year 2026)
      :is-returned true
      :return-case :late
      :customer (find-by-oid 'users:Customer 1015)
      :book (find-by-oid 'stock:BookItem 1022)
      )
    (make-instance 'borrowing-system:BorrowingRecord
      :start-date (borrowing-system:make-tDate :month 3 :day 12 :year 2026)
      :due-date (borrowing-system:make-tDate :month 4 :day 12 :year 2026)
      :is-returned true
      :return-case :late-damage
      :customer (find-by-oid 'users:Customer 1015)
      :book (find-by-oid 'stock:BookItem 1023)
      )
    (make-instance 'borrowing-system:BorrowingRecord
      :is-returned true
      :customer (find-by-oid 'users:Customer 1011)
      :book (find-by-oid 'stock:BookItem 1022)
      )
   )
   
) ;; end function


(def-function _dbSeedTransaction ()
  ;; function documentation
  (
    :documentation "Fill the Transaction entity with template entity object"
    :examples "(dbSeedTransaction) -> (#<Transaction[1]* ...> #<Transaction[2]* ...)"
    :post (> (length :result) 0)
    :return-type 'list
  )

  ;; function body
  (list
    (make-instance 'payment-system:Transaction
      :reference :subscription
      :date (borrowing-system:make-tDate :month 6 :day 15 :year 2026)
      :amount 20
      :customer (find-by-oid 'users:Customer 1013)
      )
    (make-instance 'payment-system:Transaction
      :reference :borrow-book
      :date (borrowing-system:make-tDate :month 6 :day 15 :year 2026)
      :amount 5
      :customer (find-by-oid 'users:Customer 1013)
      )
    (make-instance 'payment-system:Transaction
      :reference :subscription
      :date (borrowing-system:make-tDate :month 6 :day 14 :year 2026)
      :amount 20
      :customer (find-by-oid 'users:Customer 1015)
      )
    (make-instance 'payment-system:Transaction
      :reference :borrow-book
      :date (borrowing-system:make-tDate :month 6 :day 18 :year 2026)
      :amount 5
      :customer (find-by-oid 'users:Customer 1015)
      )
    (make-instance 'payment-system:Transaction
      :reference :subscription
      :date (borrowing-system:make-tDate :month 4 :day 15 :year 2026)
      :amount 20
      :customer (find-by-oid 'users:Customer 1011)
      )
    (make-instance 'payment-system:Transaction
      :reference :borrow-book
      :date (borrowing-system:make-tDate :month 4 :day 16 :year 2026)
      :amount 5
      :customer (find-by-oid 'users:Customer 1011)
      )
    (make-instance 'payment-system:Transaction
      :reference :penalty-late-return
      :date (borrowing-system:make-tDate :month 6 :day 18 :year 2026)
      :amount 5
      :customer (find-by-oid 'users:Customer 1011)
      )
    (make-instance 'payment-system:Transaction
      :reference :penalty-book-damaged
      :date (borrowing-system:make-tDate :month 6 :day 18 :year 2026)
      :amount 10
      :customer (find-by-oid 'users:Customer 1011)
      )
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
      stock:BookItem
      borrowing-system:BorrowingRecord
      payment-system:Transaction
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
