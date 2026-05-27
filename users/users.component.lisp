(bis:def-component :de.h-da.lop.app.library-app.users
  (:nicknames :users)
  (:documentation "Package that relate to all types of users of the library")
  (:languages :functional :oo :bis :rule :workflow :test)    ;;; delete languages not used here
  (:import  
     ;;; specify dependent components (not quoted)
	  
   )
  (:export  
     ;;; Specify functions and classes that shall be visible for other components (not quoted)
   Librarian
   Customer
   Student
   Professor
   subscribe-customer
   unsubscribe-customer
   apply-student-subscribe-reduc
   apply-professor-subscribe-reduc
   )
  )
