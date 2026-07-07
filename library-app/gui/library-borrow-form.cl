;;; Code for the form named :library-borrow-form of class library-borrow-dialog.
;;; The inspector may add event-handler starter code here,
;;; and you may add other code for this form as well.
;;; The code for recreating the window is auto-generated into 
;;; the *.bil file having the same name as this *.cl file.

(in-package :common-graphics-user)

(defclass library-borrow-dialog (dialog)
  ())


(defmethod initialize-instance :after ((dialog library-borrow-dialog) &key)
  ;; function body
  (let* (
    (customer-dropdown (find-component :customer-dropdown dialog))
    (customers (bis:find-all 'users:Customer))
    (book-list (find-component :available-book-list dialog))
    (books (bis:find-all 'stock:BookItem))
    )
  
  (setf (range customer-dropdown) (functional:add "No Customer Selected" (users:customerListToStringFormat customers)))
  (setf (range book-list) (stock:bookListToStringFormat (functional:select (lambda (x) (borrowing-system:isBookItemAvailable x)) books)))
  (setf (value book-list) (first (range book-list)))
  )

) ;; end function
