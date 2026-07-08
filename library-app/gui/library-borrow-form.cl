;;; Code for the form named :library-borrow-form of class library-borrow-dialog.
;;; The inspector may add event-handler starter code here,
;;; and you may add other code for this form as well.
;;; The code for recreating the window is auto-generated into 
;;; the *.bil file having the same name as this *.cl file.

(in-package :common-graphics-user)

(defclass library-borrow-dialog (dialog)
  ())


;;; =====================================
;;; generic functions
;;; =====================================

(defun fillBooksAvailable (dialog)
  ;; function body
  (let* (
    (book-list (find-component :available-book-list dialog))
    (books (bis:find-all 'stock:BookItem))
    )

  (setf (range book-list) (oo:to-list-string-summary (functional:select (lambda (x) (borrowing-system:isBookItemAvailable x)) books)))
  (setf (value book-list) (first (range book-list)))
  )

) ;; end function


;;; =====================================
;;; initialize window function
;;; =====================================

(defmethod initialize-instance :after ((dialog library-borrow-dialog) &key)
  ;; function body
  (let* (
    (customer-dropdown (find-component :customer-dropdown dialog))
    (customers (bis:find-all 'users:Customer))
    )
  
  (setf (range customer-dropdown) (functional:add "No Customer Selected" (oo:to-list-string-summary customers)))
  (fillBooksAvailable dialog)
  )

) ;; end function


;;; =====================================
;;; Button On-Click event
;;; =====================================

(defun borrow-check-button-on-click (dialog widget)
  ;; function body
  (declare (ignorable dialog widget))
  (let* (
    ;; widgets
    (rating-field (find-component :summary-rating-field dialog))
    (due-date-field (find-component :summary-due-date-field dialog))
    (price-field (find-component :summary-price-field dialog))

    ;; form values
    (selected-customer (value (find-component :customer-dropdown dialog)))
    (month (handler-case (parse-integer (value (find-component :borrow-month-field dialog))) (parse-error () nil)))
    (day (handler-case (parse-integer (value (find-component :borrow-day-field dialog))) (parse-error () nil)))
    (year (handler-case (parse-integer (value (find-component :borrow-year-field dialog))) (parse-error () nil)))
    )

  (cond
    ((equal selected-customer "No Customer Selected") (format t "~%[ERROR] You have to select a customer !"))
    ((or (equal month nil) (< month 1) (> month 12)) (format t "~%[ERROR] Invalid Month format ! Use numbers between [1 ; 12]"))
    ((or (equal day nil) (< day 1) (> day 31)) (format t "~%[ERROR] Invalid Day format ! Use numbers between [1 ; 31]"))
    ((or (equal year nil) (< year 0)) (format t "~%[ERROR] Invalid Year format ! Use positive number"))

    (functional:else 
      (setf (value rating-field) (borrowing-system:getCustomerRating (oo:from-string-summary 'users:Customer selected-customer)))
      (setf (value due-date-field) (borrowing-system:dateToStringFormat (borrowing-system:calculDueDate month day year)))
      (setf (value price-field) (payment-system:computeTransactionPrice (oo:from-string-summary 'users:Customer selected-customer) :borrow-book))
    )
  ))

t) ;; end function

(defun borrow-confirm-button-on-click (dialog widget)
  ;; function body
  (declare (ignorable dialog widget))
  (let* (
    (selected-book (oo:from-string-summary 'stock:BookItem (value (find-component :available-book-list dialog))))
    (selected-customer (oo:from-string-summary 'users:Customer (value (find-component :customer-dropdown dialog))))
    (month (handler-case (parse-integer (value (find-component :borrow-month-field dialog))) (parse-error () nil)))
    (day (handler-case (parse-integer (value (find-component :borrow-day-field dialog))) (parse-error () nil)))
    (year (handler-case (parse-integer (value (find-component :borrow-year-field dialog))) (parse-error () nil)))
    )
  
  (payment-system:makePayment selected-customer :borrow-book)

  (borrowing-system:borrowBookItem
    selected-book
    selected-customer
    :date (borrowing-system:make-tDate :month month :day day :year year)
  )

  (format t "~%[INFO] (~A) has borrow the book : (~A)"
    (oo:to-string-summary selected-customer)
    (oo:to-string-summary selected-book)
  )

  ;; refresh the list of books available
  (fillBooksAvailable dialog)
  )

t) ;; end function
