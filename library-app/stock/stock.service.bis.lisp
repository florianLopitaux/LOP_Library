(in-package :stock)


;;; =====================================
;;; SERVICE FUNCTIONS
;;; =====================================

(def-function createBookItem (
    (book-ref :type BookReference :documentation "The reference of this new book copy")
    &key
    (book-state :type eBookCondition :documentation "OPTIONAL, by default :perfect book condition")
  )
  ;; function documentation
  (
    :documentation "Create a new book copy in the storage of the library"
    :examples "(createBookItem #<BookReference[...]* ...>) -> #BookItem[59]* ... :perfect, (createBookItem #<BookReference[...]* ...> :book-state :damage) -> #BookItem[59]* ... :damage"
    :pre (not (equal book-ref nil))
    :post (equal book-ref (get-book-ref :result))
    :result-type BookItem
  )

  ;; function body
  (cond ((equal nil book-state) (make-instance 'BookItem :book-ref book-ref))
        (else (make-instance 'BookItem :book-ref book-ref :state book-state))
  )
) ;; end function


(def-process processEventBookDelivered (event :type eventBookDelivered)
  (createBookItem (get-book-ref event))
) ;; end process


(def-function orderNewBookItem (
    (book-ref :type BookReference :documentation "The reference of this new book copy")
  )
  ;; function documentation
  (
    :documentation "Order a new book copy for the library storage from a book reference"
    :examples "(orderNewBookItem #<BookReference[...]* ...>) -> "
    :pre (not (equal book-ref nil))
  )

  ;; function body
  (progn
    (timer-voucher :minutes 1)  ;; simulate delivery
    (handle-event (make-instance 'eventBookDelivered book-ref))
  )
  
) ;; end function
